import 'package:chat_app/features/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

class ProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}
