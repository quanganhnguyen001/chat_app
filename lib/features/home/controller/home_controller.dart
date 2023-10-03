import 'dart:developer';

import 'package:chat_app/features/user/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;
  final RxList<UserModel> userList = <UserModel>[].obs;
  final RxList<UserModel> searchList = <UserModel>[].obs;

  @override
  void onInit() {
    fetchData();
    FireStoreServices().getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');
      //for updating user active status according to lifecycle events
      //resume -- active or online
      //pause  -- inactive or offline

      if (FireStoreServices.firebaseAuth.currentUser != null) {
        if (message.toString().contains('resume')) {
          FireStoreServices().updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          FireStoreServices().updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
    super.onInit();
  }

  Future<void> fetchData() async {
    final List<UserModel> result = await FireStoreServices().fetchData();
    userList.value = result;
  }

  searchUser(String value) {
    searchList.clear();
    for (var e in userList) {
      if (e.name.toLowerCase().contains(value.toLowerCase()) ||
          e.email.toLowerCase().contains(value.toLowerCase())) {
        searchList.add(e);
      }
      searchList;
    }
  }
}
