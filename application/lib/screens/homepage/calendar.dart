import 'package:flutter/material.dart';

class BookdCalendar extends StatelessWidget {
  const BookdCalendar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0.0,
            title: Text('Calendar'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/account');
              },
            )),
    );
  }
}