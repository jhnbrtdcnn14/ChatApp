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

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ChatPage({super.key, required this.userData});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<IconStatus> _iconStatus = ValueNotifier(IconStatus.send);

  late String receiverEmail = '';
  late String receiverID = '';

  @override
  void initState() {
    super.initState();
    receiverEmail = widget.userData["email"];
    receiverID = widget.userData["uid"];
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _iconStatus.dispose();
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 500), _scrollDown);
    }
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _iconStatus.value = IconStatus.sending;
      final success = await _chatService.sendMessage(receiverID, message);
      _iconStatus.value = success ? IconStatus.success : IconStatus.error;
      if (success) {
        _messageController.clear();
      }
      Future.delayed(const Duration(seconds: 1), () {
        _iconStatus.value = IconStatus.send;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offwhite,
      appBar: AppBar(
        title: AppText(
          text: receiverEmail,
          size: 18,
          color: AppColors.darkgrey,
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessages()),
          Container(
            decoration: const BoxDecoration(color: AppColors.white),
            child: _buildUserInput(),
          ),
        ],
      ),
    );
  }


  Widget _buildMessages() {
    final senderID = _authService.getCurrentUser()!.uid;

    List<String> ids = [senderID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    ChatService().markMessagesAsRead(chatRoomID, senderID);

    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Error");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }
        if (snapshot.data!.docs.isEmpty) return const noMessage();

        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollDown());

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            controller: _scrollController,
            children: snapshot.data!.docs.map(_buildMessageItem).toList(),
          ),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final isCurrentUser =
        data["senderID"] == _authService.getCurrentUser()!.uid;

    return ChatBubble(
      timestamp: data["timestamp"] as Timestamp,
      isCurrentUser: isCurrentUser,
      message: data["message"] as String,
      status: data["status"] as String,
      senderID: data["senderID"] as String,
      recieverID: receiverID,
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              focusNode: _focusNode,
              controller: _messageController,
              hintText: 'Type a message',
              cursorColor: AppColors.darkgrey,
            ),
          ),
          ValueListenableBuilder<IconStatus>(
            valueListenable: _iconStatus,
            builder: (context, status, child) {
              Widget iconWidget;

              switch (status) {
                case IconStatus.sending:
                  iconWidget = const SizedBox(
                    width: 50,
                    height: 50,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        color: Colors.green,
                      ),
                    ),
                  );
                  break;
                case IconStatus.success:
                  iconWidget = const Icon(Icons.check_circle_outline,
                      color: Colors.green);
                  break;
                case IconStatus.error:
                  iconWidget =
                      const Icon(Icons.error_outline, color: Colors.red);
                  break;
                default:
                  iconWidget = const Icon(Icons.send, color: AppColors.blue);
              }

              return IconButton(
                iconSize: 50,
                onPressed: status == IconStatus.sending ? null : _sendMessage,
                icon: iconWidget,
              );
            },
          ),
        ],
      ),
    );
  }
}

enum IconStatus { send, sending, success, error }
