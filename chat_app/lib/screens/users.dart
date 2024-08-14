import 'package:chat_app/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../components/loading.dart';
import '../components/UserTile.dart';
import '../services/auth/auth_service.dart';
import 'chatPage.dart';

class Users extends ConsumerWidget {
  const Users({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: users.when(
            data: (userList) {
              if (userList.isEmpty) {
                return const Center(child: Text('No users found'));
              }

              return Column(
                children: userList
                    .map<Widget>(
                        (userData) => _buildUserListItem(userData, context))
                    .toList(),
              );
            },
            loading: () => const Center(child: Loading()),
            error: (error, stack) =>
                const Center(child: Text('An error occurred')),
          ),
        ),
      ),
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    final authService = AuthService();
    if (userData["email"] != authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context,
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
  }
}
