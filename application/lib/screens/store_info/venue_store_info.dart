import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';

class VenueSettings extends StatefulWidget {
  const VenueSettings({ Key? key }) : super(key: key);

  @override
  State<VenueSettings> createState() => _VenueSettingsState();
}

class _VenueSettingsState extends State<VenueSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0.0,
            title: Text('Store Artist Info'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/account');
              },
            )),
      body: // remove line below and add venue account store info stuff here 
      Center(child: Column(children: [ Text('Venue Settings here', style: TextStyle(fontSize: 20),),], )));
  }
}
