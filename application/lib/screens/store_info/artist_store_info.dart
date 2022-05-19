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
  FirebaseDatabase database = FirebaseDatabase.instance;

  final _formKey =
      GlobalKey<FormState>(); //key to track state of form to validat
  var phoneNumberController = TextEditingController();
  var stageNameController = TextEditingController();
  var descriptionController = TextEditingController();
  var citiesController = TextEditingController();
  var linksController = TextEditingController();

  String description = "";
  String websiteLinks = "";
  String potentialCities = "";
  String stageName = "";
  String phoneNumber = "";
  String error = ""; // Error output

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

      String stageN = (profile["stageName"] as String);
      String stageNameCsv = stageN.toString();

      print("Initializing");
      print(citiesCsv);
      print(linksCsv);
      // Set the states
      setState(() => websiteLinks = linksCsv);
      setState(() => potentialCities = citiesCsv);
      setState(() => stageName = stageNameCsv);
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
          //padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              fillInInformation(),
              const SizedBox(height: 20.0),
              form(),
              const SizedBox(height: 20.0),
              updateInfo()
            ],
          ),
        ));
  }

  Widget fillInInformation() {
    return Column(
      children: [
        Row(
          children: const [
            SizedBox(
              width: 20,
            ),
            Text(
              'Information',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(children: [
        stageNameInput(),
        const SizedBox(height: 20.0),
        descriptionOfYourselfInput(),
        const SizedBox(height: 20.0),
        linksInput(),
        const SizedBox(height: 20.0),
        citiesInput(),
        const SizedBox(height: 20.0),
        phoneNumberInput(),
        const SizedBox(height: 20.0),
      ]),
    );
  }

  Widget descriptionOfYourselfInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: descriptionController,
        decoration: InputDecoration(
          labelText: 'Your Description',
          labelStyle: const TextStyle(
            fontSize: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: const TextStyle(
          fontSize: 18,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a description';
          }
          return null;
        },
        keyboardType: TextInputType.text,
        onChanged: (value) {
          setState(() => description = value);
        },
      ),
    );
  }

  Widget stageNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: stageNameController,
        decoration: InputDecoration(
          labelText: 'Stage Name',
          labelStyle: const TextStyle(
            fontSize: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: const TextStyle(
          fontSize: 18,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your stage name';
          }
          return null;
        },
        keyboardType: TextInputType.text,
        onChanged: (value) {
          setState(() => stageName = value);
        },
      ),
    );
  }

  Widget linksInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: linksController,
        decoration: InputDecoration(
          labelText: 'Social Media Links',
          labelStyle: const TextStyle(
            fontSize: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: const TextStyle(
          fontSize: 18,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your links';
          }
          return null;
        },
        keyboardType: TextInputType.text,
        onChanged: (value) {
          setState(() => websiteLinks = value);
        },
      ),
    );
  }

  Widget citiesInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: citiesController,
        decoration: InputDecoration(
          labelText: 'Cities You Want to Perform In',
          labelStyle: const TextStyle(
            fontSize: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: const TextStyle(
          fontSize: 18,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your cities';
          }
          return null;
        },
        keyboardType: TextInputType.text,
        onChanged: (value) {
          setState(() => potentialCities = value);
        },
      ),
    );
  }

  Widget phoneNumberInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: phoneNumberController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          labelStyle: const TextStyle(
            fontSize: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: const TextStyle(
          fontSize: 18,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your phone numner';
          }
          return null;
        },
        keyboardType: TextInputType.text,
        onChanged: (value) {
          setState(() => phoneNumber = value);
        },
      ),
    );
  }

  Widget updateInfo() {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(2),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
        backgroundColor:
            MaterialStateProperty.all<Color>(AppTheme.colors.primary),
        fixedSize: MaterialStateProperty.all(const Size(300, 50)),
      ),
      child: Row(children: const [
        Spacer(),
        Text(
          "Update Info",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
        ),
        Spacer(),
      ]),
      onPressed: () async {
        // Connect to the database, and access the current user's uid to be used as primary key
        print("Button Pressed, send info to database");
        String? uid = _authService.userID;

        //Reset error to be empty
        error = "";

        // Check if the current user already has an artist profile

        DatabaseReference artistRef = database.ref("Artists/$uid");

        DatabaseEvent artistEvent = await artistRef.once();

        bool alreadyExists = artistEvent.snapshot.value != null;
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
            updateMap["websiteLinks"] = websiteLinks.split(',');
          } else {
            // websiteLinks is empty, which can potentially be a change
            updateMap["websiteLinks"] = [];
          }
          if (!potentialCities.isEmpty) {
            // Separate cities by comma
            updateMap["potentialCities"] = potentialCities.split(',');
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
            updateMap["websiteLinks"] = websiteLinks.split(',');
          } else {
            // Raise error, require all fields to be non-null
            error = "Empty Field: All fields required";
          }
          if (!potentialCities.isEmpty) {
            // Separate cities by comma
            updateMap["potentialCities"] = potentialCities.split(',');
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
    );
  }
}
