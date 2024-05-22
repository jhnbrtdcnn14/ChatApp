import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/message.dart';

class ChatService {
  // get instance of for Firebase Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each document and get the data
        final user_data = doc.data();
        return user_data;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, message) async {
    // get current user
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create new user

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // make room ID
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // ensures that 2 people have smae ids
    String chatRoomID = ids.join('_');

    // add message to detabase

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots();
  }

  Stream<int> countNewMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .where("status", isEqualTo: "new")
        .where("senderID", isNotEqualTo: userID)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
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
}
