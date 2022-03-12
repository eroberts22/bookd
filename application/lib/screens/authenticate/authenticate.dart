import 'package:application/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:application/screens/authenticate/register.dart';
// added for testing home page
import 'package:application/screens/homepage/home.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //child: Home(), // testing home page
      child: Register(),
    );
  }
}
