import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nizecart/Models/chat_model.dart';
import 'package:nizecart/Models/enums.dart';
import 'package:nizecart/chat/chat_list.dart';
import 'package:nizecart/chat/controller/controller.dart';

import '../Auth/controller/auth_controller.dart';
import '../Models/user_model.dart';
import '../Widget/component.dart';
import '../services/service_controller.dart';

class ChatScreen extends ConsumerStatefulWidget {
  Map user;
  ChatScreen({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  TextEditingController message = TextEditingController();
  final ScrollController messageController = ScrollController();

  static var box = Hive.box('name');
  String name = box.get('displayName');
  User users;

  File storedImage;
  MessageType type;

  Stream<QuerySnapshot<Object>> admin;
  @override
  void initState() {
    users = FirebaseAuth.instance.currentUser;
    admin = ref.read(chatControllerProvider).adminDetails();
    print(users);
    super.initState();
  }

  // @override
  // void dispose() {
  //   messageController.dispose();
  //   super.dispose();
  // }

  void sendTextMessage(
    String token,
    String adminId,
  ) async {
    if (message.text != '') {
      try {
        type = MessageType.text;
        ref.read(chatControllerProvider).sendMessage(
              text: message.text.trim(),
              username: name,
              adminId: adminId,
            );

        ref.read(serviceControllerProvider).sendMessage(token: token, message: {
          'title': 'You have a new message from $name',
          'body': message.text.trim(),
          'type': 'chat',
        });
        print('my message is ${message.text}');
        // print('my message is ${photo}');
        message.clear();
      } catch (e) {
        print(e);
      }
    } else {
      return;
    }
  }

  String photoUrl;
  String adminId;

  // void chatImage(
  //     // ImageSource source,
  //     ) async {
  //   XFile pickedFile = await ImagePicker()
  //       .pickImage(source: ImageSource.gallery, imageQuality: 40);

  //   if (pickedFile != null) {
  //     type = MessageType.image;
  //     setState(() {
  //       storedImage = File(pickedFile.path);
  //     });

  //     photoUrl = await ref
  //         .read(chatControllerProvider)
  //         .uploadChatImage(File(pickedFile.path));

  //     ref.read(chatControllerProvider).sendImage(
  //           imageUrl: photoUrl,
  //           username: name,
  //           messageType: MessageType.image,
  //           chatImage: photoUrl,
  //           // messageType: type,
  //         );

  //     print('This is photo===== ${photoUrl}');
  //   } else {
  //     return null;
  //   }
  //   // }
  //   // setState(() {});
  //   // Get.back();
  //   // setState(() {});
  // }

  // String userId = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    String image = widget.user['photoUrl'];
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
            leadingWidth: 30,
            title:
                // DocumentSnapshot data = snapshot.data;
                // print(data['photoUrl']);
                Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // widget.user['photoUrl'] == null
                //     ?
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[200],
                  child: Image.asset(
                    'assets/user-png.png',
                    height: 45,
                    width: 45,
                  ),
                ),
                // : ClipRRect(
                //     borderRadius: BorderRadius.circular(25),
                //     child: CachedNetworkImage(
                //       imageUrl: image,
                //       height: 50,
                //       width: 50,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // widget.user['firstName'],
                      users.displayName,
                      // '',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 2),
                    const Text(
                      "Online",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
              ],
            )
            // }

            ),
        backgroundColor: white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: StreamBuilder(
              stream: ref.read(chatControllerProvider).adminDetails(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final admin = snapshot.data.docs.map((doc) {
                  return doc.data() as Map;
                }).toList();
                log('my admin is ====>>>${admin}');
                log('my adminId is ====>>>${admin[0]['uid']}');
                adminId = admin[0]['uid'];
                log('my user token is ====>>>${widget.user['token']}');

                return StreamBuilder(
                    stream: ref.read(chatControllerProvider).getChats(
                          admin[0]['uid'],
                        ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: loader());
                      } else {
                        // print('my message ${snapshot.data}');
                        List<dynamic> messages = snapshot.data.docs.map((doc) {
                          return doc.data() as Map;
                        }).toList();
                        print('==========>');
                        print('my message =====>${messages}');
                        print('==========>');
                        // List messages = snapshot.data;
                        // print('messages: $messages');

                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                        //   messageController.jumpTo(
                        //     messageController.position.maxScrollExtent,
                        //   );
                        // });
                        // messageController.animateTo(
                        //   messageController.position.maxScrollExtent,
                        //   duration: Duration(milliseconds: 100),
                        //   curve: Curves.easeOut,
                        // );
                        return messages.isEmpty || messages == null
                            ? const Center(
                                child: Text(
                                  'No Messages Yet',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                controller: messageController,
                                shrinkWrap: true,
                                itemCount: messages.length,
                                itemBuilder: (ctx, i) {
                                  Map<String, dynamic> data = messages[i];
                                  // data.addAll({
                                  //   // 'messageType': type,
                                  //   'image': photoUrl,
                                  // });
                                  // print('my photo is ${photoUrl}');
                                  print('my chart data is ${data}');
                                  return ChatList(
                                    messageData: data,
                                    messageType: type,
                                    imageFile: storedImage,
                                  );
                                },
                              );
                      }
                    });
              }),
        ),
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(blurRadius: 3, color: Colors.grey),
                  ],
                ),
                child: TextField(
                  textInputAction: TextInputAction.unspecified,
                  textCapitalization: TextCapitalization.sentences,
                  controller: message,
                  maxLines: null,
                  minLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    fillColor: Color(0xffF5F5F5),
                    hintText: 'Type a Message',
                    suffixIcon: IconButton(
                      onPressed: (() async {
                        XFile pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery, imageQuality: 40);
                        if (pickedFile != null) {
                          ref.read(chatControllerProvider).sendMessage(
                                image: pickedFile as File,
                              );
                          //
                        }
                      }),
                      icon: const Icon(
                        Iconsax.camera,
                        color: secColor,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      color: Color(0xffb7b7b7),
                      fontSize: 16,
                    ),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Color(0xff128c7e),
              radius: 25,
              child: GestureDetector(
                onTap: () {
                  print('my AdminID is====> $adminId');
                  sendTextMessage(
                    // admin[]['token'],
                    widget.user['token'],
                    adminId,
                  );
                },
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
