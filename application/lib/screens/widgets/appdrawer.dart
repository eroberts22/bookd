import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);

  // Our class to handle authentication
  final AuthService _auth = AuthService();

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
                Navigator.of(context).pushReplacementNamed('/home');
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
                Navigator.of(context).pushReplacementNamed('/account');

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