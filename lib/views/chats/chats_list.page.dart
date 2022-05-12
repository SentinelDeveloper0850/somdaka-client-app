import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:somdaka_client/widgets/large_divider.component.dart';
import 'package:somdaka_client/widgets/notification/notification_snackbars.component.dart';
import 'package:somdaka_client/widgets/users/user_list.component.dart';
import 'package:somdaka_client/controllers/auth.controller.dart';
import 'package:somdaka_client/controllers/chats/chat.controller.dart';
import 'package:somdaka_client/layouts/bottom_sheet_modal.component.dart';
import 'package:somdaka_client/layouts/main.layout.dart';
import 'package:somdaka_client/models/auth/user.model.dart';
import 'package:somdaka_client/models/chats/newModels/chat.dart';
import 'package:somdaka_client/services/chat.service.dart';

import 'chat.page.dart';


class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

  late TextEditingController _textController;
  final AuthController _authController = Get.find<AuthController>();
  final ChatController _chatController = Get.find<ChatController>();
  late IChatUser _currentChatUser;

  @override
  void initState(){
    super.initState();
    _textController = TextEditingController();
    _currentChatUser = IChatUser(
        id: _authController.currentUser.value.id,
        userName: _authController.currentUser.value.name
            + " "
            + _authController.currentUser.value.surname,
        emailAddress: _authController.currentUser.value.emailAddress
    );

  }

  void _refreshChatList(){
    setState(() {

    });
  }

  void _createPersonalChat(IChat chat) async{

    if(await ChatService().createNewChat(chat)){
      NotificationSnackBarsComponent().showSuccess("Chat Created Successfully");
    }else{
      NotificationSnackBarsComponent().showError("Chat Creation failed");
    }
  }

  void _showUserSelectionModal(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheetModalComponent(
              title: "New Chat",
              subtitle: "Select Person",
              modalData: UserListComponent(
                clientId: _authController.clientDetails.value.id,
                existingUserIds: _chatController.existingUserIds,
                selectionCallback: (IUser selectedUser) async{

                  IChat chat = IChat(
                      members: [
                        _currentChatUser,
                        IChatUser(
                            id: selectedUser.id,
                            userName: selectedUser.name + " " + selectedUser.surname,
                            emailAddress: selectedUser.emailAddress
                        )
                      ],
                      createdAt: DateTime.now(),
                      id: "",
                      type: "personal",
                      name: "",
                      clientId: _authController.clientDetails.value.id,
                      creator: _currentChatUser,
                    attachedToTask: false
                  );

                  _createPersonalChat(chat);
                },
              ),
              modalHeight: 500
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Chats',
      hasDrawer: true,
      // actions: [
      //   IconButton(
      //     onPressed: () {
      //       _showUserSelectionModal();
      //     },
      //     iconSize: 18,
      //     icon: const Icon(Icons.person_add),
      //   ),
      // ],
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(top: 10, left: 12, right: 12),
            dense: true,
            title: const Text(
              "Talk to us",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "All messages between you as the parent and Smiley Kids Norkem Park staff can be found here.",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                const Text(
                    "Availability:"
                ),
                const SizedBox(height: 5,),
                Text(
                  "Mon to Friday from 6 AM till 6 PM",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor
                  ),
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
          const LargeDividerComponent(),
          Expanded(
            child: GetX<ChatController>(
              builder: (controller){

                // controller.chatMessageCounts.listen((data){
                //   setState(() {});
                // });

                _chatController.currentUserRemovedFromChat.listen((data) => _refreshChatList());

                return controller.userChatList.isNotEmpty
                    ? ListView.separated(
                    itemBuilder: (BuildContext context, int index){

                      return ListTile(
                        dense: true,
                        onTap: (){
                          controller.resetMessageCounts(index);

                          pushNewScreen(context, screen: ChatPage(chatDetails: controller.userChatList[index]));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(chatDetails: controller.userChatList[index])));
                        },
                        leading: controller.userChatList[index].type != "group" ? CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          radius: 22,
                          child: Image.asset("assets/icons/help_desk_icon.png"),
                        ) : CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.onSecondary,
                          child: const Icon(
                            Icons.group,
                            color: Colors.white,
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                  controller.userChatList[index].name
                              ),
                            ),
                          ],
                        ),
                        trailing: controller.chatMessageCounts[index].count > 0 ? Badge(
                          elevation: 0,
                          badgeColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.all(6),
                          badgeContent: Text(
                            controller.chatMessageCounts[index].count.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12
                            ),
                          ),
                        ) : CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            CupertinoIcons.chevron_right,
                            size: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index){
                      return const Divider();
                    },
                    itemCount: controller.userChatList.length)
                    : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.info,
                        color: Colors.blue.shade200,
                        size: 80,
                      ),
                      const Text(
                        "You do not have any conversations",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                );
              },
            ),
          )

        ],
      )
    );
  }
}
