import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/appdrawer.dart';
import 'package:firebase_database/firebase_database.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
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
        drawer: AppDrawer(),
        appBar: const BookdAppBar(),
        body: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // profile settings
            TextButton.icon(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                // load page specific to account type: artist and venue
                if (profileType == "artist") {
                  Navigator.of(context).pushReplacementNamed('/artist-settings');
                }
                else if (profileType == "venue") {
                  Navigator.of(context).pushReplacementNamed('/venue-settings');
                } else {
                  //
                }
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
