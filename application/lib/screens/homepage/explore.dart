import 'package:flutter/material.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/artist_appdrawer.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        drawer: ABookdAppDrawer(),
        appBar: BookdAppBar(),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                buildCard(),
                buildCard(),
              ],
            ),
          ),
        ));
  }

  Card buildCard() {
    var title = "Title of Venue Here";
    var defaultCardImage =
        const AssetImage('assets/images/venue_defaultImage.jpg');
    var description = "The description goes here";
    var ratings = "The ratings go here";

    return Card(
        elevation: 4.0,
        child: Column(
          children: [
            ListTile(
              title: Text(title),
              subtitle: Text(ratings),
              trailing: const Icon(Icons.favorite),
            ),
            SizedBox(
              height: 200.0,
              child: Ink.image(
                image: defaultCardImage,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(ratings),
            ),
            ButtonBar(
              children: [
                TextButton(
                  child: const Text('Contact Venue'),
                  onPressed: () {},
                ),
                TextButton(
                  child: const Text('Learn More'),
                  onPressed: () {},
                )
              ],
            )
          ],
        ));
  }
}
