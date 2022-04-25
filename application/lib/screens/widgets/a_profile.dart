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

  String _name = "";
  String _address = "";
  String _city = "";
  String _zipCode = "";
  String _description = "";
  List _tags = [];
  String _tagsList = "";

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
                  Text("Stage Name: " +
                      event.snapshot.child("stageName").value.toString()),
                  Text("Description: " +
                      event.snapshot.child("description").value.toString()),
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
