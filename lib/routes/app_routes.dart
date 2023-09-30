import 'package:chat_app/features/chat/controller/chat_bindings.dart';
import 'package:chat_app/features/chat/view/screen/chat_screen.dart';
import 'package:chat_app/features/home/controller/home_binding.dart';
import 'package:chat_app/features/home/view/screen/home_screen.dart';
import 'package:chat_app/features/login/controller/login_bindings.dart';
import 'package:chat_app/features/login/view/screen/login_screen.dart';
import 'package:chat_app/features/profile/controller/profile_bindings.dart';
import 'package:chat_app/features/profile/view/profile_screen.dart';
import 'package:chat_app/features/splash/controller/splash_bindings.dart';
import 'package:chat_app/features/splash/view/screen/splash_screen.dart';
import 'package:get/get.dart';

class AppRoute {
  final arguments = Get.arguments as Map<String, dynamic>;
  static final routes = [
    GetPage(
        name: HomeScreen.routeName,
        page: () => HomeScreen(),
        binding: HomeBinding()),
    GetPage(
        name: LoginScreen.routeName,
        page: () => LoginScreen(),
        binding: LoginBindings()),
    GetPage(
        name: SplashScreen.routeName,
        page: () => SplashScreen(),
        binding: SplashBindings()),
    GetPage(
        name: ProfileScreen.routeName,
        page: () => ProfileScreen(
              userModel: Get.arguments,
            ),
        binding: ProfileBindings()),
    GetPage(
        name: ChatScreens.routeName,
        page: () => ChatScreens(
              userModel: Get.arguments,
            ),
        binding: ChatBindings()),
  ];
}
