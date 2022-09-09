import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/chat/controller/controller.dart';

import '../Models/messages.dart';

class ChatList extends ConsumerStatefulWidget {
  String receiverUserId;
  ChatList({Key key, this.receiverUserId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Messages>>(
      stream:
          ref.read(chatControllerProvider).getChatStream(widget.receiverUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          Center(child: CircularProgressIndicator());
        }
        print(snapshot.data);
        // SchedulerBinding.instance.addPersistentFrameCallback((_) {
        //   messageController.jumpTo(
        //     messageController.position.maxScrollExtent,
        //   );
        // });
        return ListView.builder(
            // controller: messageController,
            itemCount: snapshot.data.length,
            itemBuilder: (ctx, i) {
              final messageData = snapshot.data[i];
              var timeSent = DateFormat().add_H().format(messageData.timeSent);
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser.uid) {
                return SenderMsg(
                  message: messageData.text,
                  date: timeSent,
                  userName: messageData.repliedTo,
                );
              }
              return RecieverMsg(
                message: messageData.text,
                date: timeSent,
                userName: messageData.repliedTo,
              );
            });
      },
    );
  }
}
