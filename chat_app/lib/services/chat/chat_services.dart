import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/message.dart';

class ChatService {
  // get instance of for Firebase Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final userData = doc.data();
        userData['uid'] = doc.id;
        return userData;
      }).toList();
    });
  }

  Future<bool> sendMessage(String receiverID, message) async {
    try {
      // Get current user
      final currentUser = _auth.currentUser!;
      final String currentUserID = currentUser.uid;
      final String currentUserEmail = currentUser.email!;

      // Create new message
      Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: Timestamp.now(),
      );

      // Make room ID
      List<String> ids = [currentUserID, receiverID];
      ids.sort(); // Ensures that 2 people have the same IDs
      String chatRoomID = ids.join('_');

      // Add message to database
      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .doc() // Generate unique document ID
          .set(newMessage.toMap());

      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
      // Handle the error as needed
    }
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String receiverID, String myID) {
    List<String> ids = [receiverID, myID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots();
  }

  Stream<DocumentSnapshot?> getLastMessage(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first;
      } else {
        return null;
      }
    });
  }

  // delete message
  Future<void> deleteMessage(String senderID, String message, String receiverID,
      BuildContext context) async {
    List<String> ids = [senderID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    try {
      // Print debug information
      print(senderID);
      print(message);
      print(chatRoomID);

      // Query to find the message document
      QuerySnapshot querySnapshot = await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection('messages')
          .where('senderID', isEqualTo: senderID)
          .where('message', isEqualTo: message)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        try {
          await _firestore
              .collection("chat_rooms")
              .doc(chatRoomID)
              .collection('messages')
              .doc(doc.id)
              .delete();
          print('Document ${doc.id} deleted successfully');
        } catch (e) {
          print('Failed to delete document ${doc.id}: $e');
        }
      }
    } catch (e) {
      print('Error deleting message: $e');
      // Handle the error as needed
    }
  }

  Future<void> markMessagesAsRead(
      String chatRoomID, String currentUserID) async {
    try {
      // Get the unread messages for the current user
      QuerySnapshot unreadMessages = await FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .where("receiverID", isEqualTo: currentUserID)
          .where("status", isEqualTo: "unread")
          .get();

      // Batch update the messages to mark them as read
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (QueryDocumentSnapshot doc in unreadMessages.docs) {
        batch.update(doc.reference, {'status': 'read'});
      }

      // Commit the batch
      await batch.commit();
    } catch (e) {
      print('Error updating messages to read: $e');
    }
  }

  // GET UNREAD MESSAGES
  Stream<QuerySnapshot> getUnreadMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .where("status", isEqualTo: "unread")
        .snapshots();
  }

  // GET STREAM OF USERS I'VE CHATTED WITH
  Stream<List<String>> getChatUsers(String userID) {
    final sentMessagesStream = FirebaseFirestore.instance
        .collectionGroup("messages")
        .where("senderID", isEqualTo: userID)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'userID': doc['receiverID'] as String,
          'timestamp': (doc['timestamp'] as Timestamp).millisecondsSinceEpoch,
        };
      }).toList();
    });

    final receivedMessagesStream = FirebaseFirestore.instance
        .collectionGroup("messages")
        .where("receiverID", isEqualTo: userID)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'userID': doc['senderID'] as String,
          'timestamp': (doc['timestamp'] as Timestamp).millisecondsSinceEpoch,
        };
      }).toList();
    });

    // Combine both streams
    return Rx.combineLatest2<
            List<Map<String, dynamic>>,
            List<Map<String, dynamic>>,
            List<String>>(sentMessagesStream, receivedMessagesStream,
        (sent, received) {
      final allUsers = <String, int>{};

      for (var message in sent) {
        final userID = message['userID'] as String;
        final timestamp = message['timestamp'] as int;
        if (!allUsers.containsKey(userID) || allUsers[userID]! < timestamp) {
          allUsers[userID] = timestamp;
        }
      }

      for (var message in received) {
        final userID = message['userID'] as String;
        final timestamp = message['timestamp'] as int;
        if (!allUsers.containsKey(userID) || allUsers[userID]! < timestamp) {
          allUsers[userID] = timestamp;
        }
      }

      // Sort users by timestamp in descending order
      final sortedUsers = allUsers.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sortedUsers.map((entry) => entry.key).toList();
    });
  }
}
