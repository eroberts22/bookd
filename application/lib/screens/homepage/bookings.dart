// page that shows in artist version
import 'package:application/theme/app_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:application/screens/widgets/booking_tile.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({ Key? key }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;
  List<String> bookingIds = [];
  @override
  void initState() {
    super.initState();
    _getBookingIds();
  }

  void _getBookingIds() async{ //get the bookings for this artist
    String uid = _authService.userID!; 
    DatabaseReference artistRef = database.ref().child("Artists/$uid/bookings");
    DatabaseEvent thisArtist = await artistRef.once();
    List<String> bookings = [];
    for(var child in thisArtist.snapshot.children){
      bookings.add(child.key.toString());
      print(child.key.toString());
    }
    setState(() {
      bookingIds = bookings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: AppTheme.colors.primary,
            elevation: 0.0,
            title: const Text('Bookings'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/account-artist');
              },
            )),
        body: ListView.builder(
          itemCount: bookingIds.length,
          itemBuilder: (BuildContext context, int index){
            return BookingTile(bookingIds[index]);
          },
        ),
        //BookingTile(),
        );
  }
}