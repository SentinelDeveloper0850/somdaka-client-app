import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:somdaka_client/controllers/chats/messages.controller.dart';
import 'package:somdaka_client/models/chats/newModels/chat.dart';
import 'package:somdaka_client/views/chats/chat_details.page.dart';

class ChatScreenAppBar extends StatelessWidget  implements PreferredSize{

  final String title;
  final IChat chatDetails;
  const ChatScreenAppBar({Key? key,  required this.title, required this.chatDetails}) : super(key: key);

  Widget _subTitleText(){

    Widget data;

    if(chatDetails.type != "group"){
      data = GetX<MessagesController>(
        builder: (controller){
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                CupertinoIcons.circle_fill,
                color: controller
                    .participantOnline.value ? Colors.greenAccent.shade700
                    : Colors.red.shade900,
                size: 6,
              ),
              const SizedBox(width: 5),
              Text(
                controller.participantOnline.value ? "online" : "offline",
                style: const TextStyle(
                    fontSize: 12
                ),
              )
            ],
          );
        },
      ) ;
    }else{
      data = Text(
        "${chatDetails.members.length} Participants",
        style: const TextStyle(
            fontSize: 12
        ),
      );
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: Theme.of(context).primaryColor,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 16
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          _subTitleText()
        ],
      ),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatDetailsPage(chatDetails: chatDetails,)
                )
            );
          },
          child: const Icon(
            CupertinoIcons.info,
            size: 20,
            color: Colors.white,
          ),
        ),

      ],
    );
  }


  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}
