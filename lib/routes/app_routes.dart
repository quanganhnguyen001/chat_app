import 'package:chat_app/features/home/controller/home_binding.dart';
import 'package:chat_app/features/home/view/screen/home_screen.dart';
import 'package:chat_app/features/login/controller/login_bindings.dart';
import 'package:chat_app/features/login/view/screen/login_screen.dart';
import 'package:chat_app/features/splash/controller/splash_bindings.dart';
import 'package:chat_app/features/splash/view/screen/splash_screen.dart';
import 'package:get/get.dart';

class AppRoute {
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
        binding: SplashBindings())
  ];
}
