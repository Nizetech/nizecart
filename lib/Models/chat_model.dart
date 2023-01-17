import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nizecart/Models/enums.dart';

class Chat {
  final String name;
  final String profilePic;
  final String chatId;
  final DateTime timeSent;
  final String lastMessages;
  final MessageType messageType;
  Chat({
    this.name,
    this.profilePic,
    this.chatId,
    this.timeSent,
    this.lastMessages,
    this.messageType,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profilePic': profilePic,
      'chatId': chatId,
      'timeSent': FieldValue.serverTimestamp(),
      'lastMessages': lastMessages,
      'messageType': MessageType,
    };
  }

  factory Chat.fromJson(Map<String, dynamic> data) {
    return Chat(
      name: data['name'],
      profilePic: data['profilePic'],
      chatId: data['contactId'],
      messageType: data['messageType'],
      timeSent: data[FieldValue.serverTimestamp()],
      lastMessages: data['lastMessages'] ?? '',
    );
  }
}
