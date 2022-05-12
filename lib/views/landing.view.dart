import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:somdaka_client/controllers/auth.controller.dart';
import 'package:somdaka_client/services/local.notification.service.dart';
import 'package:somdaka_client/widgets/loaders/generic_loader.component.dart';

class LandingView extends StatefulWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {

  @override
  void initState() {
    Timer(
        const Duration(seconds: 3),
            () => checkIfSignedIn()
    );
    super.initState();

    // Give you the message on which user taps
    // and it opens the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];

        Get.toNamed(routeFromMessage);
      }
    });

    // Called when app is in the foreground...
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        if (kDebugMode) {
          print(message.notification?.title);
          print(message.notification?.body);
        }
      }

      LocalNotificationService.display(message);
    });

    // Called when app is in background but is running and user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Get.toNamed(routeFromMessage);
    });
  }

  void checkIfSignedIn(){
    try{
      AuthController _authController = Get.find<AuthController>();

      if(_authController.userIsLoggedIn.value){

        // Get.offNamed('/home');
        Get.offNamed('/main');
      }
      else{
        Get.offNamed('/login');
      }
    }
    catch(e){
      Get.put(AuthController());
      Get.offNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffFA9D00),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff7ac5fe),
              Color(0xffFA9D00),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 100, bottom: 0),
              child: const Image(
                image: AssetImage("assets/images/logo_sm.png"),
                height: 100,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            const Text('SOMDAKA FUNERAL SERVICES',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Expanded(
              child: GenericLoaderComponent(title: ""),
            ),
          ],
        ),
      ),
    );
  }
}

