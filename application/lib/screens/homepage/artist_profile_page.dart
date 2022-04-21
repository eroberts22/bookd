import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/artist_appdrawer.dart';
import 'package:application/screens/widgets/searchbar.dart';


class ProfileArtist extends StatefulWidget {

  const ProfileArtist({ Key? key }) : super(key: key);

  @override
  State<ProfileArtist> createState() => _ProfileArtistState();
}

class _ProfileArtistState extends State<ProfileArtist> {
   final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      drawer: ABookdAppDrawer(),
      appBar: const BookdAppBar(),
      body: 
      Column(
        children: const [
        Text('artist profile', style: TextStyle(fontSize: 30),),
      ],
    ));
  }
}