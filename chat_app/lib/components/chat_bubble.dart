import 'package:chat_app/components/snackbar.dart';
import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import '../services/chat/chat_services.dart';
import 'colors.dart';
import 'text.dart';

class ChatBubble extends StatelessWidget {
  final String recieverID;
  final String message;
  final bool isCurrentUser;
  final String senderID;

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  ChatBubble({
    super.key,
    required this.recieverID,
    required this.isCurrentUser,
    required this.message,
    required this.senderID,
  });

  @override
  Widget build(BuildContext context) {
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: GestureDetector(
        onLongPress: () async {
          if (isCurrentUser) {
            bool confirmDelete = await _showDeleteConfirmationDialog(context);
            if (confirmDelete) {
              await chatService.deleteMessage(
                  senderID, message, recieverID, context);
              if (context.mounted) {
                showSuccessSnackBar(context, "Message deleted");
              }
            }
          } else {}
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: senderID == authService.getCurrentUser()!.uid
                ? AppColors.blue
                : AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: AppText(
            text: message,
            size: 16,
            color: senderID == authService.getCurrentUser()!.uid
                ? AppColors.white
                : AppColors.darkgrey,
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Message'),
          content: Text('Are you sure you want to delete this message?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
