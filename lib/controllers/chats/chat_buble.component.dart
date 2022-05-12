import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:somdaka_client/helpers/date.helpers.dart';
import 'package:somdaka_client/models/chats/newModels/message.model.dart';

import '../auth.controller.dart';

class ChatBubbleComponent extends StatelessWidget {
  final bool isGroup;
  final IMessage message;

  ChatBubbleComponent({Key? key, required this.isGroup, required this.message}) : super(key: key);

  final AuthController _authController = Get.find<AuthController>();

  Widget _chatBubble(BuildContext context ,IMessage message){

    List<Widget> children = [
      BubbleSpecialOne(
        text: message.message,
        isSender: message.from.id == _authController.currentUser.value.id,
        color: Theme.of(context).primaryColor,
        textStyle: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      Align(
        alignment: (message.from.id == _authController.currentUser.value.id
            ? Alignment.topRight: Alignment.topLeft),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            // DateFormat.Hm().format(message.createdAt),
            DateFormatHelpers().formatChatDate(message.createdAt),
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      )
    ];

    if(isGroup && message.from.id != _authController.currentUser.value.id){
      children.insert(0,
          Align(
            alignment: (message.from.id == _authController.currentUser.value.id
                ? Alignment.topRight: Alignment.topLeft),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                message.from.userName,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          )
      );
    }

    return Column(
      children: children,
    );


  }

  @override
  Widget build(BuildContext context) {
    return _chatBubble(context,message);
  }
}
