import 'dart:io';

import 'package:chat_app/features/chat/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../features/user/model/user_model.dart';

class FireStoreServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
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

  Future<void> updateInfo({required String name, required String about}) async {
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'name': name,
      'about': about,
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
    await ref.doc(time).set(message.toJson());
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
    });
  }
}
