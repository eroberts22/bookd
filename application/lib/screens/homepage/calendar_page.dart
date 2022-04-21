import 'package:application/screens/widgets/calendar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/services/auth.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({ Key? key }) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;
  var profileType; // added so we can navigate to appropriate user account

  @override
  void initState() {
    super.initState();
    
    _getDatabaseProfileType(); // get profile type
  }

  void _getDatabaseProfileType() async {
    String? uid = _authService.userID;
    DatabaseReference profileTypeRef = database.ref("Users/$uid/profileType");
    DatabaseEvent profileTypeEv = await profileTypeRef.once();
    profileType = profileTypeEv.snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0.0,
            title: const Text('Calendar'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // load page specific to account type: artist and venue
                if (profileType == "artist") {
                  Navigator.of(context).pushReplacementNamed('/account-artist');
                }
                else if (profileType == "venue") {
                  Navigator.of(context).pushReplacementNamed('/account-venue');
                } else {
                  // error handle?
                }              },
            )),
            body: BookdCalendar(),
    );
  }
}