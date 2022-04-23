import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/services/auth.dart';

class RequestTile extends StatefulWidget {
  final String uid;
  RequestTile(this.uid);
  @override
  RequestTileState createState() => RequestTileState();
}

class RequestTileState extends State<RequestTile> {

  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;
  String artistName = "";
  @override
  void initState() {
    super.initState();
    _getArtistEvent();
  }

  void _getArtistEvent() async{ //get database event for thisArtist so we can access its values
    DatabaseReference artistRef = database.ref().child("Artists/${widget.uid}");
    DatabaseEvent thisArtist = await artistRef.once();
    setState(() {
      artistName = thisArtist.snapshot.child("stageName").value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {}, // *** on pressed: shows the artist's profile
                child: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
                child: Text(artistName),
              ),
              Container(
                  child: Row(
                children: [
                  TextButton(
                    onPressed: () {}, // *** on pressed: approves the artist
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {}, // *** on pressed: rejects the artist
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  )
                ],
              )),
            ],
          )),
    );
  }
}
