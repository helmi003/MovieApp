// ignore_for_file: prefer_const_constructors, file_names, unnecessary_this

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/MovieDataBase.dart';

class Reservation extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Reservation(
      {required this.name,
      required this.price,
      required this.date,
      required this.time,
      required this.genre,
      required this.rating,
      required this.language,
      required this.duration,
      required this.image});
  final String name;
  final double price;
  final DateTime date;
  final String time;
  final String genre;
  final String rating;
  final String language;
  final String duration;
  final String image;

  @override
  _ReservationState createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  late String name = widget.name;
  late double price = widget.price;
  late DateTime date = widget.date;
  late String time = widget.time;
  late String genre = widget.genre;
  late String rating = widget.rating;
  late String language = widget.language;
  late String duration = widget.duration;
  late String image = widget.image;

  late int qte2 = 0;

  TextEditingController phone = TextEditingController();
  late TextEditingController qte;

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

  @override
  void initState() {
    super.initState();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Reservation"),
          centerTitle: true,
          leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          elevation: 6,
        ),
        body: !isloggedin
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      children: [
                        Container(
                          height: 200,
                          width: 130,
                          child: Image.network(image),
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
                              Text(name, style: const TextStyle(fontSize: 25)),
                              const SizedBox(height: 20),
                              Container(
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(genre,
                                        style: const TextStyle(fontSize: 25))),
                                decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Text(rating,
                                          style: const TextStyle(fontSize: 15)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.orange[400],
                                      ),
                                    ],
                                  )),
                              const SizedBox(height: 5),
                              Text(language,
                                  style: const TextStyle(fontSize: 15)),
                              const SizedBox(height: 5),
                              Text(duration,
                                  style: const TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: phone,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    maxLength: 8,
                    validator: (String? value) {
                      if (value!.isEmpty) return 'Enter your phone number';
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.shopping_bag),
                        hintText: "Enter your phone number",
                        labelText: "Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: qte = TextEditingController(text: qte2.toString()),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (String? value) {
                      if (value!.isEmpty)
                        // ignore: curly_braces_in_flow_control_structures
                        return 'Enter how many place you wanna reserve';
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.shopping_bag),
                        hintText: "Enter Quantity",
                        labelText: "Quantity",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  SizedBox(height: 20),
                  Text("Total: " +
                      qte2.toString() +
                      "*" +
                      price.toString() +
                      "= € " +
                      (qte2 * price).toString()),
                      SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        qte2=int.parse(qte.text);
                      });
                      DatabaseMethodsMovies().addReservation(
                          DateTime.now(),
                          user.displayName.toString(),
                          name,
                          user.email.toString(),
                          qte2,
                          price,
                          int.parse(phone.text),
                          date,
                          time).whenComplete(() => showSnackBar("Reservation added", Duration(seconds: 2)));
                    },
                    child: const Text('Reserve',
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
              ));
  }
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
