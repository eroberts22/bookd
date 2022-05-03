// public profile widget

import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/models/venue.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';

class VenueProfileWidget extends StatefulWidget {
  // //make it so the uid is set by passing it into this widget. access uid by using "widget.uid"
  final String uid;
  const VenueProfileWidget(this.uid);
  //const VenueProfileWidget({Key? key}) : super(key: key);
  @override
  State<VenueProfileWidget> createState() => _VenueProfileWidgetState();
}

class _VenueProfileWidgetState extends State<VenueProfileWidget> {
  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;
  File? _photo;
  String? img;
  String? venueType;

  late DatabaseEvent event;

  @override
  void initState() {
    super.initState();
    _getProfileInfo();
  }

  Future _getProfileInfo() async {
    // String? uid = _authService
    //     .userID; //TODO: uid here should be passed in from explore page card (see contructor)
    String uid = widget.uid;
    final ref = FirebaseDatabase.instance.ref();
    event = await ref.child('Venues/$uid').once();

    print(event.snapshot.children);
    for (var c in event.snapshot.children) {
      print(c.key);
    }

    print(event.snapshot.child("tags").children);
    for (var c in event.snapshot.child("tags").children) {
      //print(c.value);
      if (c.value.toString() == "true") {
        print(c.key);
        venueType = c.key;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: FutureBuilder(
          future: _getProfileInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Column(children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.orangeAccent,
                  child: _photo != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _photo!,
                            //"gs://bookd-4bdd3.appspot.com/Images/$img",
                            width: 100,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:20, bottom: 10),
                  child: event.snapshot.child("name").value != null ?
                  Text(event.snapshot.child("name").value.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30),)
                  :const Text("Please Enter All Profile\nInformation in Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(),
                  child: venueType != null ?
                    Text(venueType!,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5) ),)
                    : Text(""),
                ),
                Padding(padding: const EdgeInsets.only(top: 10, left: 30, right: 30 ),
                  child: event.snapshot.child("description").value != null ?
                    Text(event.snapshot.child("description").value.toString())
                    :Container(),
                ),
                SizedBox(
                  width: double.infinity,
                  child: event.snapshot.child("streetAddress").value != null && event.snapshot.child("city").value != null && event.snapshot.child("zipCode").value != null ?
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
                    child: Text(
                    event.snapshot.child("streetAddress").value.toString() 
                    + " " + event.snapshot.child("city").value.toString() 
                    + " " +event.snapshot.child("zipCode").value.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5) ),),
                  ):Container(),
                ),
                SizedBox(
                  width: double.infinity,
                  child: event.snapshot.child("phoneNumber").value != null ?
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                    child: Text(
                    event.snapshot.child("phoneNumber").value.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5) ),),
                  ):Container(),
                ),
                SizedBox(
                  width: 400,
                  height: 400,
                  child: BookdCalendar(widget.uid),
                ),
              ]));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    )));
  }
}
