import 'package:flutter/material.dart';

class RequestTile extends StatelessWidget {
  const RequestTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {}, // *** on pressed: shows the artist's profile
                child: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
                child: Text('Artist Name'),
              ),
              Container(
                  child: Row(
                children: [
                  TextButton(
                    onPressed: () {}, // *** on pressed: approves the artist
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {}, // *** on pressed: rejects the artist
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  )
                ],
              )),
            ],
          )),
    );
  }
}
