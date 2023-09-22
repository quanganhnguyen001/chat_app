import 'dart:developer';

import 'package:chat_app/features/home/view/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isAnimate = true;
      });
    });
  }

  login() {
    signInWithGoogle().then((value) {
      log('\nUser: ${value.user}');
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      //app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login'),
      ),

      body: Stack(children: [
        AnimatedPositioned(
          duration: Duration(seconds: 1),
          top: size.height * .15, // Set top position here
          right: isAnimate ? size.width * .25 : -size.width * .5,
          width: size.width * .5,
          child: Image.asset('assets/images/chat.png'),
        ),
        Positioned(
          bottom: size.height * .15,
          left: size.width * .05,
          width: size.width * .9,
          height: size.height * .06,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 223, 255, 187),
              shape: const StadiumBorder(),
              elevation: 1,
            ),
            onPressed: () {
              login();
            },
            icon: Image.asset('assets/images/google.png',
                height: size.height * .03),
            label: RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  TextSpan(text: 'Sign In with '),
                  TextSpan(
                    text: 'Google',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
