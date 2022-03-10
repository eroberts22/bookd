import 'package:application/screens/authenticate/authenticate.dart';
import 'package:application/screens/homepage/home.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Return either authenticate or home widget, depending on if you are signed in or not
    return Authenticate();
  }
}
