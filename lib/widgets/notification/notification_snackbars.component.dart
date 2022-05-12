import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSnackBarsComponent{

  void showSuccess(String message){

    Get.snackbar(
      "Operation Successful",
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showError(String message){

    Get.snackbar(
      "Operation Failed",
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

}
