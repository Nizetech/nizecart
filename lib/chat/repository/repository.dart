import 'dart:developer';
import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nizecart/Models/enums.dart';
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
  final FirebaseStorage firebaseStorage;
  ChatRepository({
    this.auth,
    this.firestore,
    this.firebaseStorage,
  });

  static CollectionReference admins =
      FirebaseFirestore.instance.collection('Admin');
  static CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('Chats');

  String get userId {
    return auth.currentUser.uid;
  }

  // Future<String> get adminId async {

  //   QuerySnapshot<Object> data = await admins.get();
  //   // data.docs.first.get('uid');
  //   return data.docs.first.get('uid');
  // }

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

  // String userTest = 'z8IxwlkJrPQjwlFw3cVGd2MrH8Z2z8IxwlkJrPQjwlFw3cVGd2MrH8Z2';

  // Get admin id
  Stream<QuerySnapshot<Object>> adminDetails() {
    CollectionReference adminCollection = firestore.collection('Admin');
    try {
      Stream<QuerySnapshot<Object>> shot = adminCollection.snapshots();
      print('Admin details ${shot}');
      return shot;
    } catch (e) {
      print(e.toString());
      return null;
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
  Stream<QuerySnapshot<Object>> getChats(String adminId) {
    // String receiver = admins.doc().id;

    String id =
        // '6Z4DLOW6pu0bFonyU7oa-Nize-z8IxwlkJrPQjwlFw3cVGd2MrH8Z2z8IxwlkJrPQjwlFw3cVGd2MrH8Z2';
        'MNoM1gwcz9WEHqKjuT0E-Nize-z8IxwlkJrPQjwlFw3cVGd2MrH8Z2z8IxwlkJrPQjwlFw3cVGd2MrH8Z2';
    // jkaPCZnOLuECgihMwI3j-Nize-z8IxwlkJrPQjwlFw3cVGd2MrH8Z2z8IxwlkJrPQjwlFw3cVGd2MrH8Z2
    // sMZxqgQUUfUEaFKvP8RB-Nize-z8IxwlkJrPQjwlFw3cVGd2MrH8Z2z8IxwlkJrPQjwlFw3cVGd2MrH8Z2
    // uJIamqeQWcLTFQiH5voR-Nize-z8IxwlkJrPQjwlFw3cVGd2MrH8Z2z8IxwlkJrPQjwlFw3cVGd2MrH8Z2
    // 6Z4DLOW6pu0bFonyU7oa-Nize-z8IxwlkJrPQjwlFw3cVGd2MrH8Z2z8IxwlkJrPQjwlFw3cVGd2MrH8Z2

    String chatID = getChatID(userId, adminId);
    try {
      return chatsCollection
          .doc(chatID)
          .collection('Messages')
          // .where('users', arrayContains: adminId)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
  }

  // String adminId;
  // Future<Map<String, dynamic>> adminsId() async {
  //   Map admin = await adminDetails();
  //   adminId = admin['uid'];
  //   return admin;
  // }

  // Stream chatMessages
  // Stream<QuerySnapshot> getChatMessages(String uid) {
  //   // String senderId = userId;
  //   String chatID = getChatID(userId, uid);
  //   return chatsCollection.doc(chatID).collection('Messages').snapshots();
  // }

  // Send Image
  // Future<String> uploadChatImage(File image) async {

  //   final imageId = '${DateTime.now().millisecondsSinceEpoch}';
  //   try {
  //     //Upload image to firebase storage
  //     // UploadTask uploadTask = storageReference.child(userId).putFile((image));
  //     // Get url of image
  //     String imageUrl;
  //     var ref =
  //         FirebaseStorage.instance.ref().child('chatImages').child(imageId);
  //     await ref.putFile(image);
  //     imageUrl = await ref.getDownloadURL();

  //     print(imageUrl);
  //     return imageUrl;
  //   } catch (e) {
  //     print(e.toString());
  //     // toast(e.toString());
  //     return '';
  //   }
  // }

  // Send massage
  Future<void> sendTextMessage({
    String text,
    String username,
    String adminId,
    // MessageType messageType,
    String receiverToken,
    File image,
  }) async {
    try {
      String chatImage = '';
      // String senderId = userId;
      // String receiver = admins.doc().id;
      String chatID = getChatID(userId, adminId);
      String messageId = DateTime.now().millisecondsSinceEpoch.toString();

      Map<String, dynamic> data = {};
      // Upload image;
      if (image != null) {
        chatImage = await uploadImage(image: image);
      }

      data['id'] = messageId;
      data['date'] = FieldValue.serverTimestamp();
      data['sender'] = userId;
      data['admin_adminId'] = adminId;
      data['text'] = text;

      // data['messageType'] = messageType;

      data['username'] = username;
      data['users'] = [userId, adminId];
      data['chatID'] = chatID;
      data['chatImage'] = chatImage ?? '';

      await chatsCollection
          .doc(chatID)
          .collection('Messages')
          .doc(messageId)
          .set(data);
      print('(========>)');
      print(adminId);
      print('(========>)');
      //Save last message
      await chatsCollection.doc(chatID).set(
        {
          'lastMessage': text,
          'chatImage': chatImage ?? '',
          'token': receiverToken,
          'username': username,

          'lastMessageDate': FieldValue.serverTimestamp(),
          'users': [userId, adminId],
          // 'unreadMessages': {
          //   receiver: FieldValue.increment(1),
          // },
        },

        // await sendMessage();

        //  SetOptions(merge: true)
      );
      // print('message Sent: $data');
      //  NotifService().sendMessageNotif(token: receiverToken, message: text);
    } catch (e) {
      log(e.toString());
    }
  }

  // // Send massage
  // Future<void> sendImage({
  //   String chatImage,
  //   String username,
  //   // MessageType messageType,
  //   String receiverToken,
  //   String adminId,
  //   File image,
  // }) async {
  //   try {

  //     // String receiver = 'peYLb9DBDSWZIYuvVT83BGKi3Xq2';
  //     String chatID = getChatID(userId, adminId);

  //     String messageId = DateTime.now().millisecondsSinceEpoch.toString();
  //     Map<String, dynamic> data = {};

  //     data['id'] = messageId;
  //     data['date'] = FieldValue.serverTimestamp();
  //     data['sender'] = userId;
  //     data['admin_receiver'] = adminId;
  //     data['image'] = imageUrl;
  //     data['username'] = username;
  //     data['users'] = [userId, adminId];
  //     data['chatID'] = chatID;

  //     await chatsCollection
  //         .doc(chatID)
  //         .collection('Messages')
  //         .doc(messageId)
  //         .set(data);

  //     //Save last message
  //     await chatsCollection.doc(chatID).set(
  //       {
  //         'lastMessage': '📷 Photo',
  //         'username': username,
  //         'lastMessageDate': FieldValue.serverTimestamp(),
  //         'users': [userId, adminId],
  //         'photoUrl': imageUrl ?? '',
  //         'token': receiverToken,
  //       },

  //       //  SetOptions(merge: true)
  //     );
  //     // print('message Sent: $data');
  //     //  NotifService().sendMessageNotif(token: receiverToken, message: text);
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  String uid = Uuid().v1();

  Future<String> uploadImage({File image}) async {
    try {
      String imageID = '${DateTime.now().millisecondsSinceEpoch}';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('chatImages/$imageID');
      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print(e.toString());
    }
  }
}
