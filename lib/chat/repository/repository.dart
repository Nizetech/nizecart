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

  // Send Image
  Future<String> uploadChatImage(File image) async {
    // Reference storageReference = firebaseStorage.ref('chatImages');
    // CollectionReference collectionReference = firestore.collection('Users');
    final imageId = '${DateTime.now().millisecondsSinceEpoch}';
    try {
      //Upload image to firebase storage
      // UploadTask uploadTask = storageReference.child(userId).putFile((image));
      // Get url of image
      String imageUrl;
      var ref =
          FirebaseStorage.instance.ref().child('chatImages').child(imageId);
      await ref.putFile(image);
      imageUrl = await ref.getDownloadURL();

      // uploadTask.then((value) {
      //   value.ref.getDownloadURL().then((url) {
      //     imageUrl = url;
      //     collectionReference.doc(userId).set({
      //       'chatImage': imageUrl,
      //       // 'imageUploaded': true,
      //     });
      // });

      // });
      // await auth.currentUser.updateimageUrl(imageUrl);
      print(imageUrl);
      return imageUrl;
    } catch (e) {
      print(e.toString());
      // toast(e.toString());
      return '';
    }
  }

  // // upload product image
  // Future<String> uploadFile(
  //   File file,
  // ) async {
  //   Reference storageReference = firebaseStorage.ref('chatImages');
  //   final chatID = '${DateTime.now().millisecondsSinceEpoch}';
  //   // await storageReference.delete();
  //   var ref =
  //       FirebaseStorage.instance.ref().child('chatImages').child(chatID);
  //   await ref.putFile(file);
  //   var url = await ref.getDownloadURL();
  //   print(url);
  //   return url;
  // }

  //  setState(() {
  //         storedImage = File(croppedFile.path);
  //       });

  // Send massage
  Future<void> sendMessage({
    String text,
    String username,

    // MessageType messageType,
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

      // data['messageType'] = messageType;

      data['username'] = username;
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
          // 'messageType': messageType,
          // 'chatImage': chatImage,
          'username': username,
          'lastMessageDate': FieldValue.serverTimestamp(),
          'users': [userId, receiver],
          // 'unreadMessages': {
          //   receiver: FieldValue.increment(1),
          // },
        },

        //  SetOptions(merge: true)
      );
      // print('message Sent: $data');
      //  NotifService().sendMessageNotif(token: receiverToken, message: text);
    } catch (e) {
      log(e.toString());
    }
  }

  // Send massage
  Future<void> sendImage({
    String imageUrl,
    String username,
    MessageType messageType,
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
      data['image'] = imageUrl;
      data['username'] = username;
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
          'lastMessage': '📷 Photo',
          'username': username,
          'lastMessageDate': FieldValue.serverTimestamp(),
          'users': [userId, receiver],
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
