import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:somdaka_client/widgets/notification/notification_snackbars.component.dart';
import 'package:somdaka_client/widgets/users/user_list.component.dart';
import 'package:somdaka_client/controllers/auth.controller.dart';
import 'package:somdaka_client/controllers/chats/chat.controller.dart';
import 'package:somdaka_client/controllers/chats/messages.controller.dart';
import 'package:somdaka_client/layouts/bottom_sheet_modal.component.dart';
import 'package:somdaka_client/models/auth/user.model.dart';
import 'package:somdaka_client/models/chats/newModels/chat.dart';
import 'package:somdaka_client/services/chat.service.dart';

class ChatDetailsPage extends StatefulWidget {
  final IChat chatDetails;
  const ChatDetailsPage({Key? key, required this.chatDetails}) : super(key: key);

  @override
  _ChatDetailsPageState createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _textController = TextEditingController();
  late IChat _chatDetails;

  final ChatController _chatController = Get.find<ChatController>();
  final MessagesController _messagesController = Get.find<MessagesController>();

  @override
  void initState(){
    super.initState();
    _chatDetails = widget.chatDetails;

    _chatController.currentUserRemovedFromChat.listen((data) => _gracefullyLeaveChat());
    _chatController.chatDeleted.listen((data) => _gracefullyHandleChatDeletion(data));
  }

  void _gracefullyHandleChatDeletion(data){
    if(data == widget.chatDetails.id){
      Get.snackbar(
        "Chat Deleted",
        "This chat has been deleted by the owner",
        snackPosition: SnackPosition.BOTTOM,
      );

      _messagesController.destroyChat();
    }
  }

  void _gracefullyLeaveChat(){
    if(_chatController.chatUserRemovedFrom.value == widget.chatDetails.id){
      //Prompt the user that they have been removed
      Get.snackbar(
        "Removed from chat",
        "You have been removed as a participant from this chat",
        snackPosition: SnackPosition.BOTTOM,
      );

      //Disconnect from socket
      _messagesController.destroyChat();
    }
  }

  void _handleDeleteChat() async{
    if(await ChatService().deleteChat(_chatDetails.id)){
      NotificationSnackBarsComponent().showSuccess("");
    }
    else{
      NotificationSnackBarsComponent().showError("Failed to delete Chat");
    }
  }

  void _userSelectionModal(BuildContext context){

    List<String> existingUserIDS = _chatDetails.members.map((e) => e.id).toList();

    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheetModalComponent(
              title: "New Chat",
              subtitle: "Select Person",
              modalData: UserListComponent(
                clientId: _authController.clientDetails.value.id,
                existingUserIds: existingUserIDS,
                selectionCallback: (IUser selectedUser){

                  _addParticipant(context, IChatUser(
                      id: selectedUser.id,
                      userName: selectedUser.name + " " + selectedUser.surname,
                      emailAddress: selectedUser.emailAddress
                  ));

                },
              ),
              modalHeight: 500
          );
        });
  }

  void _handleRemoveParticipant(String participantID) async{

    if(await ChatService().removeParticipant(_chatDetails.id, participantID)){
      NotificationSnackBarsComponent().showSuccess("Participant removed successfully");
      setState(() {
        _chatDetails.members.removeWhere((element) => element.id == participantID);
      });
    }
    else{
      NotificationSnackBarsComponent().showError("Failed to remove Participant");
    }
  }

  void _addParticipant(BuildContext context, IChatUser participant) async{
    if(await ChatService().addParticipant(participant, _chatDetails.id)){
      NotificationSnackBarsComponent().showSuccess("Participant added successfully");
      setState(() {
        _chatDetails.members.add(participant);
      });
    }
    else{
      NotificationSnackBarsComponent().showError("Failed to add Participant");
    }
  }

  Widget _groupParticipants(BuildContext context){

    return ListView.separated(
        itemBuilder: (BuildContext context, int i){
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                CupertinoIcons.person,
                color: Colors.white,
              ),
            ),
            title: Text(_chatDetails.members[i].userName),
            subtitle: Text(_chatDetails.members[i].emailAddress),
            trailing: (_chatDetails.creator.id != _chatDetails.members[i].id
                && _chatDetails.creator.id == _authController.currentUser.value.id)  ? IconButton(
              onPressed: () {
                _handleRemoveParticipant(_chatDetails.members[i].id);
              },
              icon: const Icon(
                CupertinoIcons.delete,
                size: 15,
              ),
            ) : Text(
                _chatDetails.creator.id == _chatDetails.members[i].id ? "Admin" : ""
            ),
          );
        },
        separatorBuilder: (BuildContext context, int i){
          return const Divider(height: 1,);
        },
        itemCount: _chatDetails.members.length
    );

  }

  Widget _personalChatParticipants(){

    return ListView.separated(
        itemBuilder: (BuildContext context, int i){
          return ListTile(
            dense: true,
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                CupertinoIcons.person_fill,
                color: Colors.white,
              ),
            ),
            title: Text(_chatDetails.members[i].userName),
            subtitle: Text(_chatDetails.members[i].emailAddress),
          );
        },
        separatorBuilder: (BuildContext context, int i){
          return const Divider(height: 1,);
        },
        itemCount: _chatDetails.members.length
    );

  }

  void _updateChatName(String name) async{

    IChat updatedChat = _chatDetails;
    updatedChat.name = name;
    if(await ChatService().updateChat(updatedChat)){
      NotificationSnackBarsComponent().showSuccess("Group name updated");
      setState(() {
        _chatDetails = updatedChat;
      });
    }else{
      NotificationSnackBarsComponent().showError("Failed to updated group name");
    }

  }

  Widget _chatDeletionWidget(){

    Widget response;

    if(_chatDetails.type == "group"){

      //User is the creator of this group
      if(_chatDetails.creator.id == _authController.currentUser.value.id){

        response = ListTile(
          contentPadding: const EdgeInsets.all(20),
          title:Text(
            "Delete Group",
            style: TextStyle(
                color: Colors.red.shade400
            ),
          ),

          onTap: (){

            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Delete Group?'),
                content: const Text('You cannot undo this action and all chat data will be lost'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context, 'Yes');
                      _handleDeleteChat();
                    },
                    child: Text('Yes Delete', style: TextStyle(color: Colors.red.shade400)),
                  ),
                ],
              ),
            );


          },
        );
      }
      else{

        response = ListTile(
          contentPadding: const EdgeInsets.all(20),
          title:Text(
            "Exit Group",
            style: TextStyle(
                color: Colors.red.shade400
            ),
          ),
          onTap: (){
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Exit Group?'),
                content: const Text('You cannot undo this action and all chat data will be lost'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context, 'Yes');
                      _handleRemoveParticipant(_authController.currentUser.value.id);
                    },
                    child: Text('Yes Exit', style: TextStyle(color: Colors.red.shade400),),
                  ),
                ],
              ),
            );

          },
        );
      }

    }
    else{

      // Owner of Personal Chat
      if(_chatDetails.creator.id == _authController.currentUser.value.id){
        response =  ListTile(
          tileColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
          title:Text(
            "Delete Chat",
            style: TextStyle(
                color: Colors.red.shade400,
              fontSize: 12
            ),
          ),

          onTap: (){
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Delete Chat?'),
                content: const Text('This chat will be deleted for both participants. You cannot undo this action and all chat data will be lost'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context, 'Yes');
                      _handleDeleteChat();
                    },
                    child: Text('Yes Delete', style: TextStyle(color: Colors.red.shade400)),
                  ),
                ],
              ),
            );
          },
        );
      }else{
        response = ListTile(
          contentPadding: const EdgeInsets.all(20),
          title:Text(
            "Leave Chat",
            style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 12
            ),
          ),
          onTap: (){
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Leave Chat?'),
                content: const Text('This chat will be deleted for both participants. You cannot undo this action and all chat data will be lost'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context, 'Yes');
                      _handleDeleteChat();
                      // _handleRemoveParticipant(_authController.currentUser.value.id);
                    },
                    child: Text('Yes Exit', style: TextStyle(color: Colors.red.shade400),),
                  ),
                ],
              ),
            );

          },
        );
      }


    }

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
            _chatDetails.type == "group" ? "Group Info" : "Contact Info"
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              radius: 22,
              child: Image.asset("assets/icons/help_desk_icon.png"),
            ),
            title: Text(
                _chatDetails.name
            ),
            trailing: (_chatDetails.creator.id == _authController.currentUser.value.id
                && _chatDetails.type == "group") ? TextButton(
              onPressed: (){
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Edit Group Name'),
                    content: TextField(
                      textAlign: TextAlign.center,
                      controller: _textController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        contentPadding: const EdgeInsets.all(8.0),
                        hintText: "Enter a new name...",

                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: (){
                          if(_textController.text.isNotEmpty){
                            _updateChatName(_textController.text);
                            Navigator.pop(context, 'Save');
                          }else{
                            Get.snackbar("Error", "Invalid name provided");
                          }

                         },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                );

              },
              child: const Text(
                "Edit"
              ),
            ) : const Text(""),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 8, bottom: 8, right: 12, left: 12),
            child: Text(
              "${_chatDetails.members.length} Participants",
              style: const TextStyle(
                color: Colors.white
              ),
            ),
          ),
          const Divider(height: 1,),
          _chatDetails.type == "group" ? ListTile(
            // tileColor: Colors.white,
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                CupertinoIcons.add,
                color: Colors.white,
              ),
            ),
            title: const Text(
                "Add Participants"
            ),
            onTap: (){
              _userSelectionModal(context);
            },
          ) : const SizedBox(height: 0,),
          Expanded(
            child: _chatDetails.type == "group" ? _groupParticipants(context) : _personalChatParticipants(),
          ),
          SizedBox(
            height: 80,
            child: _chatDeletionWidget(),
          ),
        ],
      ),
    );
  }
}

