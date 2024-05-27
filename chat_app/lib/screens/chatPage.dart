import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/colors.dart';
import 'package:chat_app/components/noMessage.dart';
import 'package:chat_app/components/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/inputfield.dart';
import '../components/loading.dart';
import '../services/auth/auth_service.dart';
import '../services/chat/chat_services.dart';

class chatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  chatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  // text controller
  final TextEditingController messageController = TextEditingController();

  //  chat & auth services
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  // for textfield focus
  FocusNode myfocusNode = FocusNode();

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // add listener
    myfocusNode.addListener(() {
      if (myfocusNode.hasFocus) {
        // wait for keyboard to show up
        Future.delayed(Duration(milliseconds: 500), () {
          // scroll to bottom
          scrollDown();
        });
      }
    });
  }

  @override
  void dispose() {
    // remove listener
    messageController.dispose();
    myfocusNode.dispose();
    super.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  // send message
  void sendMessage() async {
    // if there is something to send
    if (messageController.text.isNotEmpty) {
      // send message
      await chatService.sendMessage(widget.receiverID, messageController.text);
      messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offwhite,
      appBar: AppBar(
        title: AppText(
            text: widget.receiverEmail, size: 18, color: AppColors.darkgrey),
      ),
      body: Column(
        children: [
          // display messages
          Expanded(child: _buildMessages()),

          // input field
          Container(
            child: _buildUserInput(),
            decoration: BoxDecoration(
              color: AppColors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessages() {
    String senderID = authService.getCurrentUser()!.uid;

    return StreamBuilder(
      stream: chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        if (snapshot.data!.docs.isEmpty) {
          return const noMessage();
        } else {
          // After messages are built, scroll down
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollDown();
          });

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              controller: _scrollController,
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItems(doc))
                  .toList(),
            ),
          );
        }
      },
    );
  }

  // build message items
  Widget _buildMessageItems(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    final message = data["message"];
    final senderID = data["senderID"];
    Timestamp time = data["timestamp"];

    bool isCurrentUser = data["senderID"] == authService.getCurrentUser()!.uid;

    return Container(
        child: Column(
      children: [
        ChatBubble(
            timestamp: time,
            isCurrentUser: isCurrentUser,
            message: message,
            senderID: senderID,
            recieverID: widget.receiverID),
      ],
    ));
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              focusNode: myfocusNode,
              controller: messageController,
              hintText: 'Type a message',
              cursorColor: AppColors.darkgrey,
            ),
          ),
          IconButton(
            iconSize: 50,
            onPressed: sendMessage,
            icon: Icon(Icons.send),
            color: AppColors.blue,
          )
        ],
      ),
    );
  }
}
