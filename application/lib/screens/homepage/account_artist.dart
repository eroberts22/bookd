import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/artist_appdrawer.dart';
import 'package:firebase_database/firebase_database.dart';

class AccountArtist extends StatefulWidget {
  const AccountArtist({Key? key}) : super(key: key);

  @override
  State<AccountArtist> createState() => _AccountArtistState();
}

class _AccountArtistState extends State<AccountArtist> {
  final AuthService _auth = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;

  String error_str = "";

  @override
  Widget build(BuildContext context) {
    String? uid = _auth.userID;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const ABookdAppDrawer(),
      appBar: const BookdAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // bookings
          TextButton.icon(
            icon: const Icon(Icons.book),
            onPressed: () async {
              Navigator.of(context).pushReplacementNamed('/booking');
            },
            label: const Text(
              'Bookings',
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
              Navigator.of(context).pushReplacementNamed('/artist-settings');
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
              // Check to see if an artist account has been stored yet
              // If not, then we update error string and do not switch to the upload image page
              DatabaseEvent artistEvent =
                  await database.ref("Artists/$uid").once();
              if (artistEvent.snapshot.value != null) {
                // Settings exist, so we can upload images
                Navigator.of(context).pushReplacementNamed('/upload-image');
              } else {
                // No settings exist!
                setState(() => error_str =
                    "Error! Cannot upload images before storing profile settings");
              }
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
          ),
          Text(
            error_str,
            style: const TextStyle(color: Colors.red, fontSize: 14.0),
          )
        ],
      ),
    );
  }
}
