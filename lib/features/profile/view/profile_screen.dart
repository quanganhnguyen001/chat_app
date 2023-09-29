import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/login/view/screen/login_screen.dart';
import 'package:chat_app/features/user/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userModel});
  static const String routeName = '/ProfileScreen';
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: const Text('Profile Screen')),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                await FireStoreServices().firebaseAuth.signOut();
                await GoogleSignIn().signOut();
                Get.offAllNamed(LoginScreen.routeName);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout')),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * .05),
          child: Column(
            children: [
              SizedBox(width: size.width, height: size.height * .03),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(size.height * .1),
                    child: CachedNetworkImage(
                      width: size.height * .2,
                      height: size.height * .2,
                      fit: BoxFit.fill,
                      imageUrl: userModel.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                      elevation: 1,
                      onPressed: () {},
                      shape: const CircleBorder(),
                      color: Colors.white,
                      child: const Icon(Icons.edit, color: Colors.blue),
                    ),
                  )
                ],
              ),
              SizedBox(height: size.height * .03),
              Text(userModel.email,
                  style: const TextStyle(color: Colors.black54, fontSize: 16)),
              SizedBox(height: size.height * .05),
              TextFormField(
                initialValue: userModel.name,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'eg. Happy Singh',
                    label: const Text('Name')),
              ),
              SizedBox(height: size.height * .02),
              TextFormField(
                initialValue: userModel.about,
                decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.info_outline, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'eg. Feeling Happy',
                    label: const Text('About')),
              ),
              SizedBox(height: size.height * .05),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    minimumSize: Size(size.width * .5, size.height * .06)),
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 28),
                label: const Text('UPDATE', style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ));
  }
}
