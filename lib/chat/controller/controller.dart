import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<QuerySnapshot> getChatMessages(String uid) {
    return chatRepository.getChatMessages(uid);
  }

  Stream<QuerySnapshot<Object>> getChats() {
    return chatRepository.getChats();
  }

// admin details
  Future<List> adminDetails() {
    return chatRepository.adminDetails();
  }

  Future<void> sendMessage({
    String text,
    String username,
    String photoUrl,
  }) {
    return chatRepository.sendMessage(
      text: text,
      username: username,
      photoUrl: photoUrl,
    );
  }
}
