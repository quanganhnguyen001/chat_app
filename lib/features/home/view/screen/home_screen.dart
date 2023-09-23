import 'package:chat_app/features/home/controller/home_controller.dart';
import 'package:chat_app/features/home/view/widget/chat_card_widget.dart';
import 'package:chat_app/features/login/view/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends GetView<HomeController> {
  static const String routeName = '/HomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(CupertinoIcons.home),
        title: const Text('QA Chat'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return ChatCardWidget();
        },
      ),
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
