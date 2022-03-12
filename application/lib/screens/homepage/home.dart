import 'package:application/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  // Our class to handle authentication
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50], // app background
      drawer: Drawer(
        backgroundColor: Colors.brown[50], // nav background
        child: ListView(
          children: [
            // close menu icon
            ListTile(
              leading: Icon(
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
                Navigator.pop(context);
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
                Navigator.pop(context);
              },
            ),
            // logout icon
            TextButton.icon(
              icon: Icon(Icons.person),
              onPressed: () async {
                await _auth.signOut();
              },
              label: Text('logout'),
              style: TextButton.styleFrom(
                primary: Colors.cyan,
              ),
            )
          ],
        ),
      ),

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Bookd', 
          style: TextStyle(
            fontSize: 40),
          ),
        backgroundColor: Color.fromARGB(0, 0, 0, 0), // transparent background
        foregroundColor: Colors.cyan,
        elevation: 0.0,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu),
            iconSize: 50.0,
            padding: EdgeInsets.symmetric(horizontal: 10)
          ),
        ),
      ),
    );
  }
}
