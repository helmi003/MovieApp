// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class drawer extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<drawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isloggedin = false;

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

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: !isloggedin
            ? Center(child: CircularProgressIndicator())
            : ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text("${user.displayName}",
                      style: TextStyle(color: Colors.white)),
                  accountEmail: Text("${user.email}",
                      style: TextStyle(color: Colors.white)),
                  currentAccountPicture: GestureDetector(
                      onTap: () {
                        // Navigator.of(context).pushNamed('profile');
                      },
                      child: CircleAvatar(
                          radius: 80,
                          backgroundImage:
                              AssetImage("images/female.png"))),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/background.jpg"),
                          fit: BoxFit.cover)),
                ),
                ListTile(
                  title: Text(
                    "Home page",
                    style: TextStyle(fontSize: 18),
                  ),
                  leading: Icon(
                    Icons.home,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('home');
                  },
                ),
                ListTile(
                  title: Text("Log out", style: TextStyle(fontSize: 18)),
                  leading: Icon(
                    Icons.logout,
                  ),
                  onTap: signOut,
                ),
              ],
            ));
  }
}
