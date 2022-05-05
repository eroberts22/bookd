// Homepage listing all available chats for authenticated user
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:application/screens/widgets/artist_appdrawer.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/screens/messaging/chatroom.dart';

class conversations extends StatefulWidget {
  const conversations({Key? key}) : super(key: key);

  @override
  State<conversations> createState() => _conversationsState();
}

class _conversationsState extends State<conversations> {
  final AuthService _authService = AuthService();

  FirebaseDatabase database = FirebaseDatabase.instance;
  List<String> chatIDs = [];

  String? uid = "";

  @override
  void initState() {
    super.initState();

    // Get chatIDs that include the authenticated user
    _getChatIDs();
  }

  void _getChatIDs() async {
    setState(() {
      uid = _authService.userID;
    });
    DatabaseEvent chatroomsEvent = await database.ref("Chatrooms").once();

    Map<String, dynamic> chatrooms =
        jsonDecode(jsonEncode(chatroomsEvent.snapshot.value));

    List<String> tempChatIDs = [];

    for (String key in chatrooms.keys) {
      //Check if the key contains the userID, if it does append the key to chatIDs
      if (key.contains(key) == true) {
        tempChatIDs.add(key);
      }
    }
    setState(() {
      chatIDs = tempChatIDs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        drawer: const ABookdAppDrawer(),
        appBar: const BookdAppBar(),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: chatIDs.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                elevation: 6.0,
                child: InkWell(
                  onTap: () {
                    String otherID = "";
                    // Get other user ID
                    List<String> userIDS = chatIDs[index].split("-");
                    if (uid == userIDS[0]) {
                      // The other ID is index 1
                      otherID = userIDS[1];
                    } else {
                      // The other ID is index 0
                      otherID = userIDS[0];
                    }
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => chatroom(otherUID: otherID)));
                  },
                  child: Column(children: [
                    ListTile(
                      title: Text(chatIDs[index]),
                      trailing: const Icon(Icons.favorite),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: Text("Sample Text"),
                    )
                  ]),
                ));
          },
        ));
  }
}
