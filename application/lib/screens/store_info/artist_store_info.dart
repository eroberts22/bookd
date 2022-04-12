import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';

// A page for modifying settings for a signed in user who is an artist
class artistSettings extends StatefulWidget {
  const artistSettings({Key? key}) : super(key: key);

  @override
  State<artistSettings> createState() => _artistSettingsState();
}

class _artistSettingsState extends State<artistSettings> {
  // Our custom authentication class to store auth data
  final AuthService _authService = AuthService();
  final _formKey =
      GlobalKey<FormState>(); //key to track state of form to validat

  FirebaseDatabase database = FirebaseDatabase.instance;

  String description = "";
  String websiteLinks = "";
  // Different cities recieved through comma separated string
  String potentialCities = "";
  String stageName = "";
  String phoneNumber = "";

  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0.0,
            title: const Text('Profile Settings'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/account');
              },
            )),
        body: Container(
            child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey, //key to track state of form to validate
                    child: Column(children: <Widget>[
                      const SizedBox(height: 20.0),
                      const Text("Enter a brief description of yourself"),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a description' : null,
                        //indicates if form is valid or not. Using !. so assuming value won't be null
                        // val represents whatever was inserted
                        onChanged: (val) {
                          // on user typing update email value
                          setState(() => description = val);
                          print(description);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Text("Enter your desired stage name"),
                      TextFormField(
                          validator: (val) => val!.isEmpty
                              ? 'Enter your stage name'
                              : null, //indicates if form is valid or not. Using !. so assuming value won't be null
                          onChanged: (val) {
                            // on user typing
                            setState(() => stageName = val);
                            print(stageName);
                          }),
                      const SizedBox(height: 20.0),
                      const Text(
                          "Enter as many personal urls as desired separated by commas"),
                      TextFormField(
                          validator: (val) => val!.isEmpty
                              ? 'Enter personal urls'
                              : null, //indicates if form is valid or not. Using !. so assuming value won't be null
                          onChanged: (val) {
                            // on user typing update password value
                            setState(() => websiteLinks = val);
                            print(websiteLinks);
                          }),
                      const SizedBox(height: 20.0),
                      const Text(
                          "Enter all cities you willing to play in separated by commas"),
                      TextFormField(
                          validator: (val) => val!.isEmpty
                              ? 'Enter potential cities'
                              : null, //indicates if form is valid or not. Using !. so assuming value won't be null
                          onChanged: (val) {
                            // on user typing update password value
                            setState(() => potentialCities = val);
                            print(potentialCities);
                          }),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        child: const Text('Update Artist Info',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          // Connect to the database, and access the current user's uid to be used as primary key
                          print("Button Pressed, send info to database");
                          String? uid = _authService.userID;

                          //Reset error to be empty
                          error = "";

                          // Check if the current user already has an artist profile

                          DatabaseReference artistRef =
                              database.ref("Artists/$uid");

                          DatabaseEvent artistEvent = await artistRef.once();

                          bool alreadyExists =
                              artistEvent.snapshot.value != null;
                          if (alreadyExists) {
                            // Update the existing fields
                            Map<String, Object> updateMap = {};
                            if (!description.isEmpty) {
                              updateMap["description"] = description;
                            }
                            if (!stageName.isEmpty) {
                              updateMap["stageName"] = stageName;
                            }
                            if (!websiteLinks.isEmpty) {
                              // Separate links by comma
                              updateMap["websiteLinks"] =
                                  websiteLinks.split(',');
                            }
                            if (!potentialCities.isEmpty) {
                              // Separate cities by comma
                              updateMap["potentialCities"] =
                                  potentialCities.split(',');
                            }
                            print(artistRef);
                            print(updateMap);
                            if (updateMap.isNotEmpty) {
                              print("Writing map to database");
                              await artistRef.update(updateMap);
                            }
                          } else {
                            // Create the database reference
                            // ALL FIELDS MUST BE NON-EMPTY
                            Map<String, Object> updateMap = {};
                            if (!description.isEmpty) {
                              updateMap["description"] = description;
                            } else {
                              // Raise error, require all fields to be non-null
                              error = "Empty Field: All fields required";
                            }
                            if (!stageName.isEmpty) {
                              updateMap["stageName"] = stageName;
                            } else {
                              // Raise error, require all fields to be non-null
                              error = "Empty Field: All fields required";
                            }
                            if (!websiteLinks.isEmpty) {
                              // Separate links by comma
                              updateMap["websiteLinks"] =
                                  websiteLinks.split(',');
                            } else {
                              // Raise error, require all fields to be non-null
                              error = "Empty Field: All fields required";
                            }
                            if (!potentialCities.isEmpty) {
                              // Separate cities by comma
                              updateMap["potentialCities"] =
                                  potentialCities.split(',');
                            } else {
                              // Raise error, require all fields to be non-null
                              error = "Empty Field: All fields required";
                            }
                            print(artistRef);
                            print(updateMap);
                            print(error);
                            // Don't want to write if there is an error
                            if (updateMap.isNotEmpty && error == "") {
                              print("Writing map to database");
                              await artistRef.update(updateMap);
                            }
                          }

                          // Parse out info separated by commas in List fields
                        },
                      ),
                      const SizedBox(height: 12.0), //text box for error
                      Text(
                        error, // output the error from signin
                        style: const TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ])))));
  }
}
