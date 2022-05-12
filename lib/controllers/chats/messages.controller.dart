import 'package:get/get.dart';

import 'package:somdaka_client/models/auth/user.model.dart';
import 'package:somdaka_client/models/chats/newModels/message.model.dart';
import 'package:somdaka_client/services/chat.service.dart';

import '../auth.controller.dart';
import 'chat.controller.dart';

class MessagesController extends GetxController{

  final ChatController _chatController = Get.find<ChatController>();

  var chatID = "".obs;
  var messages = List<IMessage>.empty().obs;
  var chatDisabled = false.obs;
  var loadedMessages = false.obs;

  // P2P chat participant has connected and is online
  var participantOnline = false.obs;

  final AuthController _authController = Get.find<AuthController>();
  late IUser _currentUser;

  @override
  void onInit(){
    super.onInit();
    _currentUser = _authController.currentUser.value;
    _chatController.socket.on("new_chat_message", (data) => _handleNewMessage(data));

    _chatController.chatDeleted.listen((data){
      if(data == chatID.value){
        Get.snackbar(
          "Chat Deleted",
          "This chat has been deleted by the owner",
          snackPosition: SnackPosition.BOTTOM,
        );

        chatDisabled.value = true;
        destroyChat();

      }
    });

    _chatController.socket.on("user_joined_chat", (data) => handleUserJoinedChat(data));

    _chatController.socket.on("user_disconnected_from_chat", (data) => handleUserDisconnectFromChat(data));
  }

  void handleUserJoinedChat(data){
    if(data.toString() != _currentUser.id && participantOnline.value != true){
      _chatController.socket.emit("confirm_online_status", {chatID.value, _currentUser.id} );
      participantOnline.value = true;
    }
    update();
  }

  void handleUserDisconnectFromChat(data){
    participantOnline.value = data != _currentUser.id ? false : true;

    update();
  }


  void _handleNewMessage(data){
    messages.add(IMessage.fromJson(data));
    messages.refresh();
  }

  void initChat(String id){
    chatID.value = id;
    _chatController.socket.emit("join_chat", {id, _currentUser.id});
    _getChatMessages();
    chatDisabled.value = false;
  }

  void _getChatMessages() async{
    messages.value = await ChatService().getChatMessages(chatID.value);
    loadedMessages.value = true;
  }

  void handleChatDeletedEvent(){

  }

  void destroyChat(){
    _chatController.socket.emit("leave_chat", {chatID.value, _currentUser.id});
    chatID.value = "";
    messages.value = [];
    loadedMessages.value = false;
    participantOnline.value = false;
    update();

  }

}