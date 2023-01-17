import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nizecart/Models/chat_model.dart';
import 'package:nizecart/Models/enums.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/chat/controller/controller.dart';
import 'package:nizecart/keys/keys.dart';
import 'package:timeago/timeago.dart';

import '../Models/messages.dart';

class ChatList extends ConsumerStatefulWidget {
  final Map messageData;
  final MessageType messageType;
  final File imageFile;

  ChatList({
    Key key,
    this.messageData,
    this.messageType,
    this.imageFile,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  @override
  Widget build(BuildContext context) {
    bool isMe =
        widget.messageData['sender'] == FirebaseAuth.instance.currentUser.uid;
    bool isImage = widget.messageType == MessageType.image;
    print('my data ===${widget.messageData}');
    print('my data ===${widget.messageData['text']}');

    return isMe
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: Container(
              //     padding: EdgeInsets.symmetric(vertical: 7, horizontal: 8),
              //     constraints: BoxConstraints(
              //         maxWidth: MediaQuery.of(context).size.width * .7),
              //     decoration: BoxDecoration(
              //       borderRadius: const BorderRadius.only(
              //         topLeft: Radius.circular(5),
              //         topRight: Radius.circular(5),
              //         bottomLeft: Radius.circular(5),
              //         bottomRight: Radius.circular(1),
              //       ),
              //       color: secColor.withOpacity(.3),
              //     ),
              //     child: Column(
              //       children: [
              //         Text(
              //           widget.messageData['text'],
              //           style: const TextStyle(
              //             color: Colors.black,
              //             fontSize: 15,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              widget.messageData['image'] != null
                  ? Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .7,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(1),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        border: Border.all(
                          color: secColor.withOpacity(.3),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(1),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.messageData['image'],
                          // height: 300,
                          // width: 50,
                          fit: BoxFit.cover,
                        ),
                      ))
                  : SizedBox(),

              SizedBox(height: 5),
              widget.messageData['text'] == null
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () async {
                        print('copy');
                        await Clipboard.setData(
                                ClipboardData(text: widget.messageData['text']))
                            .then((value) => showToast('Copied to clipboard'));
                      },
                      child: BubbleSpecialOne(
                        text: widget.messageData['text'],
                        isSender: true,
                        // delivered: true,
                        color: secColor.withOpacity(.3),
                        textStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
              SizedBox(height: 5),
              Text(
                widget.messageData['date'] == null
                    ? ''
                    : time(widget.messageData['date']),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // GestureDetector(
              //   onTap: () async {
              //     await Clipboard.setData(
              //         ClipboardData(text: widget.messageData['text']));
              //   },
              //   child: BubbleSpecialOne(
              //     text: widget.messageData['text'],
              //     isSender: false,
              //     // sent: true,
              //     // delivered: true,
              //     color: Colors.purple.shade100,
              //     textStyle: TextStyle(
              //       fontSize: 15,
              //       color: Colors.purple,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              widget.messageData['image'] != null
                  ? Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .7,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(1),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        border: Border.all(
                          color: secColor.withOpacity(.3),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(1),
                          bottomRight: Radius.circular(10),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.messageData['image'],
                          // height: 300,
                          // width: 50,
                          fit: BoxFit.cover,
                        ),
                      ))
                  : SizedBox(),

              SizedBox(height: 5),
              widget.messageData['text'] == null
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () async {
                        print('copy');
                        await Clipboard.setData(
                                ClipboardData(text: widget.messageData['text']))
                            .then((value) => showToast('Copied to clipboard'));
                      },
                      child: BubbleSpecialOne(
                        text: widget.messageData['text'],
                        isSender: false,
                        // sent: true,
                        // delivered: true,
                        color: secColor.withOpacity(.3),
                        textStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
              SizedBox(height: 5),
              Text(
                // widget.messageData == null ||
                widget.messageData['date'] == null
                    ? ''
                    : time(widget.messageData['date']),
                style: const TextStyle(
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
