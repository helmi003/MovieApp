// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Admin Panel"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            // ignore: sized_box_for_whitespace
            Container(
              color: Colors.grey[800],
              height: 200,
              child: Center(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "MoviesAdmin");
                      },
                      child: Text('Movies',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold)))),
            ),
            SizedBox(
              height: 50,
            ),
            // ignore: sized_box_for_whitespace
            Container(
              color: Colors.grey[800],
              height: 200,
              child: Center(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, "ReservationAdmin");
                      },
                      child: Text('Reservation',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold)))),
            )
          ],
        ));
  }
}
