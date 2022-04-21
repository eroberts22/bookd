import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/artist_appdrawer.dart';
import 'package:application/screens/widgets/searchbar.dart';


class Explore extends StatefulWidget {

  const Explore({ Key? key }) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      drawer: const ABookdAppDrawer(),
      appBar: const BookdAppBar(),
      body: Center(child: 
      Column(children: const [
       // Text('Explore Venues', style: TextStyle(fontSize: 20),),
       // SearchBar()
      ],
    )));
  }
}