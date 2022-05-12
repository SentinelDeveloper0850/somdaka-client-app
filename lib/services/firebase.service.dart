import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:somdaka_client/controllers/auth.controller.dart';

import 'package:somdaka_client/controllers/chats/messages.controller.dart';
import 'package:somdaka_client/controllers/notifications.controller.dart';

class FirebaseService{
  final String _alarmTopicSlug = "Alarms-";
  final String _chatMessagesTopicSlug = "Messages-";

  late final MessagesController _messagesController;
  late final AuthController _authController ;
  late final NotificationsController _notificationsController;

  late String _userID;

  FirebaseService(){
   _authController =  Get.find<AuthController>();
   _notificationsController = Get.find<NotificationsController>();

   _messagesController = Get.find<MessagesController>();
   _userID = _authController.currentUser.value.id;
  }

  Future<void> initialiseFirebase() async{
    await Firebase.initializeApp();
    String? token = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      print("Firebase Token: " + token!);
    }

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future<void> subscribeToTopics() async{
    await FirebaseMessaging.instance.subscribeToTopic(_chatMessagesTopicSlug + _userID);

  }

  Future<void> unsubscribeFromTopics() async{

    await FirebaseMessaging.instance.unsubscribeFromTopic(_alarmTopicSlug + _userID);
    await FirebaseMessaging.instance.unsubscribeFromTopic(_chatMessagesTopicSlug + _userID);

  }

  void handleForegroundMessages(RemoteMessage message){
    try{
      Map<String, dynamic> parsedObj = json.decode(message.data["body"]);

      // print(parsedObj);

      if(parsedObj.containsKey("message_to")){

        //Check if the user is currently in the chat
        if(parsedObj.containsKey("chat_id")){
          if(_messagesController.chatID != parsedObj["chat_id"]){
            _notificationsController.displayChatNotification(parsedObj);
          }
        }else{
          _notificationsController.displayChatNotification(parsedObj);
        }
      }
    }
    catch(exception){
      if (kDebugMode) {
        print(exception);
      }
    }

  }


}