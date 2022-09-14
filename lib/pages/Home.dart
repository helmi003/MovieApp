// ignore_for_file: prefer_const_constructors, file_names, unnecessary_this, non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp6/pages/Admin/AdminScreen.dart';
import 'package:tp6/pages/User/HomePage.dart';

// ignore: use_key_in_widget_constructors
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isloggedin = false;
  late bool admin = false;
  late String userName = '';
  late String userEmail = '';
  late String gender = '';

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser!;
        this.isloggedin = true;
      });
    }
  }

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.getUser();
    this.checkAuthentification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !isloggedin
            ? Center(child: CircularProgressIndicator())
            : FutureBuilder(
                future: UserData(),
                builder: (context, snapshot) {
                  return admin == true ? AdminScreen() : HomeScreen();
                }));
  }

  UserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((ds) {
      admin = ds['admin'];
    }).catchError((e) {
      print(e);
    });
  }
}
