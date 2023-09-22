import 'package:chat_app/features/home/view/screen/home_screen.dart';
import 'package:chat_app/features/login/view/screen/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    final size = MediaQuery.of(context).size;

    return Scaffold(
      //body
      body: Stack(children: [
        //app logo
        Positioned(
            top: size.height * .15,
            right: size.width * .25,
            width: size.width * .5,
            child: Image.asset('assets/images/chat.png')),

        //google login button
        Positioned(
            bottom: size.height * .15,
            width: size.width,
            child: const Text('WELCOME TO QA CHAT',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Colors.black87, letterSpacing: .5))),
      ]),
    );
  }
}
