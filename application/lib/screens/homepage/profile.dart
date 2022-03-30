import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/appdrawer.dart';
import 'package:application/screens/widgets/searchbar.dart';


class Profile extends StatefulWidget {

  const Profile({ Key? key }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
   final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      resizeToAvoidBottomInset: false,
      drawer: AppDrawer(),
      appBar: BookdAppBar(),
      body: Center(child: 
      Column(children: [
        Text('Profile', style: TextStyle(fontSize: 20),),
      ],
    )));
  }
}