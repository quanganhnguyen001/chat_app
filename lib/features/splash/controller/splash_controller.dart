import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../home/view/screen/home_screen.dart';
import '../../login/view/screen/login_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 2), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Get.offAllNamed(HomeScreen.routeName);
      } else {
        Get.offAllNamed(LoginScreen.routeName);
      }
    });
    super.onInit();
  }
}
