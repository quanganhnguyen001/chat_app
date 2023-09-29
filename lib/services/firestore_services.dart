import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../features/user/model/user_model.dart';

class FireStoreServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserModel me = UserModel(
      image: FirebaseAuth.instance.currentUser!.photoURL.toString(),
      about: "Hey, I'm using We Chat!",
      name: FirebaseAuth.instance.currentUser!.displayName.toString(),
      createdAt: '',
      isOnline: false,
      id: FirebaseAuth.instance.currentUser!.uid,
      lastActive: '',
      email: FirebaseAuth.instance.currentUser!.email.toString(),
      pushToken: '');

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
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);
      } else {
        createUser().then((value) => getSelfInfo());
      }
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
}
