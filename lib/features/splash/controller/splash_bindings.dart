import 'package:chat_app/features/splash/controller/splash_controller.dart';
import 'package:get/get.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
