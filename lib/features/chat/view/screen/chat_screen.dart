import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/common/format_date.dart';
import 'package:chat_app/features/chat/controller/chat_controller.dart';
import 'package:chat_app/features/chat/models/chat_model.dart';
import 'package:chat_app/features/chat/view/widget/message_card.dart';
import 'package:chat_app/features/chat/view/widget/view_user_profile.dart';
import 'package:chat_app/features/user/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
  List<MessageModel> _list = [];

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
          title: InkWell(
            onTap: () {
              Get.to(() => ViewUserProfile(userModel: widget.userModel));
            },
            child: StreamBuilder(
                stream: FireStoreServices().getUserInfo(widget.userModel),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  final list =
                      data?.map((e) => UserModel.fromJson(e.data())).toList() ??
                          [];
                  return Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Get.height * .03),
                        child: CachedNetworkImage(
                          width: Get.height * .05,
                          height: Get.height * .05,
                          imageUrl: list.isNotEmpty
                              ? list[0].image
                              : widget.userModel.image,
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  child: Icon(CupertinoIcons.person)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              list.isNotEmpty
                                  ? list[0].name
                                  : widget.userModel.name,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text(
                              list.isNotEmpty
                                  ? list[0].isOnline
                                      ? 'Online'
                                      : FormatDate.getLastActiveTime(
                                          context: context,
                                          lastActive: list[0].lastActive)
                                  : FormatDate.getLastActiveTime(
                                      context: context,
                                      lastActive: widget.userModel.lastActive),
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black54)),
                        ],
                      )
                    ],
                  );
                }),
          ),
        ),
        body: Obx(() => Column(
              children: [
                Expanded(
                    child: StreamBuilder(
                  stream: FireStoreServices.getAllMessages(widget.userModel),
                  builder: (context, snapshot) {
                    final data = snapshot.data?.docs;
                    _list = data
                            ?.map((e) => MessageModel.fromJson(e.data()))
                            .toList() ??
                        [];
                    return _list.isNotEmpty
                        ? ListView.builder(
                            reverse: true,
                            itemCount: _list.length,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(top: Get.height * .01),
                            itemBuilder: (context, index) {
                              return MessageCard(messageModel: _list[index]);
                            })
                        : const Center(
                            child: Text('Say Hii! 👋',
                                style: TextStyle(fontSize: 20)),
                          );
                  },
                )),
                _chatInput(),
                if (controller.isLoading.value)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                if (controller.showEmoji.value)
                  SizedBox(
                    height: Get.height * .35,
                    child: EmojiPicker(
                      textEditingController: textController,
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,

                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        recentTabBehavior: RecentTabBehavior.RECENT,
                        recentsLimit: 28,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ), // Needs to be const Widget
                        loadingIndicator:
                            const SizedBox.shrink(), // Needs to be const Widget
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    ),
                  )
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
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        controller.showEmoji.value =
                            !controller.showEmoji.value;
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 25)),
                  Expanded(
                      child: TextField(
                    onTap: () {
                      if (controller.showEmoji.value) {
                        controller.showEmoji.value =
                            !controller.showEmoji.value;
                      }
                    },
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);
                        for (var e in images) {
                          controller.isLoading.value = true;
                          await FireStoreServices()
                              .sendChatImage(widget.userModel, File(e.path));
                          controller.isLoading.value = false;
                        }
                      },
                      icon: const Icon(Icons.image,
                          color: Colors.blueAccent, size: 26)),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          controller.isLoading.value = true;
                          await FireStoreServices().sendChatImage(
                              widget.userModel, File(image.path));
                          controller.isLoading.value = false;
                        }
                      },
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
                    widget.userModel, textController.text, Type.text);
                textController.clear();
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
