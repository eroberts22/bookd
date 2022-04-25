// public profile widget

import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/models/venue.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';

class VenueProfileWidget extends StatefulWidget {
  // //make it so the uid is set by passing it into this widget. access uid by using "widget.uid"
  // final String uid;
  // const VenueProfileWidget(this.uid);
  const VenueProfileWidget({Key? key}) : super(key: key);
  @override
  State<VenueProfileWidget> createState() => _VenueProfileWidgetState();
}

class _VenueProfileWidgetState extends State<VenueProfileWidget> {
  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;
  File? _photo;

  late DatabaseEvent event;

  @override
  void initState() {
    super.initState();
    _getProfileInfo();
  }

  Future _getProfileInfo() async {
    String? uid = _authService
        .userID; //TODO: uid here should be passed in from explore page card (see contructor)
    final ref = FirebaseDatabase.instance.ref();
    event = await ref.child('Venues/$uid').once();

    print(event.snapshot.children);
    for (var c in event.snapshot.children) {
      print(c.key);
    }

    List<String> imgList = [];
    for (var item in jsonDecode(jsonEncode(event.snapshot.value))["images"]) {
      imgList.add(item);
    }
    print(imgList);
    
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
                Text(event.snapshot.child("name").value.toString()),
                Text(event.snapshot.child("description").value.toString()),
                Text(event.snapshot.child("streetAddress").value.toString()),
                Text(event.snapshot.child("city").value.toString()),
                Text(event.snapshot.child("zipCode").value.toString()),
                SizedBox(
                  width: 400,
                  height: 400,
                  child: BookdCalendar(_authService.userID!),
                ),
              ]));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    )));
  }
}
