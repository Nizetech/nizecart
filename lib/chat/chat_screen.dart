import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
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
  final ScrollController messageController = ScrollController();

  static var box = Hive.box('name');
  String name = box.get('displayName');
  User users;
  @override
  void initState() {
    users = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  // @override
  // void dispose() {
  //   messageController.dispose();
  //   super.dispose();
  // }

  // String get uid => null;
  void sendTextMessage() {
    if (message.text != '') {
      ref.read(chatControllerProvider).sendMessage(
            text: message.text.trim(),
            username: name,
            photoUrl: widget.user['photoUrl'],
          );
      message.clear();
    } else {
      return;
    }
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
                const Text(
                  "Online",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
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
              stream: ref.read(chatControllerProvider).getChats(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: loader());
                } else {
                  List<dynamic> messages = snapshot.data.docs.map((doc) {
                    return doc.data() as Map;
                  }).toList();
                  // List messages = snapshot.data;
                  // print('messages: $messages');
                  // SchedulerBinding.instance.addPersistentFrameCallback((_) {
                  //   messageController.jumpTo(
                  //     messageController.position.maxScrollExtent,
                  //   );
                  // });
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
                          // separatorBuilder: (ctx, i) => SizedBox(height: 10),
                          shrinkWrap: true,
                          // scrollDirection: Axis.vertical,
                          itemCount: messages.length,
                          itemBuilder: (ctx, i) {
                            Map data = messages[i];
                            return ChatList(messageData: data);
                          },
                        );
                }
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
                  controller: message,
                  decoration: InputDecoration(
                    fillColor: Color(0xffF5F5F5),
                    hintText: 'Type a Message',
                    suffixIcon: const Icon(
                      Iconsax.camera,
                      color: secColor,
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
                onTap: sendTextMessage,
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
