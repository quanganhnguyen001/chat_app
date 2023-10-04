import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/common/format_date.dart';
import 'package:chat_app/features/chat/models/chat_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/widget/dialogs_widget.dart';
import 'option_item.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.messageModel});
  final MessageModel messageModel;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = FireStoreServices.firebaseAuth.currentUser!.uid ==
        widget.messageModel.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
  }

  // sender or another user message
  Widget _blueMessage() {
    if (widget.messageModel.read.isEmpty) {
      FireStoreServices().updateMessageReadStatus(widget.messageModel);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.messageModel.type == Type.image
                ? Get.width * .03
                : Get.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: Get.width * .04, vertical: Get.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: widget.messageModel.type == Type.text
                ? Text(
                    widget.messageModel.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      imageUrl: widget.messageModel.msg,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: Get.width * .04),
          child: Text(
            FormatDate().getFormattedTime(widget.messageModel.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  // our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        Row(
          children: [
            //for adding some space
            SizedBox(width: Get.width * .04),

            //double tick blue icon for message read
            if (widget.messageModel.read.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            //for adding some space
            const SizedBox(width: 2),

            //read time
            Text(
              FormatDate().getFormattedTime(widget.messageModel.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.messageModel.type == Type.image
                ? Get.width * .03
                : Get.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: Get.width * .04, vertical: Get.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: widget.messageModel.type == Type.text
                ? Text(
                    widget.messageModel.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      imageUrl: widget.messageModel.msg,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: Get.height * .015, horizontal: Get.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              widget.messageModel.type == Type.text
                  ?
                  //copy option
                  OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.messageModel.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Get.back();

                          Dialogs.showSnackbar('Text Copied!');
                        });
                      })
                  :
                  //save option
                  OptionItem(
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Save Image',
                      onTap: () async {
                        // try {
                        //   log('Image Url: ${widget.messageModel.msg}');
                        //   await GallerySaver.saveImage(widget.message.msg,
                        //           albumName: 'We Chat')
                        //       .then((success) {
                        //     //for hiding bottom sheet
                        //     Navigator.pop(context);
                        //     if (success != null && success) {
                        //       Dialogs.showSnackbar(
                        //           context, 'Image Successfully Saved!');
                        //     }
                        //   });
                        // } catch (e) {
                        //   log('ErrorWhileSavingImg: $e');
                        // }
                      }),

              //separator or divider
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: Get.width * .04,
                  indent: Get.width * .04,
                ),

              //edit option
              if (widget.messageModel.type == Type.text && isMe)
                OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Edit Message',
                    onTap: () {
                      //for hiding bottom sheet
                      // Navigator.pop(context);

                      _showMessageUpdateDialog();
                    }),

              //delete option
              if (isMe)
                OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      await FireStoreServices()
                          .deleteMessage(widget.messageModel)
                          .then((value) {
                        //for hiding bottom sheet
                        Get.back();
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.black54,
                endIndent: Get.width * .04,
                indent: Get.width * .04,
              ),
            ],
          );
        });
  }

  void _showMessageUpdateDialog() {
    String updatedMsg = widget.messageModel.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Update Message')
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      // Navigator.pop(context);
                      // APIs.updateMessage(widget.messageModel, updatedMsg);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
