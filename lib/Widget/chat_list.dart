import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/chat/controller/controller.dart';

import '../Models/messages.dart';

class ChatList extends ConsumerStatefulWidget {
  final Map messageData;
  ChatList({
    Key key,
    this.messageData,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // SchedulerBinding.instance.addPersistentFrameCallback((_) {
    //   messageController.jumpTo(
    //     messageController.position.maxScrollExtent,
    //   );
    // });
    bool isMe =
        widget.messageData['sender'] == FirebaseAuth.instance.currentUser.uid;
    return isMe
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.all(15),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .7),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(27),
                      topRight: Radius.circular(27),
                      bottomLeft: Radius.circular(27),
                      bottomRight: Radius.circular(2),
                    ),
                    color: Color(0xff4b4b4b),
                  ),
                  child: Column(
                    children: [
                      // Text(
                      //   userName,
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold, color: Colors.white),
                      // ),
                      Text(
                        widget.messageData['text'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 13),
                // DateFormat()
                //                 .add_H()
                //                 .format(messageData.timeSent);
              Text(
                widget.messageData['date'],
                style: TextStyle(
                  color: Color(0xff3a3a41),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.all(15),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .7),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(27),
                      bottomLeft: Radius.circular(27),
                      bottomRight: Radius.circular(27),
                    ),
                    color: Color(0xff4b4b4b),
                  ),
                  child: Column(
                    children: [
                       Text(
                        widget.messageData['text'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 13),
              // DateFormat()
              //                 .add_H()
              //                 .format(messageData.timeSent);
              Text(
                widget.messageData['date'],
                style: TextStyle(
                  color: Color(0xff3a3a41),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          );
  }
}
