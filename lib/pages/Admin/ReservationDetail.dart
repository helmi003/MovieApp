// ignore_for_file: prefer_const_constructors, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationDetail extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const ReservationDetail({this.data, required this.id});
  final QueryDocumentSnapshot<Object?>? data;
  final String id;

  @override
  _ReservationDetailState createState() => _ReservationDetailState();
}

class _ReservationDetailState extends State<ReservationDetail> {
  late String id = widget.id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // ignore: avoid_unnecessary_containers
        appBar: AppBar(
        title: Text("Reservation Detail"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 6,
      ),
        body: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.grey[800],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      "Reservation ID# ",
                      style: TextStyle(color: Colors.orange),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Reservation Time ",
                        style: TextStyle(color: Colors.orange)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Customer Name ",
                        style: TextStyle(color: Colors.orange)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Movie Name ", style: TextStyle(color: Colors.orange)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Email ", style: TextStyle(color: Colors.orange)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Qty ", style: TextStyle(color: Colors.orange)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Price ", style: TextStyle(color: Colors.orange)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Phone ", style: TextStyle(color: Colors.orange)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Playing Date ",
                        style: TextStyle(color: Colors.orange)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Playing Time ",
                        style: TextStyle(color: Colors.orange)),
                  ]),
              SizedBox(
                width: 50,
              ),
              // ignore: prefer_const_literals_to_create_immutables
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(id),
                    SizedBox(
                      height: 5,
                    ),
                    Text(DateFormat('hh:mm')
                        .format(widget.data!.get("reservation").toDate())),
                    SizedBox(
                      height: 5,
                    ),
                    Text(widget.data!.get("userName")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(widget.data!.get("movieN")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(widget.data!.get("userEmail")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(widget.data!.get("qte").toString()),
                    SizedBox(
                      height: 5,
                    ),
                    Text(widget.data!.get("price").toString()),
                    SizedBox(
                      height: 5,
                    ),
                    Text(widget.data!.get("phone").toString()),
                    SizedBox(
                      height: 5,
                    ),
                    Text(DateFormat('yyyy-MM-dd')
                        .format(widget.data!.get("date").toDate())),
                    SizedBox(
                      height: 5,
                    ),
                    Text(widget.data!.get("time")),
                  ]),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ));
  }
}
