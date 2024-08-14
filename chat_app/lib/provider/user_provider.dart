import 'package:chat_app/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final chatService = ChatService();
  return chatService.getUserStream();
});


final userDocumentProvider =
    StreamProvider.family<DocumentSnapshot<Map<String, dynamic>>, String>(
  (ref, receiverID) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(receiverID)
        .snapshots();
  },
);
