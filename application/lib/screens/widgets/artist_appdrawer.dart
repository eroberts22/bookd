import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';


class ABookdAppDrawer extends StatefulWidget {
  const ABookdAppDrawer({ Key? key }) : super(key: key);

  @override
  State<ABookdAppDrawer> createState() => _ABookdAppDrawerState();
}

class _ABookdAppDrawerState extends State<ABookdAppDrawer> {

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
   return Drawer(
        backgroundColor: Colors.white, // nav background
        child: ListView(
          children: [
            // close menu icon
            ListTile(
              leading: const Icon(
                Icons.close,
                color: Colors.cyan,
                size: 50.0,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Explore
            ListTile(
              title: const Text(
                'Explore',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/explore');
              },
            ),
            // Profile
            ListTile(
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              onTap: () {
               Navigator.of(context).pushReplacementNamed('/profile');

              },
            ),
            // Account
            ListTile(
              title: const Text(
                'Account',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              onTap: () {
                // load page specific to account type: artist and venue
                if (profileType == "artist") {
                  Navigator.of(context).pushReplacementNamed('/account-artist');
                }
                else if (profileType == "venue") {
                  Navigator.of(context).pushReplacementNamed('/account-venue');
                } else {
                  // error handle?
                }
              },
            ),
            // logout icon
            /*
            TextButton.icon(
              icon: Icon(Icons.person),
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pushReplacementNamed('/authenticate');
              },
              label: Text('logout'),
              style: TextButton.styleFrom(
                primary: Colors.cyan,
              ),
            )*/
          ],
        ),
    );
  }
}