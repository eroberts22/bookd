import 'package:application/screens/authenticate/landing_page.dart';
import 'package:application/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Register extends StatefulWidget {
  static const routeName = '/register';
  const Register({Key? key}) : super(key: key);

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
  bool isArtistSelected = false;
  bool isVenueSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: AppTheme.colors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () =>
                  Navigator.of(context).pushNamed(LandingPage.routeName),
            )),
        body: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(vertical: 60.0, horizontal: 40.0),
            child: Form(
                key: _formKey, //key to track state of form to validate
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Select your Account',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Artist button definition
                          Material(
                            color: isArtistSelected
                                ? AppTheme.colors.primary
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(28),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              splashColor: Colors.black26,
                              onTap: () {
                                setState(() {
                                  isArtistSelected = true;
                                  isVenueSelected = false;
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                        'assets/images/artist_profile.jpg'),
                                    height: 100,
                                    width: 130,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Artist',
                                    style: TextStyle(
                                        fontSize: 26, color: Colors.white),
                                  ),
                                  const SizedBox(height: 6),
                                ],
                              ),
                            ),
                          ),
                          // Venue button definition
                          Material(
                            color: isVenueSelected
                                ? AppTheme.colors.primary
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(28),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              splashColor: Colors.black26,
                              onTap: () {
                                setState(() {
                                  isArtistSelected = false;
                                  isVenueSelected = true;
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                        'assets/images/venue_profile.jpg'),
                                    height: 100,
                                    width: 130,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Venue',
                                    style: TextStyle(
                                        fontSize: 26, color: Colors.white),
                                  ),
                                  const SizedBox(height: 6),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
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
                      const SizedBox(height: 20.0),
                      TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
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
                      const SizedBox(height: 20.0),
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
                            child: const Text('Register',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String profile;
                                if (isArtistSelected || isVenueSelected) {
                                  if (isArtistSelected && !isVenueSelected) {
                                    profile = "artist";
                                  } else if (!isArtistSelected &&
                                      isVenueSelected) {
                                    profile = "venue";
                                  } else {
                                    profile = "";
                                  }
                                  dynamic result = await _authService
                                      .registerWithEmailAndPassword(email,
                                          password); //get "dynamic"(result can change its type) result
                                  if (result == null) {
                                    setState(() =>
                                        error = 'Please supply a valid email');
                                  } else {
                                    String? uid = result.uid;
                                    // Store the new user in the database!
                                    String uEmail = result.email;
                                    Map<String, String?> userMap = {
                                      "email": uEmail,
                                      "profileType": profile
                                    };

                                    // A new user has just been created!
                                    DatabaseReference artistRef =
                                        database.ref("Users/$uid");

                                    await artistRef.set(userMap);
                                    print(
                                        "Created user $uid in database with email $uEmail and profile $profile");
                                    // if register is valid, show home page
                                    if (result != null) {
                                      // if sign in is valid, show home screen
                                      Navigator.of(context)
                                          .pushReplacementNamed('/home');
                                    }
                                    // If result is not null, the listener stream<bookduser> in auth.dart will know a user has signed in and will update authentication state
                                  }
                                } else {
                                  setState(() => error =
                                      'please supply a valid profile type');
                                }
                              }
                            }),
                      ),

                      const SizedBox(height: 12.0), //text box for error
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ]))));
  }
}
