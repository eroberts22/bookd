import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';


class VBookdAppDrawer extends StatefulWidget {
  const VBookdAppDrawer({ Key? key }) : super(key: key);

  @override
  State<VBookdAppDrawer> createState() => _VBookdAppDrawerState();
}

class _VBookdAppDrawerState extends State<VBookdAppDrawer> {

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
                color: Color.fromRGBO(52, 84, 148, 1),
                size: 50.0,
              ),
              onTap: () {
                Navigator.pop(context);
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
                //navigate to venue profile page and pass in the current user profile type and the current user id
               Navigator.of(context).pushReplacementNamed('/profile-venue', arguments: {"uid": _auth.userID.toString(), "profileType": "venue"});

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
                 Navigator.of(context).pushReplacementNamed('/account-venue');
              },
            ),
            ListTile(
              title: const Text(
                'Messaging',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              onTap: () {
                  Navigator.of(context).pushReplacementNamed('/messaging');
              },
            ),
          ],
        ),
    );
  }
}