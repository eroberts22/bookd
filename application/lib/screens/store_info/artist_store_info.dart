import 'dart:convert';

import 'package:application/theme/app_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';

// A page for modifying settings for a signed in user who is an artist
class ArtistSettings extends StatefulWidget {
  const ArtistSettings({Key? key}) : super(key: key);

  @override
  State<ArtistSettings> createState() => _ArtistSettingsState();
}

class _ArtistSettingsState extends State<ArtistSettings> {
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

  var citiesController = TextEditingController();
  var linksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupLinksAndCities();
  }

  // Retrieve the existing values for links and cities, and store them as comma separated
  void _setupLinksAndCities() async {
    String? uid = _authService.userID;

    DatabaseEvent profileEvent = await database.ref("Artists/$uid").once();

    Map<String, dynamic>? profile =
        jsonDecode(jsonEncode(profileEvent.snapshot.value));
    if (profile != null) {
      List cities = (profile["potentialCities"] as List);
      String citiesCsv = "";
      if (cities.length > 0) {
        // Convert the list of strings to a single string, with values separated by commas
        citiesCsv = cities[0].toString();
        for (var i = 1; i < cities.length; i++) {
          citiesCsv = citiesCsv + ", " + cities[i].toString();
        }
      }

      List links = (profile["websiteLinks"] as List);
      String linksCsv = "";
      if (links.length > 0) {
        // Convert the list of strings to a single string, with values separated by commas
        linksCsv = links[0].toString();
        for (var i = 1; i < links.length; i++) {
          linksCsv = linksCsv + ", " + links[i].toString();
        }
      }
      print("Initializing");
      print(citiesCsv);
      print(linksCsv);
      // Set the states
      setState(() => websiteLinks = linksCsv);
      setState(() => potentialCities = citiesCsv);
      print(websiteLinks);
      print(potentialCities);

      setState(() =>
          citiesController = TextEditingController(text: potentialCities));
      setState(
          () => linksController = TextEditingController(text: websiteLinks));

      // Only do all this stuff if the profile is not null
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Building");
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: AppTheme.colors.primary,
            elevation: 0.0,
            title: const Text('Profile Settings'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/account-artist');
              },
            )),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                vertical: 20.0, horizontal: 50.0),
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
                  const Text("Enter your phone number"),
                  TextFormField(
                      validator: (val) => val!.isEmpty
                          ? 'Enter your phone number'
                          : null, //indicates if form is valid or not. Using !. so assuming value won't be null
                      onChanged: (val) {
                        // on user typing
                        setState(() => phoneNumber = val);
                        print(phoneNumber);
                      }),
                  const SizedBox(height: 20.0),
                  const Text(
                      "Enter as many personal urls as desired separated by commas"),
                  TextFormField(
                      controller: linksController,
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
                      controller: citiesController,
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
                        if (!phoneNumber.isEmpty) {
                          updateMap["phoneNumber"] = phoneNumber;
                        }
                        if (!websiteLinks.isEmpty) {
                          // Separate links by comma
                          updateMap["websiteLinks"] =
                              websiteLinks.split(',');
                        } else {
                          // websiteLinks is empty, which can potentially be a change
                          updateMap["websiteLinks"] = [];
                        }
                        if (!potentialCities.isEmpty) {
                          // Separate cities by comma
                          updateMap["potentialCities"] =
                              potentialCities.split(',');
                        } else {
                          updateMap["potentialCities"] = [];
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
                        if (!phoneNumber.isEmpty) {
                          updateMap["phoneNumber"] = phoneNumber;
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
                    style:
                        const TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ]))));
  }
}
