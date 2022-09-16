// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: deprecated_member_use, unused_import, sized_box_for_whitespace, prefer_const_constructors, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class StartScreen extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<StartScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "home");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_this
    this.checkAuthentification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 35.0),
            Container(
              height: 400,
              child: Image(
                image: AssetImage("images/movieapp.png"),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            RichText(
                text: TextSpan(
                    text: 'Welcome to ',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[200]),
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <TextSpan>[
                  TextSpan(
                      text: "Movie night App",
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange))
                ])),
            SizedBox(height: 10.0),
            Text(
              "It's much easier this way",
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "login");
                        },
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.orange))),
                SizedBox(width: 20.0),
                Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "signup");
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.orange))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
