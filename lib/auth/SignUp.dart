// ignore: duplicate_ignore
// ignore_for_file: deprecated_member_use, avoid_unnecessary_containers, prefer_const_constructors, file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tp6/data/UserDataBase.dart';
// ignore: use_key_in_widget_constructors

// ignore: use_key_in_widget_constructors
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

enum SingingCharacter { male, female }

class _SignUpState extends State<SignUp> {
  // ignore: prefer_final_fields
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SingingCharacter? _character = SingingCharacter.male;
  late String _name, _email, _password;
  final TextEditingController confirmPass = TextEditingController();
  final TextEditingController pass = TextEditingController();

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "home");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_this
    this.checkAuthentication();
  }

  bool _obscureText = true;
  bool _obscureText2 = true;

  // Toggles the password show status
  // ignore: unused_element
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  String perm = "false";
  signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        String uid = FirebaseAuth.instance.currentUser!.uid;
        String gender = _character.toString();
        String gen = gender.substring(17);
        bool admin = false;
        await _auth.currentUser!.updateProfile(displayName: _name);
        await DatabaseMethods(uid: uid).addUserData(_name, _email, gen,admin);
      } catch (e) {
        showError();
      }
    }
  }

  showError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content:
                Text("The email address is already in use by another account."),
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
      body: ListView(
        children: <Widget>[
          // ignore: sized_box_for_whitespace
          Container(
            height: 400,
            child: Image(
              image: AssetImage("images/verify.png"),
              fit: BoxFit.contain,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                    validator: (input) {
                      if (input!.isEmpty) {
                        return 'Enter Name';
                      } else if (input.length < 5) {
                        return 'Provide Minimum 5 Character';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    onSaved: (input) => _name = input!),
                TextFormField(
                    validator: (input) {
                      if (input!.isEmpty) return 'Enter Email';
                    },
                    decoration: InputDecoration(
                        labelText: 'Email', prefixIcon: Icon(Icons.email)),
                    onSaved: (input) => _email = input!),
                TextFormField(
                    controller: pass,
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
                TextFormField(
                  controller: confirmPass,
                  validator: (input) {
                    if (input!.isEmpty) return 'Enter your confimed password';
                    if (input != pass.text)
                      // ignore: curly_braces_in_flow_control_structures
                      return 'you have to wrirte the same password';
                  },
                  decoration: InputDecoration(
                      labelText: 'Confirm password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: InkWell(
                          onTap: _toggle2,
                          child: Icon(_obscureText2
                              ? Icons.visibility_off
                              : Icons.visibility))),
                  obscureText: _obscureText2,
                ),
                SelectRadioButton(),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
                  Padding(
                        padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                        child: ElevatedButton(
                            onPressed: signUp,
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
                            ))),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "Already have an account? ",
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "login");
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 16, decoration: TextDecoration.underline),
                      ),
                    ),
                  ]),
                ]),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget SelectRadioButton() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Male'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.male,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Female'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.female,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
