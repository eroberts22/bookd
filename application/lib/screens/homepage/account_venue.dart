import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/venue_appdrawer.dart';
import 'package:firebase_database/firebase_database.dart';

class AccountVenue extends StatefulWidget {
  const AccountVenue({Key? key}) : super(key: key);

  @override
  State<AccountVenue> createState() => _AccountVenueState();
}

class _AccountVenueState extends State<AccountVenue> {
  final AuthService _auth = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;
  var profileType;

  @override void initState() {
    super.initState();
    _getDatabaseProfileType();
  }

  void _getDatabaseProfileType() async {
    String? uid = _auth.userID;
    DatabaseReference profileTypeRef = database.ref("Users/$uid/profileType");
    DatabaseEvent profileTypeEv = await profileTypeRef.once();
    profileType = profileTypeEv.snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: const VBookdAppDrawer(),
        appBar: const BookdAppBar(),
        body: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // bookings
            TextButton.icon(
              icon: const Icon(Icons.mail),
              onPressed: () async {
                Navigator.of(context).pushReplacementNamed('/incoming-requests');
              },
              label: const Text(
                'Incoming Requests',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),
            // profile settings
            TextButton.icon(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                Navigator.of(context).pushReplacementNamed('/venue-settings');
              },
              label: const Text(
                'Profile Settings',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),
            // Upload Images
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () async {
                Navigator.of(context).pushReplacementNamed('/upload-image');
              },
              label: const Text(
                'Upload Image',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),
            // calendar
            TextButton.icon(
              icon: const Icon(Icons.calendar_month),
              onPressed: () async {
                Navigator.of(context).pushReplacementNamed('/calendar');
              },
              label: const Text(
                'Calendar',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),
            // logout
            TextButton.icon(
              icon: const Icon(Icons.person),
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pushReplacementNamed('/authenticate');
              },
              label: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
                ),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            )
          ],
        ),
        );
  }
}
