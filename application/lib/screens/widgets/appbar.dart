import 'package:flutter/material.dart';

class BookdAppBar extends StatelessWidget implements PreferredSizeWidget{
  const BookdAppBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return AppBar(
        centerTitle: true,
        title: Text(
          'Bookd',
          style: TextStyle(fontSize: 40),
        ),
        backgroundColor: Color.fromARGB(0, 0, 0, 0), // transparent background
        foregroundColor: Colors.cyan,
        elevation: 0.0,
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu),
              iconSize: 50.0,
              padding: EdgeInsets.symmetric(horizontal: 10)),
        ),
    );
  }
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}