import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final List userIds;
  final String receiverId;
  final String text;
  final DateTime timeSent;
  final String messageId;
  final String repliedTo;
  final bool isSeen;
  Messages(
      {this.userIds,
      this.receiverId,
      this.text,
      this.timeSent,
      this.repliedTo,
      this.messageId,
      this.isSeen});

  Map<String, dynamic> toJson() {
    return {
      'senderId': userIds,
      'receiverId': receiverId,
      'text': text,
      'timeSent': FieldValue.serverTimestamp(),
      'messageId': messageId,
      'repliedTo': repliedTo,
      'isSeen': isSeen,
    };
  }

  factory Messages.fromJson(Map<String, dynamic> data) {
    return Messages(
      userIds: data['userIds'] ?? '',
      receiverId: data['receiverId'] ?? '',
      text: data['text'] ?? '',
      timeSent: data[FieldValue.serverTimestamp()],
      messageId: data['messageId'] ?? '',
      repliedTo: data['repliedTo'] ?? '',
      isSeen: data['isSeen'] ?? '',
    );
  }
}
