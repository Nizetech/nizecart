import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String name;
  final String profilePic;
  final String chatId;
  final DateTime timeSent;
  final String lastMessages;
  Chat(
      {this.name,
      this.profilePic,
      this.chatId,
      this.timeSent,
      this.lastMessages});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profilePic': profilePic,
      'chatId': chatId,
      'timeSent': FieldValue.serverTimestamp(),
      'lastMessages': lastMessages,
    };
  }

  factory Chat.fromJson(Map<String, dynamic> data) {
    return Chat(
      name: data['name'],
      profilePic: data['profilePic'],
      chatId: data['contactId'],
      timeSent: data[FieldValue.serverTimestamp()],
      lastMessages: data['lastMessages'] ?? '',
    );
  }
}
