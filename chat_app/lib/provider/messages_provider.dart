import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

final chatUsersProvider = StreamProvider<List<String>>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  final authService = ref.watch(authServiceProvider);

  final currentUser = authService.getCurrentUser();
  if (currentUser != null) {
    return chatService.getChatUsers(currentUser.uid);
  } else {
    return const Stream.empty();
  }
});
