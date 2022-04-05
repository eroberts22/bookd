import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService =
      AuthService(); // Our custom authentication class to store auth data. instance created from auth.dart class
  final _formKey =
      GlobalKey<FormState>(); //key to track state of form to validate

  FirebaseDatabase database = FirebaseDatabase.instance;

  //Store email and password local state
  String email = '';
  String password = '';
  String error = ''; // error is caught and printed to box

  String profileType = '0';

  List<bool> _selections = List.generate(3, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0.0,
            centerTitle: true,
            title: const Text('BOOKD'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                widget.toggleView();
              },
            )),
        body: Container(
            child: SingleChildScrollView(
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
                          // on user typing update email value
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
                            // on user typing update password value
                            setState(() => password = val);
                          }),
                      SizedBox(height: 20.0),
                      TextFormField(
                          decoration: const InputDecoration(
                            labelText: '0 For Artist, 1 For Venue',
                          ),
                          validator: (val) {
                            if (val == "0" || val == "1") {
                              return null;
                            } else {
                              return "Invalid Entry. Enter 0 for Artist, 1 for Venue";
                            }
                          }, //indicates if form is valid or not. Using !. so assuming value won't be null
                          onChanged: (val) {
                            // on user typing update password value
                            setState(() => profileType = val);
                          }),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            fixedSize:
                                MaterialStateProperty.all(const Size(300, 30)),
                          ),
                          child: Text('Register',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // true if form is valid, false if otherwise. !NOTE!!!! Using a !. null safety operator, telling it this state can never be null. Might need to fix this to avoid bugs?
                              // Need to check if the profile type is valid
                              if (profileType == "0" || profileType == "1") {
                                String profile = "";
                                if (profileType == "0") {
                                  profile = "artist";
                                } else {
                                  profile = "venue";
                                }
                                dynamic result = await _authService
                                    .registerWithEmailAndPassword(email,
                                        password); //get "dynamic"(result can change its type) result
                                if (result == null) {
                                  setState(() =>
                                      error = 'please supply a valid email');
                                } else {
                                  String? uid = result.uid;
                                  // Store the new user in the database!
                                  String u_email = result.email;
                                  Map<String, String?> user_map = {
                                    "email": u_email,
                                    "profileType": profile
                                  };

                                  // A new user has just been created!
                                  DatabaseReference artistRef =
                                      database.ref("Users/$uid");

                                  await artistRef.set(user_map);
                                  print(
                                      "Created user $uid in database with email $u_email and profile $profile");
                                  // if register is valid, show home page
                                  if(result != null) { // if sign in is valid, show home screen
                                    Navigator.of(context).pushReplacementNamed('/home');
                                  }
                                  // If result is not null, the listener stream<bookduser> in auth.dart will know a user has signed in and will update authentication state
                                }
                              }
                              else{
                                setState(() =>
                                      error = 'please supply a valid profile type');
                              }
                            }
                            
                          }),
                      SizedBox(height: 12.0), //text box for error
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ])))));
  }
}
