import 'dart:developer';
import 'dart:io';

import 'package:chat_app/common/widget/dialogs_widget.dart';
import 'package:chat_app/features/home/view/screen/home_screen.dart';
import 'package:chat_app/features/login/controller/login_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../common/widget/dialogs_widget.dart';

class LoginScreen extends GetView<LoginController> {
  static const String routeName = '/LoginScreen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      //app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login'),
      ),

      body: Stack(children: [
        Obx(() => AnimatedPositioned(
              duration: Duration(seconds: 1),
              top: size.height * .15,
              right: controller.isAnimate.value
                  ? size.width * .25
                  : -size.width * .5,
              width: size.width * .5,
              child: Image.asset('assets/images/chat.png'),
            )),
        Positioned(
          bottom: size.height * .15,
          left: size.width * .05,
          width: size.width * .9,
          height: size.height * .06,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 223, 255, 187),
              shape: const StadiumBorder(),
              elevation: 1,
            ),
            onPressed: () {
              controller.login();
            },
            icon: Image.asset('assets/images/google.png',
                height: size.height * .03),
            label: RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  TextSpan(text: 'Sign In with '),
                  TextSpan(
                    text: 'Google',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
