// public profile widget

import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/models/venue.dart';
/*
class VenueProfileWidget extends StatelessWidget {
  VenueProfileWidget({ Key? key }) : super(key: key);
  final AuthService _auth = AuthService();
 

  @override
  Widget build(BuildContext context) {
    //Venue ven = _auth.getCurrentVenue() as Venue;
    //final venue = Venue.fromSnapshot(document);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: _auth.getCurrentUser(),
            builder: (context,snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                return Text("${snapshot.data.toString()}");
              } else {
                return CircularProgressIndicator();
              }
            },
       )
       
        ],)
    );
  }
}*/


class VenueProfileWidget extends StatefulWidget {
  const VenueProfileWidget({ Key? key }) : super(key: key);

  @override
  State<VenueProfileWidget> createState() => _VenueProfileWidgetState();
}

class _VenueProfileWidgetState extends State<VenueProfileWidget> {

  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance; 

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
    event = await ref.child('Venues/$uid').once();
    
    print(event.snapshot.children);
    for (var c in event.snapshot.children) {
      print(c.key);
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView (child: 
      Padding(
      padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
        child: FutureBuilder(
              future: _getProfileInfo(),
              builder: (context,snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column( children: [
                    Text(event.snapshot.child("name").value.toString()),
                    Text(event.snapshot.child("description").value.toString()),
                    Text(event.snapshot.child("streetAddress").value.toString()),
                    Text(event.snapshot.child("city").value.toString()),
                    Text(event.snapshot.child("zipCode").value.toString()),
                    SizedBox(width: 400,height: 350, child: BookdCalendar(),),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered))
                              return Colors.blue.withOpacity(0.04);
                            if (states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed))
                              return Colors.orangeAccent.withOpacity(0.9);
                            return null; // Defer to the widget's default.
                          },
                        ),
                      ),
                      onPressed: () { },
                      child: const Text('Book a Day')
                    ),
                  ]);
                  } else {
                    return Center(child: CircularProgressIndicator(),)
                    ;
                  }
                }),
          )
        )
    );
  }
}
