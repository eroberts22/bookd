import 'package:application/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:application/screens/authenticate/register.dart';
// added for testing home page
import 'package:application/screens/homepage/home.dart';
import 'package:application/screens/artists/store_info.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView(){
    setState(() => showSignIn = !showSignIn );
  }
  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
