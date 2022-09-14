// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_final_fields, curly_braces_in_flow_control_structures, unnecessary_this, unnecessary_new, duplicate_ignore, file_names, use_key_in_widget_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tp6/data/MovieDataBase.dart';

// ignore: use_key_in_widget_constructors
class ModifyMovie extends StatefulWidget {
  const ModifyMovie({this.data, required this.id});
  final QueryDocumentSnapshot<Object?>? data;
  final String id;
  @override
  _ModifyMovieState createState() => _ModifyMovieState();
}

class _ModifyMovieState extends State<ModifyMovie> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController name;
  late TextEditingController language;
  late TextEditingController duration;
  late TextEditingController time;
  late TextEditingController price;
  late TextEditingController rating;
  late TextEditingController genre;
  late TextEditingController url;
  late TextEditingController description;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isloggedin = false;
  late final String id = widget.id;
  late final String name2 = widget.data!.get("name");
  late final String language2 = widget.data!.get("language");
  late final String duration2 = widget.data!.get("duration");
  late final String time2 = widget.data!.get("time");
  late final double price2 = widget.data!.get("price");
  late final double rating2 = widget.data!.get("rating");
  late final String genre2 = widget.data!.get("genre");
  late final String url2 = widget.data!.get("url");
  late final String description2 = widget.data!.get("description");
  late DateTime _dateTime = widget.data!.get("date").toDate();
  late String image = widget.data!.get("image");

  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("There is no Image selected", Duration(milliseconds: 400));
      }
    });
  }

  Future uploadImage(File _image, String id) async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference =
        FirebaseStorage.instance.ref().child('movies/').child("post_$imgId");

    if (_image == null) {
      downloadURL = image;
    } else {
      await reference.putFile(_image);
      downloadURL = await reference.getDownloadURL();
    }

    await firebaseFirestore
        .collection("movies")
        .doc(id)
        .update({'image': downloadURL}).whenComplete(
            () => showSnackBar("Movie Modified", Duration(seconds: 2)));
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
  // ignore: duplicate_ignore
  void initState() {
    super.initState();
    // ignore: unnecessary_this
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Modify Movie"),
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
            : Form(
                key: _formKey,
                child: ListView(padding: EdgeInsets.all(10), children: <Widget>[
                  SizedBox(height: 10),
                  TextFormField(
                    controller: name = TextEditingController(text: name2),
                    validator: (String? value) {
                      if (value!.isEmpty)
                        return 'Enter movie name';
                      else if (value.length < 3)
                        return "it's too short";
                      else if (value.length > 50) return "it's too long";
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Movie Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: language =
                        TextEditingController(text: language2),
                    validator: (String? value) {
                      if (value!.isEmpty)
                        return 'Enter movie language';
                      else if (value.length < 3)
                        return "it's too short";
                      else if (value.length > 50) return "it's too long";
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Language",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: duration =
                        TextEditingController(text: duration2),
                    validator: (String? value) {
                      if (value!.isEmpty)
                        return 'Enter movie duration';
                      else if (value.length < 3)
                        return "it's too short";
                      else if (value.length > 50) return "it's too long";
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Duration",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  SizedBox(height: 10),
                  RaisedButton(
                    child: Text('Pick a date'),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: _dateTime,
                              firstDate: DateTime(2009),
                              lastDate: DateTime.now())
                          .then((date) {
                        setState(() {
                          _dateTime = date!;
                        });
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: time = TextEditingController(text: time2),
                    validator: (String? value) {
                      if (value!.isEmpty)
                        return 'Enter movie time';
                      else if (value.length < 3)
                        return "it's too short";
                      else if (value.length > 50) return "it's too long";
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Time",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: price =
                        TextEditingController(text: "$price2"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (String? value) {
                      if (value!.isEmpty) return 'Enter Product price';
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.shopping_bag),
                        hintText: "Enter product price",
                        labelText: "Price",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: rating =
                        TextEditingController(text: "$rating2"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (String? value) {
                      if (value!.isEmpty) return 'Enter Movie rating';
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.shopping_bag),
                        hintText: "Enter Movie rating",
                        labelText: "Rating",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: genre =
                        TextEditingController(text: genre2),
                    validator: (String? value) {
                      if (value!.isEmpty)
                        return 'Enter movie genre';
                      else if (value.length < 3)
                        return "it's too short";
                      else if (value.length > 50) return "it's too long";
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Genre",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: url = TextEditingController(text: url2),
                    validator: (String? value) {
                      if (value!.isEmpty)
                        return 'Enter movie url';
                      else if (value.length < 3)
                        return "it's too short";
                      else if (value.length > 50) return "it's too long";
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "URL",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: description =
                        TextEditingController(text: description2),
                    minLines: 4,
                    maxLines: 4,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Enter movie description';
                      } else if (value.length < 10) {
                        return "it's too short";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: 250,
                        width: 120,
                        child: GestureDetector(
                            onTap: () {
                              imagePickerMethod();
                            },
                            child: _image == null
                                ? Image.network(image)
                                : Image.file(_image!)),
                      ),
                    ],
                  ),
                  buttons()
                ])));
  }

  buttons() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          DatabaseMethodsMovies()
              .UpdateMovie(
                  id,
                  name.text,
                  language.text,
                  duration.text,
                  _dateTime,
                  time.text,
                  double.parse(price.text),
                  double.parse(rating.text),
                  genre.text,
                  url.text,
                  description.text,
                  image)
              .then((value) =>
                  {showSnackBar("Please wait a second", Duration(seconds: 2))})
              .whenComplete(() {
            if (_image == null) {
              showSnackBar("Movie modified successfuly", Duration(seconds: 2));
            } else {
              uploadImage(_image!, id);
            }
          });
        }
      },
      child: const Text('Save',
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
    );
  }
}
