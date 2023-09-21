import 'package:chat_app/features/home/view/screen/home_screen.dart';
import 'package:chat_app/features/login/view/screen/login_screen.dart';
import 'package:chat_app/features/splash/view/screen/splash_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      onGenerateRoute: (settings) {
        if (settings.name == HomeScreen.routeName) {
          return MaterialPageRoute(
            settings: const RouteSettings(name: HomeScreen.routeName),
            builder: (_) => const HomeScreen(),
          );
        }
        if (settings.name == SplashScreen.routeName) {
          return MaterialPageRoute(
            settings: const RouteSettings(name: SplashScreen.routeName),
            builder: (_) => const SplashScreen(),
          );
        }
        if (settings.name == LoginScreen.routeName) {
          return MaterialPageRoute(
            settings: const RouteSettings(name: LoginScreen.routeName),
            builder: (_) => const LoginScreen(),
          );
        }
        return null;
      },
      title: 'Flutter Demo',
      initialRoute: SplashScreen.routeName,
    );
  }
}
