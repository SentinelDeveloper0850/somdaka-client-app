import 'dart:async';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:somdaka_client/controllers/auth.controller.dart';
import 'package:somdaka_client/controllers/chats/chat.controller.dart';
import 'package:somdaka_client/controllers/chats/messages.controller.dart';
import 'package:somdaka_client/helpers/date.helpers.dart';
import 'package:somdaka_client/layouts/chat_screen_app_bar.component.dart';
import 'package:somdaka_client/models/auth/user.model.dart';
import 'package:somdaka_client/models/chats/newModels/chat.dart';
import 'package:somdaka_client/models/chats/newModels/message.model.dart';
import 'package:somdaka_client/services/chat.service.dart';

class ChatPage extends StatefulWidget {

  final IChat chatDetails;

  const ChatPage({Key? key, required this.chatDetails}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final MessagesController _messagesController = Get.find<MessagesController>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final ChatController _chatController = Get.find<ChatController>();
  final AuthController _authController = Get.find<AuthController>();
  late IUser _currentUser;

  bool _chatEnabled = true;


  @override
  void initState(){
    _messagesController.initChat(widget.chatDetails.id);
    _currentUser = _authController.currentUser.value;

    _chatController.currentUserRemovedFromChat.listen((data) => _gracefullyLeaveChat());

    //Honestly, this is a very hacky way of scrolling to the bottom on load
    Timer(
        const Duration(milliseconds: 500),
            () {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent + 100,
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
        );
     });

    _messagesController.messages.listen((messages) => _newMessageListener(messages));
    super.initState();


  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  void _newMessageListener(List<IMessage> messages){
    if(messages.isNotEmpty && _scrollController.hasClients){
      _scrollDown();
    }
  }

  //The user has been removed from the chat
  void _gracefullyLeaveChat(){
    if(_chatController.chatUserRemovedFrom.value == widget.chatDetails.id){
      //Prompt the user that they have been removed
      Get.snackbar(
        "Removed from chat",
        "You have been removed as a participant from this chat",
        snackPosition: SnackPosition.BOTTOM,
      );

      _chatEnabled = false;
      //Disconnect from socket
      _messagesController.destroyChat();
    }
  }


  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<bool> _endChat() async{
    _messagesController.destroyChat();
    Navigator.pop(context, true);
    return true;
  }

  Widget _chatBubble(IMessage message){

    List<Widget> children = [
      BubbleSpecialOne(
        text: message.message,
        isSender: message.from.id == _currentUser.id,
        color: message.from.id == _currentUser.id ? Colors.grey.shade700 : Theme.of(context).colorScheme.onSecondary,
        textStyle: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      Align(
        alignment: (message.from.id == _currentUser.id
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

    if(widget.chatDetails.type == "group" && message.from.id != _currentUser.id){
      children.insert(0,
          Align(
            alignment: (message.from.id == _currentUser.id
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

  Future<bool> _sendMessage(String message) async{
    IUser user = _authController.currentUser.value;

    IMessage newMessage = IMessage(
        createdAt: DateTime.now(),
        id: "",
        from: IChatUser(
          id: user.id,
          userName: "${user.name} ${user.surname}",
          emailAddress: user.emailAddress
        ),
        chatId: widget.chatDetails.id,
        message: message
    );

    return await ChatService().sendMessage(newMessage);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _endChat,
      child: Scaffold(
        appBar: ChatScreenAppBar(title: widget.chatDetails.name, chatDetails: widget.chatDetails,),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              width: double.infinity,
              child: Text(
                (widget.chatDetails.members.length == 1 && widget.chatDetails.type == "personal")
                    ? "${ widget.chatDetails.name} has left the chat"
                    : "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red.shade400
                ),
              ),
            ),
            Expanded(
              child: GetX<MessagesController>(
                builder: (controller){

                  controller.loadedMessages.listen((loaded) {
                    if(loaded && controller.messages.isNotEmpty){
                      if(_scrollController.hasClients){
                        _scrollDown();
                      }
                    }

                  });

                  return controller.messages.isNotEmpty
                      ? ListView.separated(
                    controller: _scrollController,
                    reverse: false,
                    shrinkWrap: true,
                    itemBuilder: (context, int index){
                      return _chatBubble(controller.messages[index]) ;
                    },
                    separatorBuilder: (context, int index){
                      return const SizedBox(height: 1,);
                    },
                    itemCount: controller.messages.length,

                  )
                      : Center(
                    child: Text("Send a message to start a chat", style: TextStyle(color: Theme.of(context).primaryColor),),
                  ) ;
                },
              ),
            ),
            Container(
              height: 60,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(43, 151, 147, 0.1),
                  border: Border(
                      top: BorderSide(width: 1, color: Colors.grey.shade300),
                  )
              ),
              padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
              child: GetX<MessagesController>(
                builder: (controller){
                  return !controller.chatDisabled.value ? TextField(
                    enabled: _chatEnabled,
                    textInputAction: TextInputAction.done,
                    controller: _messageController,
                    autocorrect: true,
                    minLines: null,
                    maxLines: null,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14
                    ),
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: "Write message...",
                        hintStyle: const TextStyle(color: Colors.black),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0),

                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0
                          ),
                        ),
                        suffixIcon:  Container(
                            height: 25,
                            width: 25,
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),

                            child: Center(
                              child: TextButton(
                                onPressed: () async{
                                  if(_messageController.text.isNotEmpty){
                                    await _sendMessage(_messageController.text);
                                    _messageController.clear();
                                  }else{
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                        const SnackBar(content: Text("Message cannot be blank"))
                                    );
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  child: const Icon(
                                    Icons.send,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                        )
                    ),
                  ) : const Text("Chat is unavailable");
                },
              )
            ),
          ] ,
        ),
      ),
    );
  }
}
