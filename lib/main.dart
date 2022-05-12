import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:somdaka_client/layouts/app_layout/app.layout.dart';
import 'package:somdaka_client/views/home.view.dart';
import 'package:somdaka_client/views/landing.view.dart';
import 'package:somdaka_client/views/login.view.dart';

// Receive message when app is in background, solution for onMessage
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print(message.data.toString());
    print(message.notification?.title);
  }
}

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  //
  // FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Somdaka Funeral Services',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xffFA9D00),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primaryContainer: const Color.fromRGBO(247, 247, 247, 0),
          secondary: const Color(0xffFFBE50),
          onSecondary: const Color(0xffFA9D00),
          secondaryContainer: const Color(0xffFFBE50),
          background: const Color(0xfff1f1f1),
        ),
        appBarTheme: const AppBarTheme(
          // backgroundColor: Color.fromRGBO(2,14,37, 1.0),
          backgroundColor: Color(0xffFA9D00),
          titleTextStyle: TextStyle(
              color: Colors.white,
              // color: Colors.white,
              fontSize: 18
          ),
          toolbarHeight: 60,
          centerTitle: true,
          elevation: 0,
          toolbarTextStyle: TextStyle(
              color: Colors.white,
              // color: Colors.white,
              fontSize: 18
          ),
          iconTheme: IconThemeData(color: Colors.white),
          // iconTheme: IconThemeData(color: Colors.white),
          // brightness: Brightness.dark
        ),
      ),
      initialRoute: '/landing',
      getPages: [
        GetPage(name: '/landing', page: () => const LandingView()),
        GetPage(name: '/main', page: () => const AppLayout()),
        GetPage(name: '/home', page: () => const HomeView()),
        GetPage(name: '/login', page: () => const LoginView()),
      ],
    );
  }
}