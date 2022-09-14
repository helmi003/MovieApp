// ignore_for_file: file_names, avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final String uid;
  DatabaseMethods({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future addUserData(
      String userName, String userEmail, String gen, bool admin) async {
    return await userCollection.doc(uid).set({
      "userName": userName,
      "userEmail": userEmail,
      "gender": gen,
      "admin": admin,
    });
  }

  Future getCurrentUserData() async {
    try {
      DocumentSnapshot ds = await userCollection.doc(uid).get();
      String gender = ds.get('gender');
      return gender;
    } catch (e) {
      return null;
    }
  }

  UserData(String id, bool admin, String userName, String userEmail,
      String gender) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((ds) {
      admin = ds['admin'];
      userName = ds['userName'];
      userEmail = ds['userEmail'];
      gender = ds['userEmail'];
    }).catchError((e) {
      print(e);
    });
  }
}
