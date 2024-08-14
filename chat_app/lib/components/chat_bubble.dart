import 'package:chat_app/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import '../services/chat/chat_services.dart';
import 'colors.dart';
import 'text.dart';
import 'package:intl/intl.dart'; // Import DateFormat from the intl package

class ChatBubble extends StatefulWidget {
  final Timestamp timestamp; // Correcting the timestamp declaration
  final String recieverID;
  final String message;
  final String status;
  final bool isCurrentUser;
  final String senderID;

  ChatBubble({
    super.key,
    required this.timestamp,
    required this.recieverID,
    required this.isCurrentUser,
    required this.message,
    required this.status,
    required this.senderID,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool showTimestamp = false;
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var alignment =
        widget.isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: GestureDetector(
        onLongPress: () async {
          if (widget.isCurrentUser) {
            bool confirmDelete = await _showDeleteConfirmationDialog(context);
            if (confirmDelete) {
              await chatService.deleteMessage(
                  widget.senderID, widget.message, widget.recieverID, context);
              if (context.mounted) {
                showSuccessSnackBar(context, "Message deleted");
              }
            }
          } else {}
        },
        onTap: () {
          setState(() {
            showTimestamp = !showTimestamp;
          });
        },
        child: Column(
          crossAxisAlignment: widget.isCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (showTimestamp)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${widget.status} · ${_formatTimestamp(widget.timestamp)}',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.senderID == authService.getCurrentUser()!.uid
                    ? AppColors.blue
                    : AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: AppText(
                text: widget.message,
                size: 16,
                color: widget.senderID == authService.getCurrentUser()!.uid
                    ? AppColors.white
                    : AppColors.darkgrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    // Convert Firestore Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the DateTime to display the time with AM/PM
    String formattedTime = DateFormat('MM/dd/yy · hh:mm a').format(dateTime);

    return formattedTime;
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
