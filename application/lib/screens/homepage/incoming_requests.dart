// page that shows in venue version
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';

class IncomingRequestPage extends StatefulWidget {
  const IncomingRequestPage({ Key? key }) : super(key: key);

  @override
  State<IncomingRequestPage> createState() => _IncomingRequestPageState();
}

class _IncomingRequestPageState extends State<IncomingRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0.0,
            title: const Text('Incoming Requests'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/account-venue');
              },
            )),
        body: Container(
          ),
        );
  }
}