// public profile widget

import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/calendar.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/models/venue.dart';

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

  @override
  void initState() {
    super.initState();
    _getProfileInfo();
  }

  void _getProfileInfo() async {
    String? uid = _authService.userID;
    
    DatabaseReference databaseRef = database.ref(); //get the reference
    DatabaseEvent name = await databaseRef.child("Venues/$uid/name").once(); 
    DatabaseEvent address = await databaseRef.child("Venues/$uid/streetAddress").once(); 
    DatabaseEvent city = await databaseRef.child("Venues/$uid/city").once();
    DatabaseEvent zipCode = await databaseRef.child("Venues/$uid/zipCode").once(); 
    DatabaseEvent description = await databaseRef.child("Venues/$uid/description").once(); 
    DatabaseEvent tags = await databaseRef.child("Venues/$uid/tags").once();
    _name = name.snapshot.value.toString();
    _address = address.snapshot.value.toString();
    _city = city.snapshot.value.toString();
    _zipCode = zipCode.snapshot.value.toString();
    _description = description.snapshot.value.toString();

    List<dynamic> allTags = [];
    for (var tag in tags.snapshot.children) {
      allTags.add(tag.value);
    }

    setState(() {
      _tags = allTags;
      _tagsList = _tags.join("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
      padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
        child: Column(
          children: [
            Text(_name),
            Text(_description),
            Text(_address),
            Text(_city),
            Text(_zipCode),
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
            )
          ],
          )
      )
    );
  }
}
