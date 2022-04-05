import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/screens/widgets/appdrawer.dart';
import 'package:application/screens/widgets/searchbar.dart';


class Explore extends StatefulWidget {

  const Explore({ Key? key }) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
   final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      resizeToAvoidBottomInset: false,
      drawer: AppDrawer(),
      appBar: BookdAppBar(),
      body: Center(child: 
      Column(children: [
       // Text('Explore Venues', style: TextStyle(fontSize: 20),),
        SearchBar()
      ],
    )));
  }
}