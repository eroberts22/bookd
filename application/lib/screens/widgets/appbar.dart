import 'package:application/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BookdAppBar extends StatelessWidget implements PreferredSizeWidget{
  const BookdAppBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return AppBar(
        centerTitle: true,
        title: const Text(
          'Bookd.',
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: AppTheme.colors.primary, // transparent background
        elevation: 0.0,
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
              iconSize: 40.0,
              padding: const EdgeInsets.symmetric(horizontal: 10)),
        ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}