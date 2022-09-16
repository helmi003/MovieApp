// ignore_for_file: deprecated_member_use, avoid_print, avoid_unnecessary_containers, prefer_const_constructors, file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: use_key_in_widget_constructors
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _email, _password;

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

  bool _obscureText = true;

  // Toggles the password show status
  // ignore: unused_element
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } catch (e) {
        showError();
        print(e);
      }
    }
  }

  showError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text("The email address or password are badly formatted."),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            // ignore: sized_box_for_whitespace
            Container(
              height: 400,
              child: Image(
                image: AssetImage("images/verify.png"),
                fit: BoxFit.contain,
              ),
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextFormField(
                          validator: (input) {
                            if (input!.isEmpty) return 'Enter Email';
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email)),
                          onSaved: (input) => _email = input!),
                    ),
                    Container(
                      child: TextFormField(
                          validator: (input) {
                            if (input!.length < 6)
                              // ignore: curly_braces_in_flow_control_structures
                              return 'Provide Minimum 6 Character';
                          },
                          decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: InkWell(
                                  onTap: _toggle,
                                  child: Icon(_obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility))),
                          obscureText: _obscureText,
                          onSaved: (input) => _password = input!),
                    ),
                    SizedBox(height: 20),
                    Padding(
                        padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                        child: ElevatedButton(
                            onPressed: login,
                            child: Text('LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            )))
                  ],
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Don't have an account? ",
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'signup');
                },
                child: Text(
                  "Register now",
                  style: TextStyle(
                      fontSize: 16, decoration: TextDecoration.underline),
                ),
              ),
            ]),
          ],
        ),
      ),
    ));
  }
}
