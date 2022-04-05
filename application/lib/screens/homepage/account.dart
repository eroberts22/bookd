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
    // TODO: implement initState
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
        backgroundColor: Colors.brown[50],
        drawer: AppDrawer(),
        appBar: BookdAppBar(),
        body:  Center(child:
        Column(
          children: [
            TextButton.icon(
              icon: Icon(Icons.settings),
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
              label: Text('Profile Settings'),
              style: TextButton.styleFrom(
                primary: Colors.cyan,
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.calendar_month),
              onPressed: () async {
                Navigator.of(context).pushReplacementNamed('/calendar');
              },
              label: Text('Calendar'),
              style: TextButton.styleFrom(
                primary: Colors.cyan,
              ),
            )
          ],
        )));
  }
}
