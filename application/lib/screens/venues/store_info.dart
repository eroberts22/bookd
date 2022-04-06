import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';

// A page for modifying settings for a signed in user who is an artist
class venueSettings extends StatefulWidget {
  const venueSettings({Key? key}) : super(key: key);

  @override
  State<venueSettings> createState() => _venueSettingsState();
}

class _venueSettingsState extends State<venueSettings> {
  // Our custom authentication class to store auth data
  final AuthService _authService = AuthService();
  final _formKey =
      GlobalKey<FormState>(); //key to track state of form to validat

  FirebaseDatabase database = FirebaseDatabase.instance;

  String name = "";
  String description = "";
  String streetAddress = "";
  String city = "";
  String zipCode = "";
  String phoneNumber = "";
  // Different urls recieved through comma separated string
  String websiteLinks = "";
  Map<String, bool> tags = {
    "Bar": false,
    "Amphitheater": false,
    "Lounge": false,
    "Club": false,
    "Restaurant": false,
    "Outdoor": false,
    "Other": false
  };

  String error = "";

  @override
  Widget build(BuildContext context) {
    FirebaseDatabase database = FirebaseDatabase.instance;
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0.0,
            title: Text('Store Venue Info'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/account');
              },
            )),
        body: Container(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey, //key to track state of form to validate
                    child: Column(children: <Widget>[
                      Text("Enter the name of your venue"),
                      TextFormField(
                          validator: (val) => val!.isEmpty
                              ? 'Enter your venue name'
                              : null, //indicates if form is valid or not. Using !. so assuming value won't be null
                          onChanged: (val) {
                            // on user typing
                            setState(() => name = val);
                            print(name);
                          }),
                      SizedBox(height: 20.0),
                      SizedBox(height: 20.0),
                      Text("Enter a brief description of your venue"),
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
                      SizedBox(height: 20.0),
                      Text("Enter the street address of your venue"),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Enter street address' : null,
                        //indicates if form is valid or not. Using !. so assuming value won't be null
                        // val represents whatever was inserted
                        onChanged: (val) {
                          // on user typing update email value
                          setState(() => streetAddress = val);
                          print(streetAddress);
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text("Enter the city of your venue"),
                      TextFormField(
                        validator: (val) => val!.isEmpty ? 'Enter city' : null,
                        //indicates if form is valid or not. Using !. so assuming value won't be null
                        // val represents whatever was inserted
                        onChanged: (val) {
                          // on user typing update email value
                          setState(() => city = val);
                          print(city);
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text("Enter the zip code of your venue"),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Enter zip code' : null,
                        //indicates if form is valid or not. Using !. so assuming value won't be null
                        // val represents whatever was inserted
                        onChanged: (val) {
                          // on user typing update email value
                          setState(() => zipCode = val);
                          print(zipCode);
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text("Enter the phone number of your venue"),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Enter phone number' : null,
                        //indicates if form is valid or not. Using !. so assuming value won't be null
                        // val represents whatever was inserted
                        onChanged: (val) {
                          // on user typing update email value
                          setState(() => phoneNumber = val);
                          print(phoneNumber);
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text(
                          "Enter as many urls for your venue as desired separated by commas"),
                      TextFormField(
                          validator: (val) => val!.isEmpty
                              ? 'Enter venue urls'
                              : null, //indicates if form is valid or not. Using !. so assuming value won't be null
                          onChanged: (val) {
                            // on user typing update password value
                            setState(() => websiteLinks = val);
                            print(websiteLinks);
                          }),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        child: Text('Update Venue Info',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          // Connect to the database, and access the current user's uid to be used as primary key
                          print("Button Pressed, send info to database");
                          String? uid = _authService.userID;

                          // Check if the current user already has an artist profile

                          DatabaseReference venueRef =
                              database.ref("Venues/$uid");

                          DatabaseEvent artistEvent = await venueRef.once();

                          bool alreadyExists =
                              artistEvent.snapshot.value != null;
                          if (alreadyExists) {
                            // Update the existing fields
                            Map<String, Object> updateMap = {};
                            if (!name.isEmpty) {
                              updateMap["name"] = name;
                            }
                            if (!description.isEmpty) {
                              updateMap["description"] = description;
                            }
                            if (!streetAddress.isEmpty) {
                              updateMap["streetAddress"] = streetAddress;
                            }
                            if (!city.isEmpty) {
                              updateMap["city"] = city;
                            }
                            if (!zipCode.isEmpty) {
                              updateMap["zipCode"] = zipCode;
                            }
                            if (!phoneNumber.isEmpty) {
                              updateMap["phoneNumber"] = phoneNumber;
                            }
                            if (!websiteLinks.isEmpty) {
                              // Separate links by comma
                              updateMap["websiteLinks"] =
                                  websiteLinks.split(',');
                            }
                            print(venueRef);
                            print(updateMap);
                            if (updateMap.isNotEmpty) {
                              print("Writing map to database");
                              await venueRef.update(updateMap);
                            }
                          } else {
                            // Create the database reference
                            // ALL FIELDS MUST BE NON-EMPTY
                            Map<String, Object> updateMap = {};
                            if (!name.isEmpty) {
                              updateMap["name"] = name;
                            }
                            else {
                              // Raise error, require all fields to be non-null
                              error = "Empty Field: All fields required";
                            }
                            if (!description.isEmpty) {
                              updateMap["description"] = description;
                            }
                            else {
                              // Raise error, require all fields to be non-null
                              error = "Empty Field: All fields required";
                            }
                            if (!streetAddress.isEmpty) {
                              updateMap["streetAddress"] = streetAddress;
                            }
                            else {
                              // Raise error, require all fields to be non-null
                              error = "Empty Field: All fields required";
                            }
                            if (!city.isEmpty) {
                              updateMap["city"] = city;
                            }
                            else {
                              // Raise error, require all fields to be non-null
                              error = "Empty Field: All fields required";
                            }
                            if (!zipCode.isEmpty) {
                              updateMap["zipCode"] = zipCode;
                            }
                            else {
                              // Raise error, require all fields to be non-null
                              error = "Empty Field: All fields required";
                            }
                            if (!phoneNumber.isEmpty) {
                              updateMap["phoneNumber"] = phoneNumber;
                            }
                            else {
                              // Raise error, require all fields to be non-null
                              error = "Empty Field: All fields required";
                            }
                            if (!websiteLinks.isEmpty) {
                              // Separate links by comma
                              updateMap["websiteLinks"] =
                                  websiteLinks.split(',');
                            }
                            else {
                              // Raise error, require all fields to be non-null
                              error = "Empty Field: All fields required";
                            }
                            print(venueRef);
                            print(updateMap);
                            // Don't want to write if there is an error
                            if (updateMap.isNotEmpty && error == null) {
                              print("Writing map to database");
                              await venueRef.update(updateMap);
                            }
                          }

                          // Parse out info separated by commas in List fields
                        },
                      ),
                      SizedBox(height: 12.0), //text box for error
                      Text(
                        error, // output the error from signin
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ])))));
  }
}
