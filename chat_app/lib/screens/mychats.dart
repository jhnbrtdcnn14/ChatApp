import 'package:chat_app/components/noMessage.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/provider/messages_provider.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/components/loading.dart';
import 'package:chat_app/components/usertilemychat.dart';
import 'chatPage.dart';

class Mychat extends ConsumerWidget {
  const Mychat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _buildUserList(ref),
        ),
      ),
    );
  }

  Widget _buildUserList(WidgetRef ref) {
    final chatUsers = ref.watch(chatUsersProvider);

    return chatUsers.when(
      data: (chatUsers) {
        if (chatUsers.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: noMessage(),
          );
        }

        return Column(
          children: chatUsers
              .map<Widget>((receiverID) => _buildUserListItem(receiverID, ref))
              .toList(),
        );
      },
      loading: () => const Center(child: Loading()),
      error: (error, stackTrace) =>
          const Center(child: Text('An error occurred')),
    );
  }

  Widget _buildUserListItem(String receiverID, WidgetRef ref) {
    final currentUserId = ref.watch(authServiceProvider).getCurrentUser()!.uid;
    final userDocumentAsyncValue = ref.watch(userDocumentProvider(receiverID));

    return userDocumentAsyncValue.when(
      data: (user) {
        if (user.exists) {
          final userData = user.data()!;
          return UserTileMyChat(
            userData: userData,
            currentUserId: currentUserId,
            onTap: () {
              Navigator.push(
                ref.context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    userData: userData,
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
      loading: () => const Center(child: Loading()),
      error: (error, stack) => const Center(child: Text('An error occurred')),
    );
  }
}
