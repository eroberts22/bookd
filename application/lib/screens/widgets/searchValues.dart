import 'package:flutter/material.dart';

class BookdSearchField extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController editingController = TextEditingController();
  BookdSearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {},
      controller: editingController,
      decoration: const InputDecoration(
        labelText: "Search",
        hintText: "Search",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
