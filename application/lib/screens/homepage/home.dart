import 'package:application/services/auth.dart';
import 'package:flutter/material.dart';

// Home Page ///////////////////////////////////////////////////////////
class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  // Our class to handle authentication
  //final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown[50], // app background
      // drawer menu
      drawer: AppDrawer(),
      // appBar
      appBar: BaseAppBar(),
      // body
      body: SearchBar()
    );
  }
}
//\Home Page ///////////////////////////////////////////////////////////

// Profile Page ////////////////////////////////////////////////////////
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown[50], // app background
      // drawer menu
      drawer: AppDrawer(),
      // appBar
      appBar: BaseAppBar(),
      // body
      body: Text('profile')
    );
  }
}
//\Profile Page ////////////////////////////////////////////////////////

// Account Page ////////////////////////////////////////////////////////
class AccountPage extends StatelessWidget {
  const AccountPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown[50], // app background
      // drawer menu
      drawer: AppDrawer(),
      // appBar
      appBar: BaseAppBar(),
      // body
      body: Text('account')
    );
  }
}
//\Account Page ////////////////////////////////////////////////////////

// AppBar //////////////////////////////////////////////////////////////
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget{
  const BaseAppBar({ Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) { 
    return AppBar(
        centerTitle: true,
        title: Text(
          'Bookd',
          style: TextStyle(fontSize: 40),
        ),
        backgroundColor: Color.fromARGB(0, 0, 0, 0), // transparent background
        foregroundColor: Colors.cyan,
        elevation: 0.0,
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu),
              iconSize: 50.0,
              padding: EdgeInsets.symmetric(horizontal: 10)),
        ),
    );
  }
  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);

}
//\AppBar //////////////////////////////////////////////////////////////

// AppDrawer ///////////////////////////////////////////////////////////
class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);

  // Our class to handle authentication
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Home()
                    )
                );
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => AccountPage()
                    )
                );
              },
            ),
            // logout icon
            TextButton.icon(
              icon: Icon(Icons.person),
              onPressed: () async {
                await _auth.signOut(); // need error box for error from this function
              },
              label: Text('logout'),
              style: TextButton.styleFrom(
                primary: Colors.cyan,
              ),
            )
          ],
        ),
      ),
    );
  }
}
//\AppDrawer ///////////////////////////////////////////////////////////

// Search Bar ///////////////////////////////////////////////////////////
class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                // *** placeholder search bar, may need to be changed
                // to interface with firebase ***
                child: Row(children: [
                  // search icon
                  Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.cyan,
                  ),
                  // Text field
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for Venues',
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//\Search Bar ///////////////////////////////////////////////////////////
