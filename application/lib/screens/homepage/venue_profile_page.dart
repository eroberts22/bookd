import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/venue_appdrawer.dart';
import 'package:application/screens/widgets/v_profile.dart';

class ProfileVenue extends StatefulWidget {

  const ProfileVenue({ Key? key }) : super(key: key);

  @override
  State<ProfileVenue> createState() => _ProfileVenueState();
}

class _ProfileVenueState extends State<ProfileVenue> {
   final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      drawer: const VBookdAppDrawer(),
      appBar: const BookdAppBar(),
      body: const VenueProfileWidget(),
    );
  }
}