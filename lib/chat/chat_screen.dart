import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:nizecart/chat/chat_list.dart';
import 'package:nizecart/chat/controller/controller.dart';

import '../Auth/controller/auth_controller.dart';
import '../Models/user_model.dart';
import '../Widget/component.dart';

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
  static var box = Hive.box('name');
  String name = box.get('displayName');
  User users;
  @override
  void initState() {
    users = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  // String get uid => null;
  void sendTextMessage() {
    ref.read(chatControllerProvider).sendMessage(
          text: message.text.trim(),
          //receiver: widget.user['uid'],
          // widget.receiverUserId,
        );
    // print(_messageController.text.trim());
    setState(() {
      message.text = '';
    });
  }

  // String userId = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    String image = widget.user['photoUrl'];
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
            title:
                // DocumentSnapshot data = snapshot.data;
                // print(data['photoUrl']);
                Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.user['photoUrl'] == null
                ? CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(
                      Iconsax.user,
                      size: 25,
                      color: Colors.black,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                const Text("Online",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ))
              ],
            )
          ],
        )
            // }

            ),
            backgroundColor:white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: StreamBuilder(
              stream: ref.read(chatControllerProvider).getChats(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  List<dynamic> messages = snapshot.data.docs.map((doc) {
                    return doc.data() as Map;
                  }).toList();
                  // List messages = snapshot.data;
                  print('messages: $messages');
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Today",
                          style: TextStyle(
                            color: Color(0xffb3b3bb),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      messages.isEmpty
                          ? const Center(
                              child: Text(
                                'No Messages Yet',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.separated(
                                // controller: messageController,
                                separatorBuilder: (ctx, i) =>
                                    SizedBox(height: 10),
                                shrinkWrap: true,
                                itemCount: messages.length,
                                itemBuilder: (ctx, i) {
                                  //  ChatList(messageData: messages[i]);
                                  return ChatList(messageData: messages[i]);
                                },
                              ),
                            ),
                    ],
                  );
                }
              }),
        ),
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: Container(
                height: 54,
                margin:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(blurRadius: 3, color: Colors.grey),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: message,
                        decoration: InputDecoration(
                          fillColor: Color(0xffF5F5F5),
                          hintText: 'Type a Message',
                          suffixIcon: Icon(
                            Iconsax.camera,
                            color: secColor,
                          ),
                          hintStyle: TextStyle(
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
                    SizedBox(width: 7),
                  ],
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Color(0xff128c7e),
              radius: 25,
              child: GestureDetector(
                onTap: sendTextMessage,
                child: Icon(
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
