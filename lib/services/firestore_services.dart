import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/features/chat/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

import '../features/user/model/user_model.dart';

class FireStoreServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static late UserModel me;

  Future<List<UserModel>> fetchData() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('users')
        .where('id', isNotEqualTo: firebaseAuth.currentUser!.uid)
        .get();
    final List<UserModel> data = [];

    for (final DocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      data.add(UserModel.fromJson(document.data()!));
    }

    return data;
  }

  Future<void> getFirebaseMessagingToken() async {
    await firebaseMessaging.requestPermission();

    await firebaseMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });

    // for handling foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   log('Got a message whilst in the foreground!');
    //   log('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     log('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }

  static Future<void> sendPushNotification(
      UserModel userModel, String msg) async {
    try {
      final body = {
        "to": userModel.pushToken,
        "notification": {
          "title": me.name, //our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAtgDLXQk:APA91bFnomCKok15ajGKrS_en6EnKWPHcgUsNcmFuh6ssWk-jif_rO_ZBRoSS7bHR1y-DA7U5DwzgbQVRl4nLkrorggLz1Cq10eh6gRCREbntkuWyCZXM5O-r9NQpFuDYMeC6vF0QpvP'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .get())
        .exists;
  }

  Future<void> getSelfInfo() async {
    return (await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((user) {
      me = UserModel.fromJson(user.data()!);
      getFirebaseMessagingToken();
    }));
  }

  Future createUser() async {
    return await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .set(UserModel(
                about: "Hey, I'm using QA Chat !",
                createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
                email: firebaseAuth.currentUser!.email.toString(),
                id: firebaseAuth.currentUser!.uid,
                image: firebaseAuth.currentUser!.photoURL.toString(),
                isOnline: false,
                lastActive: DateTime.now().millisecondsSinceEpoch.toString(),
                name: firebaseAuth.currentUser!.displayName.toString(),
                pushToken: '')
            .toJson());
  }

  Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'name': me.name,
      'about': me.about,
    });
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;

    final ref = storage
        .ref()
        .child('profile_pictures/${firebaseAuth.currentUser!.uid}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'image': me.image});
  }

  static String getConversationID(String id) =>
      firebaseAuth.currentUser!.uid.hashCode <= id.hashCode
          ? '${firebaseAuth.currentUser!.uid}_$id'
          : '${id}_${firebaseAuth.currentUser!.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      UserModel userModel, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final MessageModel message = MessageModel(
        toId: userModel.id,
        msg: msg,
        read: '',
        type: type,
        fromId: firebaseAuth.currentUser!.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(userModel.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(userModel, type == Type.text ? msg : 'image'));
  }

  Future<void> updateMessageReadStatus(MessageModel message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(UserModel user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  Future<void> sendChatImage(UserModel userModel, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(userModel.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(userModel, imageUrl, Type.image);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(UserModel userModel) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: userModel.id)
        .snapshots();
  }

  Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(firebaseAuth.currentUser!.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  Future<void> deleteMessage(MessageModel message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }
}
