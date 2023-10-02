import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/chat/controller/chat_controller.dart';
import 'package:chat_app/features/chat/view/widget/message_card.dart';
import 'package:chat_app/features/user/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreens extends StatefulWidget {
  const ChatScreens({super.key, required this.userModel});
  static const String routeName = '/ChatScreens';
  final UserModel userModel;

  @override
  State<ChatScreens> createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens> {
  final textController = TextEditingController();
  final controller = Get.put(ChatController());

  @override
  void initState() {
    controller.getAllMessages(widget.userModel);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.black54)),
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Get.height * .03),
                child: CachedNetworkImage(
                  width: Get.height * .05,
                  height: Get.height * .05,
                  imageUrl: widget.userModel.image,
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.userModel.name,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  const Text('Last seen not available',
                      style: TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              )
            ],
          ),
        ),
        body: Obx(() => Column(
              children: [
                Expanded(
                    child: controller.messageList.isNotEmpty
                        ? ListView.builder(
                            itemCount: controller.messageList.length,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(top: Get.height * .01),
                            itemBuilder: (context, index) {
                              return MessageCard(
                                  messageModel: controller.messageList[index]);
                            })
                        : const Center(
                            child: Text('Say Hii! 👋',
                                style: TextStyle(fontSize: 20)),
                          )),
                _chatInput(),
              ],
            )),
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Get.height * .01, horizontal: Get.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 25)),
                  Expanded(
                      child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.image,
                          color: Colors.blueAccent, size: 26)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Colors.blueAccent, size: 26)),
                  SizedBox(width: Get.width * .02),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                FireStoreServices.sendMessage(
                    widget.userModel, textController.text);
                textController.clear();
                controller.getAllMessages(widget.userModel);
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
