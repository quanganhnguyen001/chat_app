import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/common/widget/dialogs_widget.dart';
import 'package:chat_app/features/login/view/screen/login_screen.dart';
import 'package:chat_app/features/profile/controller/profile_controller.dart';
import 'package:chat_app/features/user/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userModel});
  static const String routeName = '/ProfileScreen';
  final UserModel userModel;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? _image;

  @override
  void initState() {
    nameController.text = widget.userModel.name;
    aboutController.text = widget.userModel.about;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(title: const Text('Profile Screen')),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
                backgroundColor: Colors.redAccent,
                onPressed: () async {
                  await FireStoreServices.firebaseAuth.signOut();
                  await GoogleSignIn().signOut();
                  Get.offAllNamed(LoginScreen.routeName);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout')),
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // for adding some space
                    SizedBox(width: Get.width, height: Get.height * .03),

                    //user profile picture
                    Stack(
                      children: [
                        //profile picture
                        _image != null
                            ?

                            //local image
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Get.height * .1),
                                child: Image.file(File(_image!),
                                    width: Get.height * .2,
                                    height: Get.height * .2,
                                    fit: BoxFit.cover))
                            :

                            //image from server
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Get.height * .1),
                                child: CachedNetworkImage(
                                  width: Get.height * .2,
                                  height: Get.height * .2,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.userModel.image,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(CupertinoIcons.person)),
                                ),
                              ),

                        //edit image button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              chooseBottomSheet();
                            },
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: const Icon(Icons.edit, color: Colors.blue),
                          ),
                        )
                      ],
                    ),

                    // for adding some space
                    SizedBox(height: Get.height * .03),

                    // user email label
                    Text(widget.userModel.email,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),

                    // for adding some space
                    SizedBox(height: Get.height * .05),

                    // name input field
                    TextFormField(
                      initialValue: widget.userModel.name,
                      onSaved: (val) => FireStoreServices.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg. Happy Singh',
                          label: const Text('Name')),
                    ),

                    // for adding some space
                    SizedBox(height: Get.height * .02),

                    // about input field
                    TextFormField(
                      initialValue: widget.userModel.about,
                      onSaved: (val) => FireStoreServices.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.info_outline,
                              color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg. Feeling Happy',
                          label: const Text('About')),
                    ),

                    // for adding some space
                    SizedBox(height: Get.height * .05),

                    // update profile button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: Size(Get.width * .5, Get.height * .06)),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          FireStoreServices().updateUserInfo().then((value) {
                            Dialogs.showSnackbar('Updated Successfully');
                          });
                        }
                      },
                      icon: const Icon(Icons.edit, size: 28),
                      label:
                          const Text('UPDATE', style: TextStyle(fontSize: 16)),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void chooseBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: Get.height * .03, bottom: Get.height * .05),
            children: [
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              SizedBox(height: Get.height * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(Get.width * .3, Get.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });

                          FireStoreServices.updateProfilePicture(File(_image!));

                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/add_image.png')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(Get.width * .3, Get.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });

                          FireStoreServices.updateProfilePicture(File(_image!));

                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}
