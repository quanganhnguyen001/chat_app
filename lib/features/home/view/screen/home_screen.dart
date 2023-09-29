import 'package:chat_app/features/home/controller/home_controller.dart';
import 'package:chat_app/features/home/view/widget/chat_card_widget.dart';
import 'package:chat_app/features/login/view/screen/login_screen.dart';
import 'package:chat_app/features/profile/view/profile_screen.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../user/model/user_model.dart';

class HomeScreen extends GetView<HomeController> {
  static const String routeName = '/HomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('QA Chat'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Get.toNamed(ProfileScreen.routeName,
                    arguments: FireStoreServices().me);
              },
              icon: const Icon(CupertinoIcons.profile_circled))
        ],
      ),
      body: Obx(() {
        return controller.userList.isNotEmpty
            ? ListView.builder(
                itemCount: controller.userList.length,
                itemBuilder: (context, index) {
                  final UserModel user = controller.userList[index];
                  return ChatCardWidget(
                    userModel: user,
                  );
                },
              )
            : Center(
                child: Text(
                'Some Error occured pls try again',
                style: TextStyle(fontSize: 20),
              ));
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
            },
            child: const Icon(Icons.add_comment_rounded)),
      ),
    );
  }
}
