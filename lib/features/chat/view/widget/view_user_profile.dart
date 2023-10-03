import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/common/format_date.dart';
import 'package:chat_app/features/user/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewUserProfile extends StatelessWidget {
  const ViewUserProfile({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          //app bar
          appBar: AppBar(title: Text(userModel.name)),
          floatingActionButton: //user about
              Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined On: ',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              Text(
                  FormatDate().getLastMessageTime(
                      context: context,
                      time: userModel.createdAt,
                      showYear: true),
                  style: const TextStyle(color: Colors.black54, fontSize: 15)),
            ],
          ),

          //body
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for adding some space
                  SizedBox(width: Get.width, height: Get.height * .03),

                  //user profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Get.height * .1),
                    child: CachedNetworkImage(
                      width: Get.height * .2,
                      height: Get.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: userModel.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  // for adding some space
                  SizedBox(height: Get.height * .03),

                  // user email label
                  Text(userModel.email,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 16)),

                  // for adding some space
                  SizedBox(height: Get.height * .02),

                  //user about
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Text(userModel.about,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
