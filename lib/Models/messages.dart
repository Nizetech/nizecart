import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  Messages(
      {this.senderId,
      this.receiverId,
      this.text,
      this.timeSent,
      this.messageId,
      this.isSeen});

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timeSent': FieldValue.serverTimestamp(),
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory Messages.fromJson(Map<String, dynamic> data) {
    return Messages(
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      text: data['text'] ?? '',
      timeSent: data[FieldValue.serverTimestamp()],
      messageId: data['messageId'] ?? '',
      isSeen: data['isSeen'] ?? '',
    );
  }
}
