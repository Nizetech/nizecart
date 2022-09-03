import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../Auth/controller/auth_controller.dart';
import '../Widget/component.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  static var box = Hive.box('name');
  String name = box.get('displayName');

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
              future: Future.wait([
                ref.read(authtControllerProvider).getUserDetails(),
              ]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  Map data = snapshot.data;
                  print(data[0]['photoUrl']);
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
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: data['photoUrl'],
                                height: 40,
                                width: 40,
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
          child: SingleChildScrollView(
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
              RecieverMsg(
                  text:
                      "Shaun! How are you? I've been praying for you and your family today.",
                  time: '10:58 PM'),
              SizedBox(height: 13),
              SenderMsg(
                text:
                    "Hey Philip! We got a new placement  and its going great. How are you?",
                time: '11:06 AM',
              ),
              SizedBox(height: 13),
              RecieverMsg(
                  text:
                      "That’s awesome! I’ll let the team know to be ready for support requests. Can’t wait to see how God uses you in their story.",
                  time: '11:18 PM'),
              SizedBox(height: 13),
              SenderMsg(
                text: "Me too!",
                time: '11:20 AM',
              ),
              SizedBox(height: 13),
              photo(),
              SizedBox(height: 13),
              RecieverMsg(
                  text:
                      "That’s awesome! I’ll let the team know to be ready for support requests. Can’t wait to see how God uses you in their story.",
                  time: '11:18 PM'),
              SizedBox(height: 13),
              SenderMsg(
                text: "Me too!",
                time: '11:20 AM',
              ),
              SizedBox(height: 13),
              RecieverMsg(
                  text: "Charity is assigning you support!", time: '12:09 PM'),
            ],
          )),
        ),
        bottomNavigationBar: Container(
          height: 54,
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color(0xffF5F5F5),
          ),
          child: TextField(
            decoration: InputDecoration(
              fillColor: Color(0xffF5F5F5),
              hintText: 'Type a Message',
              suffixIcon: Icon(
                Iconsax.camera,
                color: secColor,
              ),
              hintStyle: TextStyle(
                color: Color(0xffb7b7b7),
                fontSize: 15,
                fontWeight: FontWeight.w500,
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
    );
  }
}
