import 'package:application/screens/homepage/account_artist.dart';
import 'package:application/screens/homepage/account_venue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:application/screens/homepage/explore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/services/auth.dart';

class Home extends StatefulWidget {
  const Home({ Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;
  
  var profileType; // added so we can navigate to appropriate user account
  bool artistLogged = true; // used to specify which user account is logged in

  void setVen() {
    setState(()=> artistLogged = !artistLogged);
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
    DatabaseEvent profileTypeEv = await profileTypeRef.once();
    profileType = profileTypeEv.snapshot.value;
    
    if (profileType == 'venue') {
      setVen();
    }
  }
  
  @override
  Widget build(BuildContext context) {

    if (artistLogged) {
      return const Explore();
    } else if (!artistLogged){
      return const AccountVenue();
    } else {
      return const Explore();
    }
  }
}