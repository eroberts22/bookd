import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Our custom authentication class to store auth data
  final AuthService _authService = AuthService();

  //Store email and password local state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0.0,
            title: Text('Sign up for Bookd')),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
                child: Column(children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                // val represents whatever was inserted
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  }),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: Text('Register', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  // Go log this person into firebase
                  print(email);
                  print(password);
                },
              )
            ]))));
  }
}
