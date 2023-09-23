import 'package:chat_app/features/home/view/screen/home_screen.dart';
import 'package:chat_app/features/login/view/screen/login_screen.dart';
import 'package:chat_app/features/splash/view/screen/splash_screen.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),
        backgroundColor: Colors.white,
      )),
      getPages: AppRoute.routes,
      title: 'Flutter Demo',
      initialRoute: SplashScreen.routeName,
    );
  }
}
