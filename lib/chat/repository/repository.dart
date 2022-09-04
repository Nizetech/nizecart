import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nizecart/Models/messages.dart';
import 'package:nizecart/Models/user_model.dart';
import 'package:nizecart/Widget/component.dart';

import '../../Models/chat_model.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ));

class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  ChatRepository({
    this.auth,
    this.firestore,
  });
// To  get the list of people youre chatting with or can chat with
  Stream<List<Chat>> getChatList() {
    return firestore
        .collection('Users')
        .doc(auth.currentUser.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<Chat> chatList = [];
      for (var doc in event.docs) {
        var chat = Chat.fromJson(doc.data());
        var userData =
            await firestore.collection('Users').doc(chat.chatId).get();
        var user = UserModel.fromMap(userData.data());
        chatList.add(Chat(
            name: user.fname,
            profilePic: user.photoUrl,
            chatId: chat.chatId,
            timeSent: chat.timeSent,
            lastMessages: chat.lastMessages));
      }
      return chatList;
    });
  }

  // Getting message Stream
  Stream<List<Messages>> getChatStream(String receiverId) {
    return firestore
        .collection('Users')
        .doc(auth.currentUser.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .snapshots()
        .map((event) {
      List<Messages> messages = [];
      for (var doc in event.docs) {
        messages.add(Messages.fromJson(doc.data()));
      }
      return messages;
    });
  }

  // Saving(this data to contact sub collection) this is d preview data you see before going into th DM..
  void saveDataToContactSubcollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
  ) async {
    /// For the receiver's end
    var receiverChatContact = Chat(
      name: senderUserData.fname,
      profilePic: senderUserData.photoUrl,
      chatId: senderUserData.uid,
      timeSent: timeSent,
      lastMessages: text,
    );
    await firestore
        .collection('Users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser.uid)
        .set(receiverUserData.toMap());

    // Sender's end
    var senderChatContact = Chat(
      name: receiverUserData.fname,
      profilePic: receiverUserData.photoUrl,
      chatId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessages: text,
    );
    await firestore
        .collection('Users')
        .doc(auth.currentUser.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(senderUserData.toMap());
  }

  //(Saving this Data) this is the chat messages from both end(end to end --> Sender to Receiver)
  void saveMessageToMessagesSubCollection({
    String receiverUserId,
    String text,
    DateTime timeSent,
    String messageId,
    String userName,
    String receiverUserName,
  }) async {
    final message = Messages(
      senderId: auth.currentUser.uid,
      receiverId: receiverUserId,
      text: text,
      messageId: messageId,
      isSeen: false,
    );
    // saving message to senders message collection
    await firestore
        .collection('Users')
        .doc(auth.currentUser.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());
    // saving message to receiver's message collection
    await firestore
        .collection('Users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());
  }

  // Sending Message
  void sendTextMessages({
    String text,
    String receiverUserId,
    UserModel sender,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var messageId = '${DateTime.now().millisecondsSinceEpoch}';
      saveDataToContactSubcollection(
        sender,
        receiverUserData,
        text,
        timeSent,
        receiverUserId,
      );

      saveMessageToMessagesSubCollection(
        receiverUserId: receiverUserId,
        text: text,
        messageId: messageId,
        userName: sender.fname,
        receiverUserName: receiverUserData.fname,
        timeSent: timeSent,
      );
    } catch (e) {
      showErrorToast(e.toString());
    }
  }
}
