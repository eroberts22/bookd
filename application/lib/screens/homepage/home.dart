import 'package:application/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  // Our class to handle authentication
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Bookd'),
          backgroundColor: Colors.green[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
                icon: Icon(Icons.person),
                onPressed: () async {
                  await _auth.signOut();
                },
                label: Text('logout'))
          ],
        ));
  }
}
