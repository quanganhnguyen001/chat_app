import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../features/user/model/user_model.dart';

class FireStoreServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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
}
