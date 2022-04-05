import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/appdrawer.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final AuthService _auth = AuthService();
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
                Navigator.of(context).pushReplacementNamed('/artist-settings');
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
