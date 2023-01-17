import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/Auth/repository/auth_repository.dart';
import 'package:nizecart/Models/enums.dart';

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

  //chat Image
  Future<String> uploadChatImage(File image) {
    return chatRepository.uploadChatImage(image);
  }

// Send message
  Future<void> sendMessage({
    String text,
    String username,
    String chatImage,
    // MessageType messageType,
  }) {
    return chatRepository.sendMessage(
      text: text,
      username: username,

      // messageType: messageType,
    );
  }

// Send Image
  Future<void> sendImage({
    String imageUrl,
    String username,
    String chatImage,
    MessageType messageType,
  }) {
    return chatRepository.sendImage(
      imageUrl: imageUrl,
      username: username,
      // chatImage: chatImage,
      messageType: messageType,
    );
  }
}
