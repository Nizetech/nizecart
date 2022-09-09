import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/Auth/repository/auth_repository.dart';

import '../../Models/chat_model.dart';
import '../../Models/messages.dart';
import '../../Models/user_model.dart';
import '../repository/repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({this.chatRepository, this.ref});

  Stream<List<Chat>> getChatList() {
    return chatRepository.getChatList();
  }

  Stream<List<Messages>> getChatStream(String receiverId) {
    return chatRepository.getChatStream(receiverId);
  }

  void sendTextMessages(
    String text,
    String receiverUserId,
  ) {
    ref.read(userDataAuthProvider).whenData((value) {
      UserModel sender;
      chatRepository.sendTextMessages(
        text: text,
        receiverUserId: receiverUserId,
        sender: sender,
      );
    });
  }
}
