import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Widget/chat_list.dart';
import 'package:nizecart/chat/controller/controller.dart';

import '../Auth/controller/auth_controller.dart';
import '../Models/user_model.dart';
import '../Widget/component.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String receiverUserId;
  ChatScreen({Key key, this.receiverUserId}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  TextEditingController message = TextEditingController();
  static var box = Hive.box('name');
  String name = box.get('displayName');

  // String get uid => null;
  void sendTextMessage() {
    ref.read(chatControllerProvider).sendTextMessages(
          message.text.trim(),
          widget.receiverUserId,
        );
    // print(_messageController.text.trim());
    setState(() {
      message.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
          title: FutureBuilder(
              future: ref.read(authtControllerProvider).getUserDetails(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  Map data = snapshot.data;
                  print(data['photoUrl']);
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      data['photoUrl'] == null
                          ? const Icon(
                              Iconsax.user,
                              size: 30,
                              color: secColor,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: CachedNetworkImage(
                                imageUrl: data['photoUrl'],
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
                            '$name',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 2),
                          Text("Online",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                              ))
                        ],
                      )
                    ],
                  );
                }
              }),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
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
              Expanded(
                  child: ChatList(
                receiverUserId: widget.receiverUserId,
              ))
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 54,
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color(0xffF5F5F5),
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
            ],
          ),
        ),
      ),
    );
  }
}
