import 'package:get/get.dart';
import 'package:somdaka_client/controllers/chats/chat.constants.dart';
import 'package:somdaka_client/models/auth/user.model.dart';
import 'package:somdaka_client/models/chats/newModels/chat.dart';
import 'package:somdaka_client/models/chats/newModels/message.model.dart';
import 'package:somdaka_client/models/chats/newModels/message_indicator.model.dart';
import 'package:somdaka_client/services/chat.service.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../auth.controller.dart';

class ChatController extends GetxController{

  final String _socketUrl = ChatConstants.CHAT_SERVICE_URL;
  late IUser _currentUser;
  late IO.Socket socket;
  final AuthController _authController = Get.find<AuthController>();

  final _originalUserChatList = List<IChat>.empty().obs;

  var userChatList = List<IChat>.empty().obs;
  var chatMessageCounts = List<MessageIndicatorModel>.empty().obs;

  var existingUserIds = List<String>.empty().obs;

  var currentUserRemovedFromChat = false.obs;
  var chatUserRemovedFrom = "".obs;

  var chatDeleted = "".obs;

  @override
  void onInit(){
    super.onInit();

    print(Get.isRegistered<AuthController>());

    socket = IO.io(_socketUrl, IO.OptionBuilder()
        .setTransports(['websocket'])
        .build());

    _currentUser = _authController.currentUser.value;
    existingUserIds.add(_currentUser.id);
    _getChats(_currentUser.id);
    _initSocket(_currentUser.id);

  }

  void _initSocket(String id){


    socket.onConnect((_){
      socket.emit("start_session", {id});
    });
    socket.on("chat_has_new_message", (data) => _handleNewMessage(data));

    socket.on("new_chat_created", (data) => _newChatCreatedHandler(data));

    socket.on("chat_details_updated", (data) => _handleChatDetailsUpdatedEvent(data));

    socket.on("participant_removed", (data) => _handleParticipantRemovedEvent(data));

    socket.on("participant_added", (data) => _handleParticipantAddedEvent(data));

    socket.on("chat_deleted", (data) => _handleDeleteChatEvent(data));

    socket.onDisconnect((_) => print('disconnect'));
  }

  void _handleDeleteChatEvent(data){
    String chatID = data;

    chatDeleted.value = chatID;

    int chatIndex = userChatList.indexWhere((element) => element.id == chatID);
    List<String> idsToRemove = [];

    if(chatIndex != -1){
      for (var element in userChatList[chatIndex].members) {
        if(element.id != _currentUser.id){
          idsToRemove.add(element.id);
        }
      }
    }

    for(var element in idsToRemove){
      existingUserIds.removeWhere((e) => e == element);
    }

    userChatList.removeWhere((element) => element.id == chatID);
    userChatList.refresh();

    chatMessageCounts.removeWhere((element) => element.chatID == chatID);
    chatMessageCounts.refresh();

    _updateUserChatList();
  }

  void _handleParticipantAddedEvent(data){
    IChat chat = IChat.fromJson(data["chat"]);
    String userID = data["user_id"];

    //Check if the participant added is the current user
    if(_currentUser.id == userID){
      userChatList.add(chat);
      userChatList.refresh();

      chatMessageCounts.add(MessageIndicatorModel(count: 0, chatID: chat.id));
      chatMessageCounts.refresh();
    }else{
      int chatIndex = userChatList.indexWhere((element) => element.id == chat.id);
      userChatList[chatIndex] = chat;
      userChatList.refresh();
    }

    _updateUserChatList();
  }

  void _handleParticipantRemovedEvent(data){

    IChat chat = IChat.fromJson(data["chat"]);
    String userID = data["user_id"];
    int chatIndex = userChatList.indexWhere((element) => element.id == chat.id);
    if(chatIndex != -1){

      //If the current user is the removed participant
      if(userID == _currentUser.id){
        currentUserRemovedFromChat.value = true;
        chatUserRemovedFrom.value = chat.id;

        currentUserRemovedFromChat.refresh();
        chatUserRemovedFrom.refresh();

        chatMessageCounts.removeWhere((element) => element.chatID == chat.id);
        chatMessageCounts.refresh();

        userChatList.removeWhere((element) => element.id == chat.id);
        userChatList.refresh();
      }else{
        userChatList[chatIndex] = chat;
        userChatList.refresh();
      }

      _updateUserChatList();

    }
  }

  void _handleNewMessage(data){

    int index = chatMessageCounts
        .indexWhere((element) => element.chatID == IMessage.fromJson(data).chatId);

    if(index != -1){
      chatMessageCounts[index].count = chatMessageCounts[index].count + 1;
    }

    chatMessageCounts.refresh();
  }

  void resetMessageCounts(int index){
    chatMessageCounts[index].count = 0;
    chatMessageCounts.refresh();
  }

  void _handleChatDetailsUpdatedEvent(data){
    IChat chat = IChat.fromJson(data);
    int chatIndex = userChatList.indexWhere((element) => element.id == chat.id);
    if(chatIndex != -1){
      userChatList[chatIndex] = chat;
      userChatList.refresh();
      _updateUserChatList();
    }
  }

  void _newChatCreatedHandler(data){
    IChat chat = IChat.fromJson(data);
    if(chat.type != "group"){
      chat.name = chat.members.firstWhere((e) => e.id != _currentUser.id).userName;
      existingUserIds.add(chat.members.firstWhere((e) => e.id != _currentUser.id).id);
    }

    chatMessageCounts.add(MessageIndicatorModel(chatID: chat.id, count: 0));

    userChatList.add(chat);
    userChatList.refresh();
    _updateUserChatList();
  }

  void _updateUserChatList(){
    _originalUserChatList.value = [...userChatList];
    _originalUserChatList.refresh();
  }

  void _getChats(String id) async{
    // userChatList.value = await ChatService().getUserChats(_currentUser.id);
    userChatList.value = await ChatService().getUserChats(id);


    _originalUserChatList.value = [...userChatList];

    for (var element in userChatList) {

      //init chat message counts
      chatMessageCounts.add(MessageIndicatorModel(chatID: element.id, count: 0));


      if(element.type != "group"){
        //Change the name for personal chats
        // String name = element.members.firstWhere((e) => e.id != _currentUser.id).userName;
        String name = element.members.firstWhere((e) => e.id != id).userName;
        element.name = name;

        //Populate existing user Ids
        // existingUserIds.add(element.members.firstWhere((e) => e.id != _currentUser.id).id);
        existingUserIds.add(element.members.firstWhere((e) => e.id != id).id);
      }
    }

    userChatList.refresh();
    _originalUserChatList.refresh();

    print("USER CHAT COUNT" + userChatList.length.toString());
  }


  void leaveChat(String chatID){
    socket.emit("leave_chat", {chatID});
  }

  void filterList(String value){

    List<IChat> chatsCopy = [..._originalUserChatList];

    userChatList.value = chatsCopy
        .where((item) => item.name.toLowerCase().contains(value.toLowerCase()))
        .toList();

    userChatList.refresh();

  }

  void clearListFilter(){
    userChatList.value = _originalUserChatList;
    userChatList.refresh();
  }

}