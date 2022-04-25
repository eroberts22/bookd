import 'package:application/screens/widgets/calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:convert';

class ArtistProfileWidget extends StatefulWidget {
  const ArtistProfileWidget({Key? key}) : super(key: key);

  @override
  State<ArtistProfileWidget> createState() => _ArtistProfileWidgetState();
}

class _ArtistProfileWidgetState extends State<ArtistProfileWidget> {
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
    String? uid = _authService.userID;
    final ref = FirebaseDatabase.instance.ref();
    event = await ref.child('Artists/$uid').once();

    print(event.snapshot.children);
    for (var c in event.snapshot.children) {
      print(c.key);
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
                  child: event.snapshot.child("stageName").value != null ?
                  Text(event.snapshot.child("stageName").value.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30),)
                  :const Text("Please Enter All Profile\nInformation in Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                ),
                Padding(padding: const EdgeInsets.only(top: 10, left: 30, right: 30 ),
                  child: event.snapshot.child("description").value != null ?
                    Text(event.snapshot.child("description").value.toString())
                    :Container(),
                ),
                ]),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    )));
  }
}
