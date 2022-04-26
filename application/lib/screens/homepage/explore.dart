import 'package:flutter/material.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/artist_appdrawer.dart';
import 'package:firebase_database/firebase_database.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  List<dynamic> listIds = [];

  @override
  void initState() {
    super.initState();
    _getVenues();
  }

  void _getVenues() async {
    DatabaseReference dbRef = database.ref();
    DatabaseEvent thisVenue = await dbRef.child("Venues").orderByValue().once();
    List<Map<String, dynamic>> venues = [];
    for (var user in thisVenue.snapshot.children) {
      Map<String, dynamic> venueInfo = {};
      venueInfo["id"] = user.key ?? "Null";
      venueInfo["name"] = user.child("name").value.toString();
      venues.add(venueInfo);
    }
    setState(() {
      listIds = venues;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        drawer: const ABookdAppDrawer(),
        appBar: const BookdAppBar(),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: listIds.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 4.0,
              child: Column(children: [
                ListTile(
                  title: Text(listIds[index]["name"]),
                  subtitle: const Text("Ratings"),
                  trailing: const Icon(Icons.favorite),
                ),
                SizedBox(
                  height: 200.0,
                  child: Ink.image(
                    image: const AssetImage('assets/images/venue_test.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerLeft,
                  child: const Text("Other Information"),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                      child: const Text('Contact Venue'),
                      onPressed: () {
                        // Create a new conversation between
                        var venueID = listIds[index]["id"].toString();
                        print("Venue $venueID");
                      },
                    ),
                    TextButton(
                      child: const Text('Learn More'),
                      onPressed: () {},
                    )
                  ],
                )
              ]),
            );
          },
        ));
  }
}
