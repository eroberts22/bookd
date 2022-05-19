import 'package:application/theme/app_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';

import 'dart:convert';

// A page for modifying settings for a signed in user who is an artist
class VenueSettings extends StatefulWidget {
  const VenueSettings({Key? key}) : super(key: key);

  @override
  State<VenueSettings> createState() => _VenueSettingsState();
}

class _VenueSettingsState extends State<VenueSettings> {
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

  String error = "";

  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var zipcodeController = TextEditingController();
  var linksController = TextEditingController();

  Map<String, bool> tags = {
    "Bar": false,
    "Amphitheater": false,
    "Lounge": false,
    "Club": false,
    "Restaurant": false,
    "Outdoor": false,
    "Other": false
  };

  @override
  void initState() {
    super.initState();
    _setupTags();
    _fillInProfile();
  }

  // Retrieve the existing values for links and cities, and store them as comma separated
  void _fillInProfile() async {
    String? uid = _authService.userID;

    DatabaseEvent profileEvent = await database.ref("Venues/$uid").once();

    Map<String, dynamic>? profile =
        jsonDecode(jsonEncode(profileEvent.snapshot.value));
    if (profile != null) {
      List links = (profile["websiteLinks"] as List);
      String linksCsv = "";
      if (links.length > 0) {
        // Convert the list of strings to a single string, with values separated by commas
        linksCsv = links[0].toString();
        for (var i = 1; i < links.length; i++) {
          linksCsv = linksCsv + ", " + links[i].toString();
        }
      }

      String name = (profile["name"] as String);
      String description = (profile["description"] as String);
      String phoneNumber = (profile["phoneNumber"] as String);
      String streetAddress = (profile["streetAddress"] as String);
      String city = (profile["city"] as String);
      String zipCode = (profile["zipCode"] as String);

      print("Initializing");
      print(linksCsv);
      // Set the states
      setState(() => websiteLinks = linksCsv);
      print(websiteLinks);

      setState(() => nameController = TextEditingController(text: name));
      setState(() =>
          descriptionController = TextEditingController(text: description));
      setState(
          () => addressController = TextEditingController(text: streetAddress));
      setState(() => cityController = TextEditingController(text: city));
      setState(() => zipcodeController = TextEditingController(text: zipCode));
      setState(
          () => phoneController = TextEditingController(text: phoneNumber));
      setState(
          () => linksController = TextEditingController(text: websiteLinks));
      // Only do all this stuff if the profile is not null
    }
  }

  void _setupTags() async {
    String? uid = _authService.userID;

    DatabaseEvent tagEvent = await database.ref("Venues/$uid/tags").once();

    Map<String, dynamic>? existingTags =
        jsonDecode(jsonEncode(tagEvent.snapshot.value));

    print(existingTags);
    Map<String, bool> tempTags = {};

    // Tags are equal to the already existing values of tags for venue, otherwise default to all false
    if (existingTags != null) {
      // Go through all keys and values and set all null bools to false
      existingTags.forEach((key, value) {
        tempTags[key] = value;
      });
      // Ensures that tags are set from the start
      setState(() => tags = tempTags);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: AppTheme.colors.primary,
            elevation: 0.0,
            title: const Text('Profile Settings'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/account-venue');
              },
            )),
        body: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
                key: _formKey, //key to track state of form to validate
                child: Column(children: <Widget>[
                  //const Text("Enter the name of your venue"),
                  TextFormField(
                    controller: nameController,
                    validator: (val) => val!.isEmpty
                        ? 'Enter your venue name'
                        : null, //indicates if form is valid or not. Using !. so assuming value won't be null
                    onChanged: (val) {
                      // on user typing
                      setState(() => name = val);
                      print(name);
                    },
                    decoration: InputDecoration(
                      labelText: "Enter Venue Name",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.ternary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  //const Text("Enter a brief description of your venue"),
                  TextFormField(
                    controller: descriptionController,
                    validator: (val) =>
                        val!.isEmpty ? 'Enter a description' : null,
                    //indicates if form is valid or not. Using !. so assuming value won't be null
                    // val represents whatever was inserted
                    onChanged: (val) {
                      // on user typing update email value
                      setState(() => description = val);
                      print(description);
                    },
                    decoration: InputDecoration(
                      labelText: "Enter Brief Description",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.ternary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  //const Text("Enter the street address of your venue"),
                  TextFormField(
                    controller: addressController,
                    validator: (val) =>
                        val!.isEmpty ? 'Enter street address' : null,
                    //indicates if form is valid or not. Using !. so assuming value won't be null
                    // val represents whatever was inserted
                    onChanged: (val) {
                      // on user typing update email value
                      setState(() => streetAddress = val);
                      print(streetAddress);
                    },
                    decoration: InputDecoration(
                      labelText: "Enter Street Address",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.ternary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  //const Text("Enter the city of your venue"),
                  TextFormField(
                    controller: cityController,
                    validator: (val) => val!.isEmpty ? 'Enter city' : null,
                    //indicates if form is valid or not. Using !. so assuming value won't be null
                    // val represents whatever was inserted
                    onChanged: (val) {
                      // on user typing update email value
                      setState(() => city = val);
                      print(city);
                    },
                    decoration: InputDecoration(
                      labelText: "Enter City",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.ternary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  //const Text("Enter the zip code of your venue"),
                  TextFormField(
                    controller: zipcodeController,
                    validator: (val) => val!.isEmpty ? 'Enter zip code' : null,
                    //indicates if form is valid or not. Using !. so assuming value won't be null
                    // val represents whatever was inserted
                    onChanged: (val) {
                      // on user typing update email value
                      setState(() => zipCode = val);
                      print(zipCode);
                    },
                    decoration: InputDecoration(
                      labelText: "Enter Zip Code",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.ternary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  //const Text("Enter the phone number of your venue"),
                  TextFormField(
                    controller: phoneController,
                    validator: (val) =>
                        val!.isEmpty ? 'Enter phone number' : null,
                    //indicates if form is valid or not. Using !. so assuming value won't be null
                    // val represents whatever was inserted
                    onChanged: (val) {
                      // on user typing update email value
                      setState(() => phoneNumber = val);
                      print(phoneNumber);
                    },
                    decoration: InputDecoration(
                      labelText: "Enter Phone Number",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.ternary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // const Text(
                  //     "Enter as many urls for your venue as desired separated by commas"),
                  TextFormField(
                    controller: linksController,
                    validator: (val) => val!.isEmpty
                        ? 'Enter venue urls'
                        : null, //indicates if form is valid or not. Using !. so assuming value won't be null
                    onChanged: (val) {
                      // on user typing update password value
                      setState(() => websiteLinks = val);
                      print(websiteLinks);
                    },
                    decoration: InputDecoration(
                      labelText: "Enter Website Links, separated by commas",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.ternary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.colors.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Select Your Venue Type",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CheckboxListTile(
                    title: const Text("Bar"),
                    secondary: const Icon(Icons.local_bar),
                    value: tags["Bar"],
                    onChanged: (bool? value) {
                      setState(() {
                        // Set the tag to the value of the checkbox, and false if null
                        tags["Bar"] = value ?? false;
                        print(tags);
                      });
                    },
                    activeColor: AppTheme.colors.secondary,
                    checkColor: Colors.white,
                  ),
                  const SizedBox(height: 12.0),
                  CheckboxListTile(
                    title: const Text("Amphitheater"),
                    secondary: const Icon(Icons.stadium),
                    value: tags["Amphitheater"],
                    onChanged: (bool? value) {
                      setState(() {
                        // Set the tag to the value of the checkbox, and false if null
                        tags["Amphitheater"] = value ?? false;
                        print(tags);
                      });
                    },
                    activeColor: AppTheme.colors.secondary,
                    checkColor: Colors.white,
                  ),
                  const SizedBox(height: 12.0),
                  CheckboxListTile(
                    title: const Text("Lounge"),
                    secondary: const Icon(Icons.weekend),
                    value: tags["Lounge"],
                    onChanged: (bool? value) {
                      setState(() {
                        // Set the tag to the value of the checkbox, and false if null
                        tags["Lounge"] = value ?? false;
                        print(tags);
                      });
                    },
                    activeColor: AppTheme.colors.secondary,
                    checkColor: Colors.white,
                  ),
                  const SizedBox(height: 12.0),
                  CheckboxListTile(
                    title: const Text("Club"),
                    secondary: const Icon(Icons.nightlife),
                    value: tags["Club"],
                    onChanged: (bool? value) {
                      setState(() {
                        // Set the tag to the value of the checkbox, and false if null
                        tags["Club"] = value ?? false;
                        print(tags);
                      });
                    },
                    activeColor: AppTheme.colors.secondary,
                    checkColor: Colors.white,
                  ),
                  const SizedBox(height: 12.0),
                  CheckboxListTile(
                    title: const Text("Restaurant"),
                    secondary: const Icon(Icons.restaurant),
                    value: tags["Restaurant"],
                    onChanged: (bool? value) {
                      setState(() {
                        // Set the tag to the value of the checkbox, and false if null
                        tags["Restaurant"] = value ?? false;
                        print(tags);
                      });
                    },
                    activeColor: AppTheme.colors.secondary,
                    checkColor: Colors.white,
                  ),
                  const SizedBox(height: 12.0),
                  CheckboxListTile(
                    title: const Text("Outdoor"),
                    secondary: const Icon(Icons.deck),
                    value: tags["Outdoor"],
                    onChanged: (bool? value) {
                      setState(() {
                        // Set the tag to the value of the checkbox, and false if null
                        tags["Outdoor"] = value ?? false;
                        print(tags);
                      });
                    },
                    activeColor: AppTheme.colors.secondary,
                    checkColor: Colors.white,
                  ),
                  const SizedBox(height: 12.0),
                  CheckboxListTile(
                    title: const Text("Other"),
                    secondary: const Icon(Icons.info),
                    value: tags["Other"],
                    onChanged: (bool? value) {
                      setState(() {
                        // Set the tag to the value of the checkbox, and false if null
                        tags["Other"] = value ?? false;
                        print(tags);
                      });
                    },
                    activeColor: AppTheme.colors.secondary,
                    checkColor: Colors.white,
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(2),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppTheme.colors.primary),
                      fixedSize: MaterialStateProperty.all(const Size(300, 50)),
                    ),
                    child: const Text('Update Profile Settings',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      // Connect to the database, and access the current user's uid to be used as primary key
                      print("Button Pressed, send info to database");
                      String? uid = _authService.userID;

                      error = "";
                      // Check if the current user already has an artist profile

                      DatabaseReference venueRef = database.ref("Venues/$uid");

                      DatabaseEvent artistEvent = await venueRef.once();

                      bool alreadyExists = artistEvent.snapshot.value != null;
                      if (alreadyExists) {
                        // Update the existing fields
                        Map<String, Object> updateMap = {};

                        // Store current tags state
                        updateMap["tags"] = tags;

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
                          updateMap["websiteLinks"] = websiteLinks.split(',');
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

                        // Set tags
                        updateMap["tags"] = tags;

                        if (!name.isEmpty) {
                          updateMap["name"] = name;
                        } else {
                          // Raise error, require all fields to be non-null
                          error = "Empty Field: All fields required";
                        }
                        if (!description.isEmpty) {
                          updateMap["description"] = description;
                        } else {
                          // Raise error, require all fields to be non-null
                          error = "Empty Field: All fields required";
                        }
                        if (!streetAddress.isEmpty) {
                          updateMap["streetAddress"] = streetAddress;
                        } else {
                          // Raise error, require all fields to be non-null
                          error = "Empty Field: All fields required";
                        }
                        if (!city.isEmpty) {
                          updateMap["city"] = city;
                        } else {
                          // Raise error, require all fields to be non-null
                          error = "Empty Field: All fields required";
                        }
                        if (!zipCode.isEmpty) {
                          updateMap["zipCode"] = zipCode;
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
                          updateMap["websiteLinks"] = websiteLinks.split(',');
                        } else {
                          // Raise error, require all fields to be non-null
                          error = "Empty Field: All fields required";
                        }
                        print(venueRef);
                        print(updateMap);
                        // Don't want to write if there is an error
                        if (updateMap.isNotEmpty && error == "") {
                          print("Writing map to database");
                          await venueRef.update(updateMap);
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
                ]))));
  }
}
