// ignore_for_file: prefer_const_constructors, file_names, deprecated_member_use, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Reservation.dart';

class MovieDetail extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const MovieDetail({this.data});
  final QueryDocumentSnapshot<Object?>? data;

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: avoid_unnecessary_containers
      appBar: AppBar(
        title: Text(widget.data!.get('name')),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 6,
      ),
      body: ListView(
        children: [
          Container(
              color: Colors.grey[800],
              height: 200,
              child: Center(
                  child: Stack(
                children: [
                  SizedBox(
                    height: 200,
                    child: Image.asset("images/background.jpg"),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: FloatingActionButton(
                      onPressed: () async {
                        String url = widget.data!.get("url");
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          Alert();
                        }
                      },
                      child: Icon(
                        Icons.play_arrow,
                      ),
                    ),
                  ),
                ],
              ))),
              SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              children: [
                Container(
                  height: 200,
                  width: 130,
                  child: Image.network(widget.data!.get('image')),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(widget.data!.get('genre'),
                                style: TextStyle(fontSize: 25))),
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text(widget.data!.get('rating').toString(),
                                  style: TextStyle(fontSize: 15)),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.orange[400],
                              ),
                            ],
                          )),
                      SizedBox(height: 5),
                      Text(widget.data!.get('language'),
                          style: TextStyle(fontSize: 15)),
                      SizedBox(height: 5),
                      Text(widget.data!.get('duration'),
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
              width: 5,
              child: Text(
                "Details:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Playing Date:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(DateFormat('yyyy-MM-dd')
                        .format(widget.data!.get('date').toDate())),
                  ],
                ),
                SizedBox(width: 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Playing Time:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(widget.data!.get('time')),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: 5,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    "Ticket Price:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "€ ${widget.data!.get('price')}",
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Descriton:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.data!.get('description'),
                  ),
                ]),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Reservation(
                          name: widget.data!.get('name'),
                          price: widget.data!.get('price'),
                          date: widget.data!.get('date').toDate(),
                          time: widget.data!.get('time'),
                          genre: widget.data!.get('genre'),
                          rating: widget.data!.get('rating').toString(),
                          language: widget.data!.get('language'),
                          duration: widget.data!.get('duration'),
                          image: widget.data!.get('image'))));
            },
            child: const Text('Book Ticket',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  Alert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Appologies'),
            content: Text("link not available :'("),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok')),
            ],
          );
        });
  }
}
