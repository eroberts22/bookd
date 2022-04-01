import 'package:application/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({Key? key, required this.toggleView}) : super(key: key);

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
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          elevation: 0.0,
          centerTitle: true,
          title: const Text ('BOOKD'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
                key: _formKey, //key to track state of form to validate
                child: Column(children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: const InputDecoration(
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
                  SizedBox(height: 20.0),
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      validator: (val) => val!.length < 6
                          ? 'Enter a password 6 characters or longer'
                          : null, //indicates if form is valid or not. Using !. so assuming value won't be null
                      onChanged: (val) {
                        setState(() => password = val);
                      }),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.cyan),
                      fixedSize: MaterialStateProperty.all(const Size(300, 30)),
                    ),
                    child:
                        Text('Sign In', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      // Go log this person into firebase
                      if (_formKey.currentState!.validate()) {
                        // true if form is valid, false if otherwise. !NOTE!!!! Using a !. null safety operator, telling it this state can never be null. Might need to fix this to avoid bugs?
                        dynamic result =
                            await _authService.signInWithEmailAndPassword(email,
                                password); //get "dynamic"(result can change its type) result
                        if (result == null) {
                          setState(() => error = 'Invalid email or password');
                        }

                        if(result != null) { // if sign in is valid, show home screen
                        Navigator.of(context).pushReplacementNamed('/home');
                        }
                        // If result is not null, the listener stream<bookduser> in auth.dart will know a user has signed in and will update authentication state
                      }
                    },
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
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueGrey),
                      fixedSize: MaterialStateProperty.all(const Size(300, 30)),
                    ),
                    child: const Text('Create new Bookd account',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      widget.toggleView();
                    },
                  ),
                  const SizedBox(height: 12.0), //text box for error
                  Text(
                    error, // output the error from signin
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ]))));
  }
}
