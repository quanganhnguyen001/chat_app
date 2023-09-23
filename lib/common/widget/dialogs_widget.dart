import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dialogs extends GetxController {
  static void showSnackbar(String msg) {
    Get.snackbar(
      '',
      msg,
      backgroundColor: Colors.blue.withOpacity(.8),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showSpinner() {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }
}
