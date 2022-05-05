// page that shows in artist version
import 'package:flutter/material.dart';
import 'package:application/screens/widgets/booking_tile.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({ Key? key }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0.0,
            title: const Text('Bookings'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/account-artist');
              },
            )),
        body: Container(),
        //BookingTile(),
        );
  }
}