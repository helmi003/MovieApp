// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: unnecessary_this, prefer_const_constructors, file_names, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp6/pages/Admin/Movies/ModifyMovie.dart';
import '../../data/MovieDataBase.dart';

// ignore: use_key_in_widget_constructors
class MovieAdmin extends StatefulWidget {
  @override
  _MovieAdminState createState() => _MovieAdminState();
}

class _MovieAdminState extends State<MovieAdmin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

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

  @override
  void initState() {
    super.initState();
    this.getUser();
    this.checkAuthentification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "adminscreen");
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "addmovie");
              },
            ),
          ],
          elevation: 6,
        ),
        body: Container(
          child: !isloggedin
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    SizedBox(height: 20),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('movies')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GridView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            children: snapshot.data!.docs.map((document) {
                              String id = document.id;
                              return snapshot.data!.docs.isEmpty
                                  ? Center(
                                      child: Text("There is no Movies yet"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: GridTile(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[800],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            height: 200,
                                            width: 130,
                                            child: GestureDetector(
                                              onLongPress: () {
                                                Alert(id);
                                              },
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ModifyMovie(
                                                              data: document,
                                                              id: id,
                                                            )));
                                              },
                                              child: Image.network(
                                                  document['image']),
                                            )),
                                        footer: Center(
                                          child: Text(document['name'],
                                              style: TextStyle(fontSize: 25)),
                                        ),
                                      ));
                            }).toList(),
                          );
                        }),
                  ],
                ),
        ));
  }

  // ignore: non_constant_identifier_names
  Alert(String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text("Do you want to delete this movie"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
              TextButton(
                  onPressed: () {
                    DatabaseMethodsMovies().deleteMovie(id);
                    Navigator.of(context).pop();
                  },
                  child: Text('YES'))
            ],
          );
        });
  }
}
