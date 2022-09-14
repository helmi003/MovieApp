// ignore_for_file: prefer_const_constructors, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tp6/pages/Admin/ReservationDetail.dart';
import 'package:intl/intl.dart';

// ignore: use_key_in_widget_constructors
class ReservationAdmin extends StatefulWidget {
  @override
  _ReservationAdminState createState() => _ReservationAdminState();
}

class _ReservationAdminState extends State<ReservationAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservation"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "adminscreen");
          },
        ),
        elevation: 6,
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('reservation')
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
                    String id = document.id;

                    return snapshot.data!.docs.isEmpty
                        ? Center(
                            child: Text("There is no reservation yet"),
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ReservationDetail(
                                            data: document,
                                            id: id,
                                          )));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.grey[800],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        Text(
                                          "Reservation ID# ",
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Reservation Time ",
                                            style: TextStyle(
                                                color: Colors.orange)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Customer Name ",
                                            style: TextStyle(
                                                color: Colors.orange)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Movie Name ",
                                            style: TextStyle(
                                                color: Colors.orange)),
                                      ]),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  // ignore: prefer_const_literals_to_create_immutables
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(id),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(DateFormat('hh:mm').format(
                                            document["reservation"].toDate())),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(document["userName"]),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(document["movieN"]),
                                      ]),
                                  SizedBox(
                                    height: 100,
                                  ),
                                ],
                              ),
                            ));
                  }).toList(),
                );
              }),
        ],
      ),
    );
  }
}
