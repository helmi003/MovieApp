// ignore_for_file: avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethodsMovies {
  final CollectionReference movieCollection =
      FirebaseFirestore.instance.collection("movies");

  Future addMovie(
      String name,
      String language,
      String duration,
      DateTime date,
      String time,
      double price,
      double rating,
      String genre,
      String url,
      String description,
      String image) async {
    return await movieCollection.add({
      "name": name,
      "language": language,
      "duration": duration,
      "date": date,
      "time": time,
      "price": price,
      "rating": rating,
      "genre": genre,
      "url": url,
      "description": description,
      "image": image,
    });
  }

  // ignore: non_constant_identifier_names
  UpdateMovie(
      String id,
      String name,
      String language,
      String duration,
      DateTime date,
      String time,
      double price,
      double rating,
      String genre,
      String url,
      String description,
      String image) async {
    return await movieCollection.doc(id).update({
      "name": name,
      "language": language,
      "duration": duration,
      "date": date,
      "time": time,
      "price": price,
      "rating": rating,
      "genre": genre,
      "url": url,
      "description": description,
      "image": image,
    }).catchError((e) {
      print(e.toString());
    });
  }

  Future deleteMovie(String id) async {
    await movieCollection.doc(id).delete();
  }


  Future addReservation(
      DateTime reservation,
      String userName,
      String movieN,
      String userEmail,
      int qte,
      double price,
      int phone,
      DateTime date,
      String time) async {
    return await FirebaseFirestore.instance.collection("reservation").add({
      "reservation": reservation,
      "userName": userName,
      "movieN": movieN,
      "userEmail": userEmail,
      "qte": qte,
      "price": price,
      "phone": phone,
      "date": date,
      "time": time,
    });
  }
}
