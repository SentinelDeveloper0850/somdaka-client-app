import 'package:flutter/material.dart';

class NoChatsAvailableComponent extends StatelessWidget {

  final selectionCallback;
  const NoChatsAvailableComponent({Key? key, this.selectionCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset("assets/icons/chat-bubble.png"),
          ),
          Text(
            "Start a new Chat or Group",
            style: TextStyle(
                fontSize: 14
            ),
          ),
          TextButton(
              onPressed: (){
                this.selectionCallback("P2P");
              },
              child: Text(
                "New Chat"
              )
          ),
          Text(
            "or",
            style: TextStyle(
                fontSize: 14
            )
          ),
          TextButton(
              onPressed: (){
                this.selectionCallback("Group");
              },
              child: Text(
                  "New Group Chat"
              )
          ),

        ],
      ),
    );;
  }
}
