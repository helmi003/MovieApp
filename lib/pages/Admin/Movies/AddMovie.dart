// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_final_fields, curly_braces_in_flow_control_structures, unnecessary_this, unnecessary_new, duplicate_ignore, file_names
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tp6/pages/Admin/MoviesAdmin.dart';
import '../../../data/MovieDataBase.dart';

// ignore: use_key_in_widget_constructors
class AddMovie extends StatefulWidget {
  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  TextEditingController language = new TextEditingController();
  TextEditingController duration = new TextEditingController();
  TextEditingController time = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController rating = new TextEditingController();
  TextEditingController genre = new TextEditingController();
  TextEditingController url = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController image = new TextEditingController();
  late DateTime _dateTime = DateTime.now();

  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;
  late String movieID = '';

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

  Future uploadImage(File _image, String movieID) async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('movies/$movieID')
        .child("post_$imgId");

    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();

    await firebaseFirestore
        .collection("movies")
        .doc(movieID)
        .update({'image': downloadURL}).whenComplete(
            () => showSnackBar("Movie Uploaded", Duration(seconds: 2)));
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Movie"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MovieAdmin()));
            },
          ),
          elevation: 6,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(10),
            children: <Widget>[
              TextFormField(
                controller: name,
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
                controller: language,
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
                controller: duration,
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
              ElevatedButton(
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
                controller: time,
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
                controller: price,
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
                controller: rating,
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
                controller: genre,
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
                controller: url,
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
                controller: description,
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
                  SizedBox(
                    height: 250,
                    width: 120,
                    child: GestureDetector(
                        onTap: () {
                          imagePickerMethod();
                        },
                        child: _image == null
                            ? Image.network(
                                "https://firebasestorage.googleapis.com/v0/b/tp6f-49f03.appspot.com/o/movies%2Fmovie.jpg?alt=media&token=ce50f482-86b1-4e52-8188-7b9653cad019")
                            : Image.file(_image!)),
                  ),
                ],
              ),
              buttons(),
              SizedBox(height: 20),
            ],
          ),
        ));
  }

  buttons() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (_image == null) {
            showSnackBar("Select image first", Duration(seconds: 2));
          } else {
            DatabaseMethodsMovies()
                .addMovie(
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
                    _image.toString())
                .then((value) => {
                      setState(() {
                        movieID = value.id.toString();
                      }),
                      showSnackBar("Please wait a second", Duration(seconds: 2))
                    })
                .whenComplete(() => uploadImage(_image!, movieID));

            _formKey.currentState?.reset();
          }
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