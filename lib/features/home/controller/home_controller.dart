import 'package:chat_app/features/user/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  final RxList<UserModel> userList = <UserModel>[].obs;

  @override
  void onInit() {
    fetchData();
    FireStoreServices().getSelfInfo();
    super.onInit();
  }

  Future<void> fetchData() async {
    final List<UserModel> result = await FireStoreServices().fetchData();
    userList.value = result;
  }
}
