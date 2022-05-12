import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:somdaka_client/controllers/auth.controller.dart';
import 'package:somdaka_client/controllers/blog.controller.dart';
import 'package:somdaka_client/controllers/chats/chat.controller.dart';
import 'package:somdaka_client/controllers/chats/messages.controller.dart';
import 'package:somdaka_client/controllers/message.controller.dart';
import 'package:somdaka_client/controllers/notifications.controller.dart';
import 'package:somdaka_client/layouts/app_layout/app_layout.controller.dart';
import 'package:somdaka_client/services/firebase.service.dart';
import 'package:somdaka_client/views/blog/blog_list.view.dart';
import 'package:somdaka_client/views/chats/chats_list.page.dart';
import 'package:somdaka_client/views/home.view.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  _AppLayoutState createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> with WidgetsBindingObserver{

  late final AuthController _authController;

  @override
  void initState() {
    if(Get.isRegistered<AuthController>()){
      _authController = Get.find<AuthController>();
    }else{
      _authController = Get.put(AuthController());
    }
    Get.put(AppLayoutController());
    Get.put(NotificationsController());
    Get.put(MessageController());
    Get.put(ChatController());
    Get.put(MessagesController());
    Get.put(BlogController());

    Timer(
        const Duration(seconds: 3),
            (){
          FirebaseService().initialiseFirebase();
          FirebaseService().subscribeToTopics();

          FirebaseMessaging.instance.getInitialMessage();
          //Foreground
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            FirebaseService().handleForegroundMessages(message);
          });
        }
    );


    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (kDebugMode) {
          print("app in resumed");
        }
        break;
      case AppLifecycleState.inactive:
        if (kDebugMode) {
          print("app in inactive");
        }
        break;
      case AppLifecycleState.paused:
        if (kDebugMode) {
          print("app in paused");
        }
        break;
      case AppLifecycleState.detached:
        if (kDebugMode) {
          print("app in detached");
        }
        break;
    }
  }

  List<Widget> _buildScreens() {
    return [
      const HomeView(),
      const ChatListPage(),
      const BlogListView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: Theme.of(context).primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.chat_bubble_2),
        title: ("Chats"),
        activeColorPrimary: Theme.of(context).primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.news),
        title: ("Articles"),
        activeColorPrimary: Theme.of(context).primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GetX<AppLayoutController>(
      builder: (controller){
        return PersistentTabView(
          context,
          controller: controller.persistentTabController.value,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
        );
      },
    );

  }
}
