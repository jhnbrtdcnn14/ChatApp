import 'package:chat_app/components/colors.dart';
import 'package:chat_app/components/loading.dart';
import 'package:chat_app/components/text.dart';
import 'package:flutter/material.dart';

import '../components/UserTile.dart';
import '../components/bottomSheetContent.dart';
import '../services/auth/auth_service.dart';
import '../services/chat/chat_services.dart';
import 'chatPage.dart';
import 'viewprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // chat and auth services
  final ChatService chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // Track HomePage execution
    return Scaffold(
      backgroundColor: AppColors.offwhite,

      // APPBAR
      appBar: AppBar(
        title: const AppText(
            text: "E-Connect",
            isBold: true,
            size: 20,
            color: AppColors.darkgrey),
        backgroundColor: AppColors.white,
        leading: IconButton(
          color: AppColors.blue,
          icon: const Icon(Icons.send),
          onPressed: () {},
          iconSize: 40,
        ),
        actions: [
          IconButton(
            color: AppColors.lightgrey,
            icon: const Icon(Icons.person_rounded),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          IconButton(
            color: AppColors.lightgrey,
            icon: const Icon(Icons.menu),
            onPressed: () {
              _showBottomSheet(context);
            },
          ),
        ],
      ),

      // BODY
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _buildUserList(),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      scrollControlDisabledMaxHeightRatio: 200,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return BottomSheetContent();
      },
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.only(top: 100),
            child: Loading(),
          );
        }

        if (snapshot.hasError) {
          return const Center(child: Text('An error occurred'));
        }

        return Column(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    final currentUserId = _authService.getCurrentUser()!.uid;

    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return StreamBuilder<QuerySnapshot>(
        stream: getMessages(currentUserId, userData["uid"]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final newMessagesCount = snapshot.data!.docs.length;

              return UserTile(
                text: userData["email"],
                newMessagesCount: newMessagesCount,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => chatPage(
                        receiverEmail: userData["email"],
                        receiverID: userData["uid"],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        },
      );
    } else {
      return Container();
    }
  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .where("status", isEqualTo: "new")
        .snapshots();
  }
}
