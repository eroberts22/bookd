import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/venue_appdrawer.dart';
import 'package:application/screens/widgets/artist_appdrawer.dart';
import 'package:application/screens/widgets/v_profile.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileVenue extends StatefulWidget {

  const ProfileVenue({ Key? key }) : super(key: key);
  //final String uid;
  //const ProfileVenue(this.uid);
  
  @override
  State<ProfileVenue> createState() => _ProfileVenueState();
}

class _ProfileVenueState extends State<ProfileVenue> {
  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;
  // ignore: prefer_typing_uninitialized_variables
  var profileType;
  @override
  void initState() {
    super.initState();
    
    _getDatabaseProfileType(); // get profile type
  }
  void _getDatabaseProfileType() async {
    String? uid = _authService.userID; //on this page uid will always be the current user's id
    DatabaseReference profileTypeRef = database.ref("Users/$uid/profileType");
    DatabaseEvent profileTypeEv = await profileTypeRef.once();
    profileType = profileTypeEv.snapshot.value;
  }
  @override
  Widget build(BuildContext context) {
    final arguements = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      drawer: arguements["profileType"] == "venue" ? const VBookdAppDrawer() : const ABookdAppDrawer(), //depending on profile type, return correct appdrawer
      appBar: const BookdAppBar(),
      body: VenueProfileWidget(arguements["uid"]),
    );
  }
}