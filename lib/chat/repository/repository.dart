import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nizecart/Models/messages.dart';
import 'package:nizecart/Models/user_model.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:uuid/uuid.dart';

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

  static CollectionReference admins =
      FirebaseFirestore.instance.collection('Admin');
  static CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('Chats');

  String get userId {
    return auth.currentUser.uid;
  }

  User user;

  // Chat Id
  String getChatID(String Id, String adminID) {
    int comp = Id.compareTo(adminID);
    String chatId;
    if (comp == -1) {
      chatId = Id + '-Nize-' + adminID;
    } else {
      chatId = adminID + '-Nize-' + Id;
    }
    return chatId;
  }

// String getChatRoomIdByUserId(String userID, String peerID) {
//     return userID.hashCode <= peerID.hashCode.
//         ? userID + '_' + peerID
//         : peerID + '_' + userID;
//   }
  // Get admin id

  Future<List> adminDetails() async {
    CollectionReference adminCollection = firestore.collection('Admin');
    try {
      QuerySnapshot shot = await adminCollection.get();

      print('Admin details ${shot}');
      return shot.docs;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Mark as read

  //  Future<void> markAsRead(String uid) async {
  //   try {
  //     String senderId = user.uid;
  //     String chatId = getChatID(senderId, uid);
  //     await chatsCollection.doc(chatId).set({
  //       'unreadMessages': {user.uid: 0}
  //     }, SetOptions(merge: true));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

// Stream current User chat
  Stream<QuerySnapshot<Object>> getChats() {
    String receiver = 'peYLb9DBDSWZIYuvVT83BGKi3Xq2';

    String chatID = getChatID(userId, receiver);
    return chatsCollection
        .doc(chatID)
        .collection('Messages')
        .where('users', arrayContains: userId)
        .snapshots();
  }

  // String adminId;

  // Future<Map<String, dynamic>> adminsId() async {
  //   Map admin = await adminDetails();
  //   adminId = admin['uid'];
  //   return admin;
  // }

  // Stream chatMessages
  Stream<QuerySnapshot> getChatMessages(String uid) {
    // String senderId = userId;
    String chatID = getChatID(userId, uid);
    return chatsCollection.doc(chatID).collection('Messages').snapshots();
  }

  // Send massage
  Future<void> sendMessage({
    String text,
    String username,
    String photoUrl,
    // String receiverToken,
  }) async {
    try {
      // String senderId = userId;
      String receiver = 'peYLb9DBDSWZIYuvVT83BGKi3Xq2';
      String chatID = getChatID(userId, receiver);
      String messageId = DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, dynamic> data = {};

      data['id'] = messageId;
      data['date'] = FieldValue.serverTimestamp();
      data['sender'] = userId;
      data['admin_receiver'] = receiver;
      data['text'] = text;
      data['username'] = username;
      data['photoUrl'] = photoUrl;
      data['users'] = [userId, receiver];
      data['chatID'] = chatID;

      await chatsCollection
          .doc(chatID)
          .collection('Messages')
          .doc(messageId)
          .set(data);

      //Save last message
      await chatsCollection.doc(chatID).set(
        {
          'lastMessage': text,
          'photoUrl': photoUrl,
          'username': username,
          'lastMessageDate': FieldValue.serverTimestamp(),
          'users': [userId, receiver],
          'unreadMessages': {
            receiver: FieldValue.increment(1),
          },
        },

        //  SetOptions(merge: true)
      );
      // print('message Sent: $data');
      //  NotifService().sendMessageNotif(token: receiverToken, message: text);
    } catch (e) {
      log(e.toString());
    }
  }

  String uid = Uuid().v1();
}
