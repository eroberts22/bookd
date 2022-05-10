import 'package:application/screens/messaging/chatroom.dart';
import 'package:flutter/material.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/artist_appdrawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/screens/widgets/searchValues.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  TextEditingController editingController = TextEditingController();
  FirebaseDatabase database = FirebaseDatabase.instance;
  List<Map<String, dynamic>> venues = [];

  @override
  void initState() {
    super.initState();
    _getVenues();
  }

  void _getVenues() async {
    DatabaseReference dbRef = database.ref();
    DatabaseEvent thisVenue = await dbRef.child("Venues").orderByValue().once();
    setState(() {
      for (var user in thisVenue.snapshot.children) {
        Map<String, dynamic> venueInfo = {};
        venueInfo["id"] = user.key ?? "Null";
        venueInfo["name"] = user.child("name").value.toString();
        venueInfo["description"] = user.child("description").value.toString();
        venueInfo["streetAddress"] =
            user.child("streetAddress").value.toString();

        venues.add(venueInfo);
      }
    });
  }

  void filterSearchResults(String query) {
    List<dynamic> searchList = [];
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      searchList.forEach((element) {
        if (element.contains(query)) {
          dummyListData.add(element);
        }
      });
    }
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
              child: BookdSearchField(),
            ),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: venues.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    elevation: 6.0,
                    child: InkWell(
                      onTap: () {
                        //call venue page passing in venue id
                        Navigator.of(context).pushReplacementNamed(
                            '/profile-venue',
                            arguments: {"uid": venues[index]["id"].toString()});
                      },
                      child: Column(children: [
                        ListTile(
                          title: Text(venues[index]["name"].toString()),
                          subtitle:
                              Text(venues[index]["streetAddress"].toString()),
                          trailing: const Icon(Icons.favorite),
                        ),
                        SizedBox(
                          height: 200.0,
                          child: Ink.image(
                            image: const AssetImage(
                                'assets/images/venue_test.jpg'),
                            fit: BoxFit.cover,
                            child: InkWell(onTap: () {}),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.centerLeft,
                          child: Text(venues[index]["description"].toString()),
                        ),
                        ButtonBar(
                          children: [
                            TextButton(
                              child: const Text('Contact Venue'),
                              onPressed: () {
                                // Create a new conversation between
                                var venueID = venues[index]["id"].toString();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        chatroom(otherUID: venueID)));
                              },
                            ),
                          ],
                        )
                      ]),
                    ));
              },
            ))
          ],
        ));
  }
}
