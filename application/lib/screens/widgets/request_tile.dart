import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/services/auth.dart';

class RequestTile extends StatefulWidget {
  final String uid;
  const RequestTile(this.uid, {Key? key}) : super(key: key);
  @override
  RequestTileState createState() => RequestTileState();
}

class RequestTileState extends State<RequestTile> {
  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;
  String artistName = "";
  bool beenAcceptedOrRejected = false; // bool goes to true when request has been accepted or rejected.
  @override
  void initState() {
    super.initState();
    _getArtistEvent();
  }

  Future _getArtistEvent() async{ //get database event for thisArtist so we can access its values
    DatabaseReference artistRef = database.ref().child("Artists/${widget.uid}");
    DatabaseEvent thisArtist = await artistRef.once();
    //setState(() {
      artistName = thisArtist.snapshot.child("stageName").value.toString();
    //});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FutureBuilder(
        future: _getArtistEvent(), 
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
              TextButton(
                onPressed: () async { // *** on pressed: approves the artist
                  //final database structure:
                  //Venues
                    //venueid
                      //bookings
                        //bookedartistid : bookingDate
                  //Artists
                    //bookedArtistId
                      //bookings
                        //bookdVenueid : bookingDate
                  if(!beenAcceptedOrRejected){//add booking request to list of accepted bookings if it has not yet been accepted
                    //add booking to venue list of bookings and remove it from requests
                    DatabaseReference acceptedRequestRef = database.ref().child("Venues/${_authService.userID}/bookingRequests/${widget.uid}");
                    DatabaseEvent acceptedRequest = await acceptedRequestRef.once();
                    database.ref().child("Venues/${_authService.userID}/bookings").update({acceptedRequest.snapshot.key!: acceptedRequest.snapshot.value});
                    acceptedRequestRef.remove(); //delete the accepted request from bookingRequests now that its been accepted

                    //add booking to artist list of bookings
                    database.ref().child("Artists/${widget.uid}/bookings").update({_authService.userID!: acceptedRequest.snapshot.value});
                    beenAcceptedOrRejected = true;

                    //remove the available date from the venue calendar
                    DatabaseReference availableDatesRef = database.ref().child("Venues/${_authService.userID}/availableDates");
                    DatabaseEvent unavailableDate = await availableDatesRef.orderByValue().equalTo(acceptedRequest.snapshot.value.toString()).once();
                    for(var child in unavailableDate.snapshot.children){ //delete the available date 
                      database.ref().child("Venues/${_authService.userID}/availableDates/" + child.key!).remove();
                  }
                  }
                },
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {// *** on pressed: rejects the artist
                  if(!beenAcceptedOrRejected){
                    DatabaseReference rejectedRequestRef = database.ref().child("Venues/${_authService.userID}/bookingRequests/${widget.uid}");
                    rejectedRequestRef.remove(); //delete the accepted request from bookingRequests since its rejected
                    beenAcceptedOrRejected = true;
                  }
                }, 
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              )
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
                child: Text(artistName),
              ),
              TextButton(
                onPressed: () {// *** on pressed: shows the artist's profile (current user is a venue)
                  Navigator.of(context).pushReplacementNamed('/request-view-profile', arguments: {"uid": widget.uid, "profileType": "venue"});
                }, 
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
          ));
          } else {
            return Container();
          }
        })
    );
  }
}
