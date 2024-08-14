import 'package:chat_app/components/colors.dart';
import 'package:chat_app/components/text.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserTileMyChat extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onTap;
  final String currentUserId;

  const UserTileMyChat({
    super.key,
    required this.userData,
    required this.onTap,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ChatService().getUnreadMessages(currentUserId, userData["uid"]),
      builder: (context, unreadSnapshot) {
        if (unreadSnapshot.connectionState != ConnectionState.active ||
            !unreadSnapshot.hasData) {
          return Container();
        }

        final unreadMessages = unreadSnapshot.data!.docs;
        final unreadMessagesCount = unreadMessages.length;

        return StreamBuilder<DocumentSnapshot?>(
          stream: ChatService().getLastMessage(currentUserId, userData["uid"]),
          builder: (context, lastMessageSnapshot) {
            if (lastMessageSnapshot.connectionState != ConnectionState.active ||
                !lastMessageSnapshot.hasData) {
              return Container();
            }

            final lastMessage = lastMessageSnapshot.data;
            final lastMessageText =
                lastMessage != null ? lastMessage.get("message") : '';
            final lastMessageSenderId =
                lastMessage != null ? lastMessage.get("senderID") : '';

            return _buildTileWithMessagesCount(
              unreadMessagesCount,
              lastMessageSenderId,
              lastMessageText,
              context,
            );
          },
        );
      },
    );
  }

  Widget _buildTileWithMessagesCount(
      int unreadMessagesCount,
      String lastMessageSenderId,
      String lastMessageText,
      BuildContext context) {
    final bool isCurrentUserSender = currentUserId == lastMessageSenderId;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.blue,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            title: AppText(
                text:
                    "${userData["firstname"]} ${userData["middlename"]} ${userData["lastname"]}",
                size: 20,
                color: AppColors.darkgrey),
            subtitle: AppText(
              text: isCurrentUserSender
                  ? 'You : $lastMessageText'
                  : '${userData["firstname"]}: $lastMessageText',
              size: 13,
              color: AppColors.darkgrey,
            ),
            trailing: unreadMessagesCount > 0
                ? CircleAvatar(
                    radius: 15,
                    backgroundColor:
                        isCurrentUserSender ? AppColors.offwhite : Colors.red,
                    child: AppText(
                      text: unreadMessagesCount.toString(),
                      size: 12,
                      color: isCurrentUserSender ? Colors.grey : Colors.white,
                      isBold: true,
                    ),
                  )
                : null,
            onTap: onTap,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
