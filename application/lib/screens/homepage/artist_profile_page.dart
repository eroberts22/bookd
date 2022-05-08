import 'package:flutter/material.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/artist_appdrawer.dart';
import 'package:application/screens/widgets/a_profile.dart';
import 'package:application/screens/widgets/venue_appdrawer.dart';

class ProfileArtist extends StatefulWidget {

  const ProfileArtist({ Key? key }) : super(key: key);

  @override
  State<ProfileArtist> createState() => _ProfileArtistState();
}

class _ProfileArtistState extends State<ProfileArtist> {
  @override
  Widget build(BuildContext context) {
    final arguements = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      drawer: arguements["profileType"] == "venue" ? const VBookdAppDrawer() : const ABookdAppDrawer(), //need to return venue drawer if it is a venue viewing artist profile
      appBar: BookdAppBar(),
      body: ArtistProfileWidget(arguements["uid"]),
      );
  }
}