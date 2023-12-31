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

import '../../../../common/widget/dialogs_widget.dart';
import '../../../user/model/user_model.dart';

class HomeScreen extends GetView<HomeController> {
  static const String routeName = '/HomeScreen';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (controller.isSearching.value) {
            controller.isSearching.value = !controller.isSearching.value;
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Obx(() => controller.isSearching.value
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Name, Email, ...'),
                    autofocus: true,
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                    onChanged: (value) {
                      controller.searchUser(value);
                    },
                  )
                : Text('QA Chat')),
            actions: [
              Obx(() => IconButton(
                  onPressed: () {
                    controller.isSearching.value =
                        !controller.isSearching.value;
                  },
                  icon: Icon(controller.isSearching.value
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search))),
              IconButton(
                  onPressed: () {
                    Get.toNamed(ProfileScreen.routeName,
                        arguments: FireStoreServices.me);
                  },
                  icon: const Icon(CupertinoIcons.profile_circled))
            ],
          ),
          body: Obx(() {
            return controller.userList.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.isSearching.value
                        ? controller.searchList.length
                        : controller.userList.length,
                    itemBuilder: (context, index) {
                      final UserModel user = controller.userList[index];
                      return ChatCardWidget(
                        userModel: controller.isSearching.value
                            ? controller.searchList[index]
                            : user,
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
                onPressed: () async {},
                child: const Icon(Icons.add_comment_rounded)),
          ),
        ),
      ),
    );
  }

  void _addChatUserDialog() {
    String email = '';

    Get.dialog(AlertDialog(
      contentPadding:
          const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      //title
      title: Row(
        children: const [
          Icon(
            Icons.person_add,
            color: Colors.blue,
            size: 28,
          ),
          Text('  Add User')
        ],
      ),

      //content
      content: TextFormField(
        maxLines: null,
        onChanged: (value) => email = value,
        decoration: InputDecoration(
            hintText: 'Email Id',
            prefixIcon: const Icon(Icons.email, color: Colors.blue),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),

      //actions
      actions: [
        //cancel button
        MaterialButton(
            onPressed: () {
              //hide alert dialog
              Get.back();
            },
            child: const Text('Cancel',
                style: TextStyle(color: Colors.blue, fontSize: 16))),

        //add button
        MaterialButton(
            onPressed: () async {
              //hide alert dialog
              Get.back();
              if (email.isNotEmpty) {
                await FireStoreServices().addChatUser(email).then((value) {
                  if (!value) {
                    Dialogs.showSnackbar('User does not Exists!');
                  }
                });
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ))
      ],
    ));
  }
}
