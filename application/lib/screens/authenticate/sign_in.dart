import 'package:application/services/auth.dart';
import 'package:application/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'register.dart';

class SignIn extends StatefulWidget {
  static const routeName = '/sign_in';
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Our custom authentication class to store auth data
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  //Store email and password local state
  String email = '';
  String password = '';
  String error = ''; // error is caught and printed to box

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: AppTheme.colors.primary),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0),
            child: Form(
                key: _formKey, //key to track state of form to validate
                child: Column(children: <Widget>[
                  Center(
                      child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Image.asset(
                              'assets/images/Book_transparent_logo.jpg'))),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (val) => val!.isEmpty
                          ? 'Enter an email'
                          : null, //indicates if form is valid or not. Using !. so assuming value won't be null
                      // val represents whatever was inserted
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? 'Enter a password 6 characters or longer'
                            : null, //indicates if form is valid or not. Using !. so assuming value won't be null
                        onChanged: (val) {
                          setState(() => password = val);
                        }),
                  ),

                  Container(
                    height: 70,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(top: 25, left: 20, right: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppTheme.colors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                      ),
                      child: const Text('Sign In',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        // Go log this person into firebase
                        if (_formKey.currentState!.validate()) {
                          // true if form is valid, false if otherwise. !NOTE!!!! Using a !. null safety operator, telling it this state can never be null. Might need to fix this to avoid bugs?
                          dynamic result =
                              await _authService.signInWithEmailAndPassword(
                                  email,
                                  password); //get "dynamic"(result can change its type) result
                          if (result == null) {
                            setState(() => error = 'Invalid email or password');
                          }

                          if (result != null) {
                            // if sign in is valid, show home screen
                            Navigator.of(context).pushReplacementNamed('/home');
                          }
                          // If result is not null, the listener stream<bookduser> in auth.dart will know a user has signed in and will update authentication state
                        }
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Forgot password screen
                    },
                    child: const Text(
                      'Forgot Password',
                    ),
                  ),

                  Row(
                    children: const <Widget>[
                      Expanded(child: Divider(color: Colors.grey)),
                      Text("OR"),
                      Expanded(child: Divider(color: Colors.grey)),
                    ],
                  ),
                  Container(
                    height: 70,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(top: 25, left: 20, right: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppTheme.colors.ternary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                      ),
                      child: const Text('Create New Bookd Account',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () =>
                          Navigator.of(context).pushNamed(Register.routeName),
                    ),
                  ),
                  const SizedBox(height: 12.0), //text box for error
                  Text(
                    error, // output the error from signin
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ]))));
  }
}
