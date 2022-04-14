import 'package:application/models/users.dart';
import 'package:application/screens/authenticate/sign_in.dart';
import 'package:application/screens/homepage/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Accessing the user data from the provider through the stream
    final input_user = Provider.of<BookdUser?>(context);
    print("hello $input_user");

    // If the user value is null, that means the user is not signed on
    if (input_user == null) {
      return SignIn();
    } else {
      // Otherwise, we want to give them the home screen
      return Home();
    }
  }
}
