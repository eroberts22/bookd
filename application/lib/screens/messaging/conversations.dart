// Homepage listing all available chats for authenticated user
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:application/screens/widgets/artist_appdrawer.dart';
import 'package:application/screens/widgets/appbar.dart';
import 'package:application/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/screens/messaging/chatroom.dart';

class Pair<T1, T2> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);
}

class conversations extends StatefulWidget {
  const conversations({Key? key}) : super(key: key);

  @override
  State<conversations> createState() => _conversationsState();
}

class _conversationsState extends State<conversations> {
  final AuthService _authService = AuthService();

  FirebaseDatabase database = FirebaseDatabase.instance;
  List<Pair> chatIDs = [];

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

    List<Pair> tempChatIDs = [];

    for (String key in chatrooms.keys) {
      String myID = uid ?? "Null";
      //Check if the key contains the userID, if it does append the key to chatIDs
      if (key.contains(myID) == true) {
        String otherUID = "";
        List userIDS = key.split('-');
        if (myID == userIDS[0]) {
          otherUID = userIDS[1];
        } else {
          otherUID = userIDS[0];
        }

        String otherUserName = "None";
        await getName(otherUID).then((value) => 
          {
            otherUserName = value
          });

        Pair ChatID_and_name = Pair(key, otherUserName);

        tempChatIDs.add(ChatID_and_name);
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
                    List<String> ChatroomIDS = chatIDs[index].a.split("-");
                    if (uid == ChatroomIDS[0]) {
                      // The other ID is index 1
                      otherID = ChatroomIDS[1];
                    } else {
                      // The other ID is index 0
                      otherID = ChatroomIDS[0];
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => chatroom(otherUID: otherID)));
                  },
                  child: Column(children: [
                    ListTile(
                      // Title is the other user's username
                      title: Text(chatIDs[index].b),
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
