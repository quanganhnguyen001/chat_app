import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/common/format_date.dart';
import 'package:chat_app/features/chat/models/chat_model.dart';
import 'package:chat_app/features/chat/view/screen/chat_screen.dart';
import 'package:chat_app/features/user/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatCardWidget extends StatelessWidget {
  const ChatCardWidget({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    MessageModel? message;
    final size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: size.width * .04, vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            Get.toNamed(ChatScreens.routeName, arguments: userModel);
          },
          child: StreamBuilder(
            stream: FireStoreServices().getLastMessage(userModel),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => MessageModel.fromJson(e.data())).toList() ??
                      [];
              if (list.isNotEmpty) message = list[0];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(size.height * .03),
                  child: CachedNetworkImage(
                    imageUrl: userModel.image,
                    width: size.height * .055,
                    height: size.height * .055,
                    errorWidget: (context, url, error) => CircleAvatar(
                        child: Icon(
                      CupertinoIcons.person,
                    )),
                  ),
                ),
                title: Text(userModel.name),
                subtitle: Text(
                    message != null
                        ? message!.type == Type.image
                            ? 'image'
                            : message!.msg
                        : userModel.about,
                    maxLines: 1),
                trailing: message == null
                    ? null // show when no message sent
                    : message!.read.isEmpty &&
                            message!.fromId !=
                                FireStoreServices.firebaseAuth.currentUser!.uid
                        ? Container(
                            // show for unread message
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade400,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        : Text(
                            FormatDate().getLastMessageTime(
                                context: context, time: message!.sent),
                            style: TextStyle(color: Colors.black54)),
                // trailing: Text(
                //   '12:00 PM',
                //   style: TextStyle(color: Colors.black54),
                // ),
              );
            },
          )),
    );
  }
}
