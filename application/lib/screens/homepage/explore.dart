import 'package:application/screens/messaging/chatroom.dart';
import 'package:application/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/artist_appdrawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  late DatabaseEvent
      event; // Store a reference to potential cities from Artists
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> venues = []; // List containing venues from database
  List<Map<String, dynamic>> searchList = [];
  List<dynamic> potentialCitiesFromArtist = [];

  @override
  void initState() {
    super.initState();
    _getVenues(); // update venues list
    // searchList = venues;
  }

  void _getVenues() async {
    String? uid = _authService
        .userID; // user id to check for potential cities from artists
    DatabaseReference dbRef = database.ref();
    DatabaseEvent allVenues =
        await dbRef.child("Venues").orderByValue().once(); // Get all Venues
    List<dynamic> cities = []; // Venue cities from the database
    event = await dbRef
        .child('Artists/$uid/potentialCities')
        .orderByValue()
        .once(); // Get all potential cities from Artists
    for (var potentialCity in event.snapshot.children) {
      cities.add(potentialCity.value.toString().toLowerCase());
    }

    //get all the venues and add them to global list of all venues
    List<Map<String, dynamic>> venueData = [];
    for (var venue in allVenues.snapshot.children) {
      var cityOfVenue = venue
          .child("city")
          .value
          .toString()
          .toLowerCase(); // Get current city of Venue
      for (var city in cities) {
        // Compare potential cities from current Artist to the city of current Venue
        // If they match, add to venues list to display in UI
        if (city == cityOfVenue) {
          Map<String, dynamic> venueInfo = {};
          venueInfo["id"] = venue.key ?? "Null";
          venueInfo["name"] = venue.child("name").value.toString();
          venueInfo["description"] =
              venue.child("description").value.toString();
          venueInfo["streetAddress"] =
              venue.child("streetAddress").value.toString();
          venueInfo["city"] = venue.child("city").value.toString();
          //add profile photo
          String profilePhotoName = venue.child("profileImage").value.toString();
          if (profilePhotoName != "null"){
            print("hello");
            await storage.ref().child("Images/${venue.key}/${profilePhotoName}").getData(10000000).then((data) =>(
              venueInfo["profileImage"] = data
            )
            );
          }
          else{
            venueInfo["profileImage"] = null;
          }
          venueData.add(venueInfo);
        }
      }
    }
    setState(() {
      potentialCitiesFromArtist = cities; // populate the potentialCites from the cities found
      venues = venueData;
      searchList = venues;
    });
  }

  void _filterSearchResults(String query) {
    List<Map<String, dynamic>> results = [];
    if (query.isEmpty) {
      // If the search field is empty or contains white space, display all cards
      results = venues;
    } else {
      results = venues
          .where((element) =>
              element["city"].toLowerCase().contains(query.toLowerCase()) ||
              element["name"].toLowerCase().contains(query.toLowerCase()) ||
              element["description"]
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      searchList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        drawer: const ABookdAppDrawer(),
        appBar: const BookdAppBar(),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => _filterSearchResults(value),
                decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                ),
              ),
            ),
            Expanded(
              child: searchList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 6.0,
                            child: InkWell(
                              onTap: () {
                                //call venue page passing in venue id
                                Navigator.of(context).pushReplacementNamed(
                                    '/explore-profile-venue',
                                    arguments: {
                                      "uid": searchList[index]["id"].toString()
                                    });
                              },
                              child: Column(children: [
                                ListTile(
                                  title: Text(
                                      searchList[index]["name"].toString()),
                                  subtitle: Text(searchList[index]
                                              ["streetAddress"]
                                          .toString() +
                                      " | " +
                                      searchList[index]["city"]
                                          .toString()
                                          .toUpperCase()),
                                  trailing: const Icon(Icons.favorite),
                                ),
                                SizedBox(
                                  height: 200.0,
                                  child: InkWell(
                                    child:searchList[index]["profileImage"] != null ? Image.memory(
                                          searchList[index]["profileImage"]!,
                                          fit: BoxFit.cover,
                                          ): const Center(
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey,
                                              ),
                                          ),
                                    onTap: () {
                                      //call venue page passing in venue id
                                      Navigator.of(context).pushReplacementNamed(
                                        '/profile-venue',
                                        arguments: {
                                        "uid": searchList[index]["id"].toString()
                                      });
                                    }
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(searchList[index]["description"]
                                      .toString()),
                                ),
                                ButtonBar(
                                  children: [
                                    TextButton(
                                      child: const Text('Contact Venue'),
                                      onPressed: () {
                                        // Create a new conversation between
                                        var venueID =
                                            searchList[index]["id"].toString();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => chatroom(
                                                    otherUID: venueID)));
                                      },
                                    ),
                                  ],
                                )
                              ]),
                            ));
                      },
                    )
                  : const Text(
                      // No matches
                      'No Results Found',
                      style: TextStyle(fontSize: 20),
                    ),
            )
          ],
        ));
  }
}
