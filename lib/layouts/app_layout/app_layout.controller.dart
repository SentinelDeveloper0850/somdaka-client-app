import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AppLayoutController extends GetxController{

  var persistentTabController = PersistentTabController(initialIndex: 0).obs;

  @override
  void onInit() {
    persistentTabController.value.addListener(() {
      if (kDebugMode) {
        print("[AppLayoutController]::: Navigated to index: ${persistentTabController.value.index}");
      }
    });
    super.onInit();
  }

}