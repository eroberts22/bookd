import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';

// placeholder search bar

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      child: Row(children: [
        // Text field
        Flexible(
          child: TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search for Venues',
            ),
          ),
        ),
      ]),
    );
  }
}
