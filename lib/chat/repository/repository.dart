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

  static CollectionReference admins =
      FirebaseFirestore.instance.collection('Admin');
  static CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('Chats');

  String get userId {
    return auth.currentUser.uid;
  }

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

  // Get admin id
  Future<Map> adminDetails() async {
    CollectionReference userCredential = firestore.collection('Admin');
    try {
      DocumentSnapshot shot = await userCredential.doc().get();
      print('User details ${shot}');
      return shot.data();
    } catch (e) {
      print(e.toString());
      return {};
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
    return chatsCollection.where('users', arrayContains: userId).snapshots();
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
    String receiver,
    // String receiverToken,
  }) async {
    try {
      // String senderId = userId;
      String chatID = getChatID(userId, receiver);
      String messageId = DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, dynamic> data = {};

      data['id'] = messageId;
      data['date'] = FieldValue.serverTimestamp();
      data['sender'] = userId;
      data['admin_receiver'] = receiver;
      data['text'] = text;

      await chatsCollection
          .doc(chatID)
          .collection('Messages')
          .doc(messageId)
          .set(data);

      //Save last message
      await chatsCollection.doc(chatID).set({
        'lastMessage': text,
        'lastMessageDate': FieldValue.serverTimestamp(),
        'users': [userId, receiver],
        'unreadMessages': {receiver: FieldValue.increment(1)},
      }, SetOptions(merge: true));

      //  NotifService().sendMessageNotif(token: receiverToken, message: text);
    } catch (e) {
      print(e);
    }
  }

// To  get the list of people youre chatting with or can chat with
  // Stream<List<Chat>> getChatList() {
  //   return firestore
  //       .collection('Users')
  //       .doc(auth.currentUser.uid)
  //       .collection('chats')
  //       .snapshots()
  //       .asyncMap((event) async {
  //     List<Chat> chatList = [];
  //     for (var doc in event.docs) {
  //       var chat = Chat.fromJson(doc.data());
  //       var userData =
  //           await firestore.collection('Users').doc(chat.chatId).get();
  //       var user = UserModel.fromMap(userData.data());
  //       chatList.add(
  //         Chat(
  //             name: user.firstName,
  //             profilePic: user.photoUrl,
  //             chatId: chat.chatId,
  //             timeSent: chat.timeSent,
  //             lastMessages: chat.lastMessages),
  //       );
  //     }
  //     return chatList;
  //   });
  // }

  // Getting message Stream
  // Stream<List<Messages>> getChatStream(String receiverId) {
  //   return firestore
  //       .collection('Users')
  //       .doc(auth.currentUser.uid)
  //       .collection('chats')
  //       .doc(receiverId)
  //       .collection('messages')
  //       .snapshots()
  //       .map((event) {
  //     List<Messages> messages = [];
  //     for (var doc in event.docs) {
  //       messages.add(Messages.fromJson(doc.data()));
  //     }
  //     return messages;
  //   });
  // }

  // Saving(this data to contact sub collection) this is d preview data you see before going into th DM..
  // void saveDataToContactSubcollection(
  //   UserModel senderUserData,
  //   UserModel receiverUserData,
  //   String text,
  //   DateTime timeSent,
  //   String receiverUserId,
  // ) async {
  //   /// For the receiver's end
  //   var receiverChatContact = Chat(
  //     name: senderUserData.firstName,
  //     profilePic: senderUserData.photoUrl,
  //     chatId: senderUserData.uid,
  //     timeSent: timeSent,
  //     lastMessages: text,
  //   );
  //   await firestore
  //       .collection('Users')
  //       .doc(receiverUserId)
  //       .collection('chats')
  //       .doc(auth.currentUser.uid)
  //       .set(receiverChatContact.toJson());

  //   // Sender's end
  //   var senderChatContact = Chat(
  //     name: receiverUserData.firstName,
  //     profilePic: receiverUserData.photoUrl,
  //     chatId: receiverUserData.uid,
  //     timeSent: timeSent,
  //     lastMessages: text,
  //   );

  //   await firestore
  //       .collection('Users')
  //       .doc(auth.currentUser.uid)
  //       .collection('chats')
  //       .doc(receiverUserId)
  //       .set(senderChatContact.toJson());
  // }

  //(Saving this Data) this is the chat messages from both end(end to end --> Sender to Receiver)
  // void saveMessageToMessagesSubCollection({
  //   List userIds,
  //   String text,
  //   DateTime timeSent,
  //   String messageId,
  //   String userName,
  //   String receiverUserName,
  // }) async {

  //   final message = Messages(
  //     // senderId: auth.currentUser.uid,
  //     userIds: [
  //       admin['uid'],
  //       userId,
  //     ],
  //     text: text,
  //     messageId: messageId,
  //     timeSent: DateTime.now(),
  //     isSeen: false,
  //   );
  //   String id = DateTime.now().millisecondsSinceEpoch.toString();

  //   // saving message to senders message collection
  //   await firestore
  //       .collection('Messages')
  //       .doc(auth.currentUser.uid)
  //       .collection('chats')
  //       .doc(messageId)
  //       .collection('messages')
  //       .doc(id)
  //       .set(message.toJson());

  //   // saving message to receiver's message collection
  //   await firestore
  //       .collection('Users')
  //       .doc(receiverUserId)
  //       .collection('chats')
  //       .doc(auth.currentUser.uid)
  //       .collection('messages')
  //       .doc(messageId)
  //       .set(message.toJson());
  // }

  // Sending Message
  // void sendTextMessages({
  //   String text,
  //   String receiverUserId,
  //   UserModel sender,
  // }) async {
  //   try {
  //     var timeSent = DateTime.now();
  //     UserModel receiverUserData;
  //     var messageId = '${DateTime.now().millisecondsSinceEpoch}';
  //     saveDataToContactSubcollection(
  //       sender,
  //       receiverUserData,
  //       text,
  //       timeSent,
  //       receiverUserId,
  //     );

  //     saveMessageToMessagesSubCollection(
  //       receiverUserId: receiverUserId,
  //       text: text,
  //       messageId: messageId,
  //       userName: sender.firstName,
  //       receiverUserName: receiverUserData.firstName,
  //       timeSent: timeSent,
  //     );
  //   } catch (e) {
  //     showErrorToast(e.toString());
  //   }
  // }
}
