import 'package:flutter/material.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/artist_appdrawer.dart';
import 'package:application/screens/widgets/a_profile.dart';
import 'package:application/screens/widgets/venue_appdrawer.dart';

class RequestProfileArtist extends StatefulWidget {

  const RequestProfileArtist({ Key? key }) : super(key: key);

  @override
  State<RequestProfileArtist> createState() => _RequestProfileArtistState();
}

class _RequestProfileArtistState extends State<RequestProfileArtist> {
  @override
  Widget build(BuildContext context) {
    final arguements = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      drawer: arguements["profileType"] == "venue" ? const VBookdAppDrawer() : const ABookdAppDrawer(), //need to return venue drawer if it is a venue viewing artist profile
      appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0.0,
            //title: const Text(),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/incoming-requests');
              },
            ),),
        body: ArtistProfileWidget(arguements["uid"]),
      );
  }
}