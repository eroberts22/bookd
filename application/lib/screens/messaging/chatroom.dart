import 'package:application/services/auth.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/models/artist.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:date_format/date_format.dart';

// Stateful widget for a chatroom
class chatroom extends StatefulWidget {
  const chatroom({Key? key}) : super(key: key);

  @override
  State<chatroom> createState() => _chatroomState();
}

class _chatroomState extends State<chatroom> {
  final AuthService _authService = AuthService();

  FirebaseDatabase database = FirebaseDatabase.instance;

  ChatUser user = ChatUser(id: '1', firstName: 'Charles');

  List<ChatMessage> messages = [];

  int chatID = 1;

  @override
  void initState() {
    super.initState();
    initChatroom(chatID);
  }

  void createNewChatroom(List<String> userIDs) async {
    // Does there already exist a chatroom for the list of users?
    // TODO

    List<Map<String, dynamic>> users = [];
    // Get user info
    // Name (venue: name, artist: stagename)
    // userID
    // Loop through all userIDs and create ChatUser objects for them
    for (var i = 0; i < userIDs.length; i++) {
      String userID = userIDs[i];
      DatabaseEvent userEvent = await database.ref("/Users/$userID").once();
      Map<String, dynamic>? userInfo =
          jsonDecode(jsonEncode(userEvent.snapshot.value));

      String userName = "";

      if (userInfo != null) {
        String profType = userInfo["profileType"];
        if (profType == "artist") {
          // User is an artist
          // Get the name from the user
          DatabaseEvent artistEvent =
              await database.ref("/Artists/$userID").once();
          Map<String, dynamic>? artistInfo =
              jsonDecode(jsonEncode(artistEvent.snapshot.value));
          if (artistInfo != null) {
            userName = userInfo["stageName"] ?? "UnnamedArtist";
          }
        } else if (profType == "venue") {
          // User is a venue
          // Get the name from the user
          DatabaseEvent venueEvent =
              await database.ref("/Venues/$userID").once();
          Map<String, dynamic>? venueInfo =
              jsonDecode(jsonEncode(venueEvent.snapshot.value));
          if (venueInfo != null) {
            userName = userInfo["name"] ?? "UnnamedVenue";
          }
        } else {
          // Error!
        }
      } else {
        // Error!
      }
      ChatUser newUser = ChatUser(id: userID, firstName: userName);
      users.add(newUser.toJson());
    }

    List<Map<String, dynamic>> initMessage = [
      ChatMessage(text: 'Hey!', user: user, createdAt: DateTime.now()).toJson()
    ];

    // Now that we have a list of users, create a chatroom in the database
    Map<String, dynamic> chatroom = {"members": users, "messages": initMessage};

    DatabaseReference chatRef = database.ref("Chatrooms/$chatID");
    await chatRef.update(chatroom);
  }

  void initChatroom(int chatID) async {
    // Build chatroom from chatroom id (1 for now)
    DatabaseReference chatRef = database.ref("Chatrooms/$chatID");
    DatabaseEvent chatEvent = await chatRef.once();
    Map<String, dynamic> chatRoom =
        jsonDecode(jsonEncode(chatEvent.snapshot.value));

    if (chatRoom["messages"] != null) {
      List<dynamic> messagesJSON = chatRoom["messages"];

      // Convert the json messages to the necessary message class
      List<ChatMessage> messageList = [];
      for (var i = 0; i < messagesJSON.length; i++) {
        Map<String, dynamic> inputMsg = {};
        inputMsg["user"] = messagesJSON[i]["user"];
        inputMsg["text"] = messagesJSON[i]["text"];
        inputMsg["createdAt"] = messagesJSON[i]["createdAt"];
        ChatUser msgUser = ChatUser(
            id: inputMsg["user"]["id"],
            firstName: inputMsg["user"]["firstname"]);

        print("Adding message $inputMsg");

        messageList.add(ChatMessage(
            user: msgUser,
            text: inputMsg["text"],
            createdAt: DateTime.parse(inputMsg["createdAt"])));
      }

      setState(() =>  messages = messageList);
    }
  }

  void updateMessages() async {
    DatabaseReference chatMessagesRef = database.ref("Chatrooms/$chatID");
    await chatMessagesRef.update({"messages": messages});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic example'),
      ),
      body: DashChat(
        currentUser: user,
        onSend: (ChatMessage m) {
          setState(() {
            messages.insert(0, m);

            // Update the chatroom messages
            updateMessages();
          });
        },
        messages: messages,
      ),
    );
  }
}
