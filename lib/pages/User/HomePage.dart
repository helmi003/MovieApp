// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: unnecessary_this, prefer_const_constructors, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp6/Components/search.dart';
import 'package:tp6/pages/Admin/Movies/MovieDetail.dart';
import '../../Components/drawer.dart';

// ignore: use_key_in_widget_constructors
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          title: Text("Movies"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: Search());
              },
            ),
          ],
          elevation: 6,
        ),
        drawer: drawer(),
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
                          return Column(
                            children: snapshot.data!.docs.map((document) {
                              return snapshot.data!.docs.isEmpty
                                  ? Center(
                                      child: Text("There is no Movies yet"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MovieDetail(
                                                                data:
                                                                    document)));
                                              },
                                              child: Container(
                                                height: 200,
                                                width: 130,
                                                child: Image.network(
                                                    document['image']),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[800],
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(document['name'],
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                                SizedBox(height: 20),
                                                Container(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Text(
                                                          document['genre'],
                                                          style: TextStyle(
                                                              fontSize: 25))),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[350],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            document['rating']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 15)),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors
                                                              .orange[400],
                                                        ),
                                                      ],
                                                    )),
                                                SizedBox(height: 5),
                                                Text(document['language'],
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                                SizedBox(height: 5),
                                                Text(document['duration'],
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            }).toList(),
                          );
                        }),
                  ],
                ),
        ));
  }
}
