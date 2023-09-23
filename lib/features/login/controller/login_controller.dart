import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../common/widget/dialogs_widget.dart';
import '../../home/view/screen/home_screen.dart';

class LoginController extends GetxController {
  RxBool isAnimate = false.obs;

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 500), () {
      isAnimate.value = true;
    });
    super.onInit();
  }

  login() {
    Dialogs.showSpinner();
    signInWithGoogle().then((value) {
      Get.back();
      if (value != null) {
        log('\nUser: ${value.user}');
        Get.offAllNamed(HomeScreen.routeName);
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      Dialogs.showSnackbar('Something went wrong pls check your internet');
      print(e);
      return null;
    }
  }
}
