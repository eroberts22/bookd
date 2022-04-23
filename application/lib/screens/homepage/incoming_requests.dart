// page that shows in venue version
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:application/screens/widgets/request_tile.dart';

class IncomingRequestPage extends StatefulWidget {
  const IncomingRequestPage({ Key? key }) : super(key: key);

  @override
  State<IncomingRequestPage> createState() => _IncomingRequestPageState();
}

class _IncomingRequestPageState extends State<IncomingRequestPage> {

  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;
  List<String> bookingReqIds = [];
  @override
  void initState() {
    super.initState();
    _getVenueEvent();
  }

  void _getVenueEvent() async{ //get database event for thisVenue so we can access its incoming requests
    String uid = _authService.userID!; 
    DatabaseReference venueRef = database.ref().child("Venues/$uid/bookingRequests");
    DatabaseEvent thisVenue = await venueRef.once();
    List<String> requests = [];
    for(var child in thisVenue.snapshot.children){
      requests.add(child.value.toString());
    }
    setState(() {
      bookingReqIds = requests;
    });
  }

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
        body: ListView.builder(
          itemCount: bookingReqIds.length,
          itemBuilder: (BuildContext context, int index){
            return RequestTile(bookingReqIds[index]);
          },
        ),
        );
  }
}