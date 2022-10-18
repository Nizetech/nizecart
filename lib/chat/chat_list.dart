import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/chat/controller/controller.dart';
import 'package:nizecart/keys/keys.dart';
import 'package:timeago/timeago.dart';

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
  @override
  Widget build(BuildContext context) {
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
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(1),
                    ),
                    color: secColor.withOpacity(.3),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.messageData['text'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.messageData != null
                    ? time(widget.messageData['date'])
                    : '',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
            ],
          )
          ///
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.all(15),
                  
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .7),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    color: mainColor.withOpacity(.3),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.messageData != null
                            ? time(widget.messageData['date'])
                            : '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // DateFormat()
              //                 .add_H()
              //                 .format(messageData.timeSent);
              Text(
                widget.messageData != null
                    ? format(widget.messageData['date'])
                    : SizedBox(),
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
            ],
          );
  }
}
