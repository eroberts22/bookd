import 'package:application/screens/homepage/account_venue.dart';
import 'package:flutter/material.dart';
import 'package:application/screens/homepage/explore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/services/auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;

  late DatabaseEvent event;
  bool artistLogged = false; // used to specify which user account is logged in
  bool venueLogged = false;

   void setArt() {
    artistLogged = true;
    venueLogged = false;
  }

  void setVen() {
    venueLogged = true;
    artistLogged = false;
  }

  @override
  void initState() {
    super.initState();
    _getDatabaseProfileType(); // get profile type
  }

  // use a bool to see which ui should load for account type
  // (may rework this, not sure how robust this is)
  Future _getDatabaseProfileType() async {
    String? uid = _authService.userID;
    DatabaseReference profileTypeRef = database.ref("Users/$uid/profileType");
    DatabaseEvent event = await profileTypeRef.once();
    var profileType = event.snapshot.value;

    if (profileType == 'artist') {
      setArt();
    }

    if (profileType == 'venue') {
      setVen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDatabaseProfileType(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          
          if (artistLogged && !venueLogged) {
            return const Explore();
          } if (venueLogged && !artistLogged) {
            return const AccountVenue();
          } else {
            return Container();
          }
        } else {
          return Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: const Center (child: CircularProgressIndicator(),)
          );
        }
      },
    );
  }
}
