import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BookingTile extends StatefulWidget {
  final String uid;

  const BookingTile(this.uid, {Key? key}) : super(key: key);

  @override
  State<BookingTile> createState() => _BookingTileState();
}

class _BookingTileState extends State<BookingTile> {

  FirebaseDatabase database = FirebaseDatabase.instance;
  String venueName = "";

  @override
  void initState() {
    super.initState();
    _getVenueEvent();
  }

  void _getVenueEvent() async{ //get database event for thisArtist so we can access its values
    DatabaseReference venueref = database.ref().child("Venues/${widget.uid}");
    DatabaseEvent thisVenue = await venueref.once();
    setState(() {
      venueName = thisVenue.snapshot.child("name").value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
 return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 6.0, 10.0, 0.0),
                child: const Text("Venue Name"),
              ),
              TextButton(
                onPressed: () {}, // *** on pressed: shows the venue's profile
                child: Row(children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 6.0, 10.0, 0.0),
                    child: Text("View",
                      style: TextStyle(
                        color: Colors.orangeAccent,
                      ),),
                  ),
                  Icon(
                    Icons.person,
                    color: Colors.orangeAccent,)
                ],),
                ),
            ],
          )),
    );
  }
}