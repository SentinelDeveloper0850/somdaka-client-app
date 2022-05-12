import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:somdaka_client/models/chats/chat_message.model.dart';
import 'package:somdaka_client/models/users/user_notification_setting.model.dart';
import 'package:somdaka_client/views/home.view.dart';

class NotificationsController extends GetxController{

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late AndroidNotificationDetails _androidPlatformChannelSpecifics;
  late NotificationDetails _platformChannelSpecifics;

  var chatNotifications = "".obs;
  var alarmNotifications = "".obs;

  var userNotificationSettings = IUserNotificationSetting(
    userId: "",
    priorities: [],
    siteIds: [],
    //silencedAlarmNotifications: []
  ).obs;

  @override
  void onInit(){
    super.onInit();

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initialiseSettings();

  }

  void _initialiseSettings() async{
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("@mipmap/ic_launcher");

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification:
        (
          int id,
          String? title,
          String? body,
          String? payload
        ) async {}
      );

    const MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);

    _androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
            "smileykidsnorkempark",
            "smileykidsnorkempark channel",
            icon: "@mipmap/ic_launcher",
            largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false
        );

    _platformChannelSpecifics =
        NotificationDetails(android: _androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification:  (String? payload) async {
          if (payload != null) {
            print('notification payload: ' + payload);
          }

          Map<String, dynamic> parsedObj = json.decode(payload!);

          Get.put(  const HomeView());
          if(parsedObj.containsKey("message_to")){
            Get.toNamed("/chat_notifications_page");
            // Get.put(  const AppLayout());
            // localNotificationsController.newChatMessage(payload);

          }
          else{
            Get.toNamed('/main');

            // localNotificationsController.newNotification(payload);
            //
          }
    });

  }

  void displayChatNotification(Map<String, dynamic> data) async{
    await _flutterLocalNotificationsPlugin.show(
        0,
        data["title"],
        data["body"],
        _platformChannelSpecifics,
        payload: json.encode(data)
    );
  }

  void displayNewChatMessageNotification(ChatMessage chatMessage) async{

    await _flutterLocalNotificationsPlugin.show(
        0,
        "New Chat Message",
        chatMessage.message,
        _platformChannelSpecifics,
        payload: chatMessage.toRawJson()
    );
  }


}