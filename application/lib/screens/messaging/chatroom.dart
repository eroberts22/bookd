import 'package:application/services/auth.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/models/artist.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:date_format/date_format.dart';

// Stateful widget for a chatroom
class chatroom extends StatefulWidget {
  final String otherUID;

  const chatroom({Key? key, required this.otherUID}) : super(key: key);

  @override
  State<chatroom> createState() => _chatroomState();
}

class _chatroomState extends State<chatroom> {
  final AuthService _authService = AuthService();

  FirebaseDatabase database = FirebaseDatabase.instance;

  ChatUser chatUser = ChatUser(id: 'NULL', firstName: 'NULL');

  ChatUser otherUser = ChatUser(id: 'NULL', firstName: 'NULL');

  String userName = "";

  String otherName = "";

  List<ChatMessage> messages = [];

  // Chat ID = user1ID-user2ID
  String chatID = "";

  @override
  void initState() {
    super.initState();
    // Init chat with other user after users have been initialized
    initUsers().then((v) => {_initChat(chatUser.id, otherUser.id)});
  }

  void uploadMessages() async {
    // Assumes that the chatID has already been setup
    DatabaseReference chatMessagesRef = database.ref("Chatrooms/$chatID");
    List<Map<String, dynamic>> dbMessages = [];
    for (var i = 0; i < messages.length; i++) {
      dbMessages.add(messages[i].toJson());
    }
    await chatMessagesRef.update({"messages": dbMessages});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic example'),
      ),
      body: DashChat(
        currentUser: chatUser,
        onSend: (ChatMessage m) {
          setState(() {
            messages.insert(0, m);

            uploadMessages();
          });
        },
        messages: messages,
      ),
    );
  }

  Future _initUser(String uid) async {
    DatabaseEvent userEvent = await database.ref("/Users/$uid").once();
    Map<String, dynamic>? userInfo =
        jsonDecode(jsonEncode(userEvent.snapshot.value));
    print(userInfo);

    String DBPath = "";
    String userName = "";

    if (userInfo != null) {
      if (userInfo["profileType"] == "artist") {
        // Artist profile type
        DBPath = "Artists/$uid";

        // Get the name for the user
        DatabaseEvent userNameEvent = await database.ref(DBPath).once();

        Map<String, dynamic>? userInfo =
            jsonDecode(jsonEncode(userNameEvent.snapshot.value));

        if (userInfo == null || userNameEvent.snapshot.value == null) {
          setState(() {
            userName = "Unnamed-$uid";
          });
        } else {
          setState(() {
            userName = userInfo["stageName"];
          });
        }
      } else if (userInfo["profileType"] == "venue") {
        // Venue profile type
        DBPath = "Venues/$uid";
        // Get the name for the user
        DatabaseEvent otherNameEvent = await database.ref(DBPath).once();

        Map<String, dynamic> userInfo =
            jsonDecode(jsonEncode(otherNameEvent.snapshot.value));

        if (otherNameEvent.snapshot.value == null) {
          setState(() {
            userName = "Unnamed-$uid";
          });
        } else {
          setState(() {
            userName = userInfo["name"];
          });
        }
      }
    } else {
      // ERROR! Neither artist nor venue
      String error_str = "Error: Unable to find a profile for user: $uid";
    }

    // Update state
    setState(() {
      chatUser = ChatUser(id: uid, firstName: userName);
      userName = userName;
    });

    print("Init User: $uid, $userName");
    print(chatUser.id);
    print(chatUser.firstName);
  }

  Future _initOtherUser(String uid) async {
    DatabaseEvent userEvent = await database.ref("/Users/$uid").once();
    Map<String, dynamic>? userInfo =
        jsonDecode(jsonEncode(userEvent.snapshot.value));
    print(userInfo);

    String DBPath = "";
    String userName = "";

    if (userInfo != null) {
      if (userInfo["profileType"] == "artist") {
        // Artist profile type
        DBPath = "Artists/$uid";

        // Get the name for the user
        DatabaseEvent userNameEvent = await database.ref(DBPath).once();

        Map<String, dynamic>? userInfo =
            jsonDecode(jsonEncode(userNameEvent.snapshot.value));

        if (userInfo == null || userNameEvent.snapshot.value == null) {
          setState(() {
            userName = "Unnamed-$uid";
          });
        } else {
          setState(() {
            userName = userInfo["stageName"];
          });
        }
      } else if (userInfo["profileType"] == "venue") {
        // Venue profile type
        DBPath = "Venues/$uid";
        // Get the name for the user
        DatabaseEvent otherNameEvent = await database.ref(DBPath).once();

        Map<String, dynamic> userInfo =
            jsonDecode(jsonEncode(otherNameEvent.snapshot.value));

        if (otherNameEvent.snapshot.value == null) {
          setState(() {
            userName = "Unnamed-$uid";
          });
        } else {
          setState(() {
            userName = userInfo["name"];
          });
        }
      }
    } else {
      // ERROR! Neither artist nor venue
      String error_str = "Error: Unable to find a profile for user: $uid";
    }

    // Update state
    setState(() {
      otherUser = ChatUser(id: uid, firstName: userName);
      otherName = userName;
    });

    print("Init User: $uid, $userName");
    print(otherUser.id);
    print(otherUser.firstName);
  }

  // Initialize User: Name, id (same as userID)
  Future initUsers() async {
    String? uid = _authService.userID;
    print(uid);
    if (uid != null) {
      // Init self
      await _initUser(uid);

      // Init other user
      String otherUID = widget.otherUID;
      await _initOtherUser(otherUID);
    }
    return;
  }

  void _initChat(String uid1, String uid2) async {
    DatabaseEvent chatroomsEvent = await database.ref("Chatrooms").once();

    Map<String, dynamic> chatrooms =
        jsonDecode(jsonEncode(chatroomsEvent.snapshot.value));

    // Iterate through all chatrooms
    for (var key in chatrooms.keys) {
      // Check if key matches $uid1-$uid2
      if (key == "$uid1-$uid2") {
        // Found a chatroom
        setState(() {
          chatID = "$uid1-$uid2";
        });
      } else if (key == "$uid2-$uid1") {
        // Found a chatroom
        setState(() {
          chatID = "$uid2-$uid1";
        });
      }
    }

    // If chatID is still empty, then we need to create a new chat
    if (chatID == "") {
      createChat().then(
        (newChatID) {
          setState(() {
            chatID = newChatID ?? "error";
          });
        },
      );
    } else {
      // Retrieve and setup the existing chat
      retrieveExistingChat();
    }
  }

  // Create new chat with authenticated user and other user
  Future<String?> createChat() async {
    String? uid = _authService.userID;
    String otherUID = widget.otherUID;
    if (uid != null) {
      String chatKey = "$uid-$otherUID";

      // Add users to list of users
      List<Map<String, dynamic>> userList = [];
      print(chatUser.toJson());
      print(otherUser.toJson());
      userList.add(chatUser.toJson());
      userList.add(otherUser.toJson());

      String? artistName = chatUser.firstName;
      String? venueName = otherUser.firstName;

      // Add default message welcoming users
      ChatMessage welcomeMSG = ChatMessage(
        user: ChatUser(id: "welcomeBot", firstName: "Welcome Bot"), 
        text: "Welcome $venueName, $artistName would like to connect with you!",
        createdAt: DateTime.now());
      
      // Initialize messages with default bot welcome
      setState(() {
        messages = [welcomeMSG];
      });

      Map<String, dynamic> chatroom = {"members": userList, "messages": [welcomeMSG.toJson()]};

      DatabaseReference chatRef = database.ref("Chatrooms/$chatKey");
      await chatRef.set(chatroom);

      return chatKey;
    } else {
      //Error! Can't create the chat
      String error_str =
          "Error: One of the two user Ids are null: $uid, $otherUID";
      return null;
    }
  }

  // Assumes that the chatID field has been set
  void retrieveExistingChat() async {
    DatabaseEvent chatroomEvent =
        await database.ref("Chatrooms/$chatID").once();

    Map<String, dynamic> chatroom =
        jsonDecode(jsonEncode(chatroomEvent.snapshot.value));

    // Get the previously stored messages
    List<ChatMessage> existingMessages = [];

    List<dynamic> chatMessages =
        chatroom["messages"] as List<dynamic>;

    // Convert each json message into a ChatMessage
    for (var i = 0; i < chatMessages.length; i++) {
      Map<String, dynamic> inputMsg = {};
      inputMsg["user"] = chatMessages[i]["user"];
      inputMsg["text"] = chatMessages[i]["text"];
      inputMsg["createdAt"] = chatMessages[i]["createdAt"];
      ChatUser msgUser = ChatUser(
          id: inputMsg["user"]["id"],
          firstName: inputMsg["user"]["firstname"]);

      print("Adding message $inputMsg");

      existingMessages.add(ChatMessage(
          user: msgUser,
          text: inputMsg["text"],
          createdAt: DateTime.parse(inputMsg["createdAt"])));
    }
    setState(() {
      messages = existingMessages;
    });
  }
}

// void createNewChatroom(List<String> userIDs) async {
//   // Does there already exist a chatroom for the list of users?
//   // TODO

//   List<Map<String, dynamic>> users = [];
//   // Get user info
//   // Name (venue: name, artist: stagename)
//   // userID
//   // Loop through all userIDs and create ChatUser objects for them
//   for (var i = 0; i < userIDs.length; i++) {
//     String userID = userIDs[i];
//     DatabaseEvent userEvent = await database.ref("/Users/$userID").once();
//     Map<String, dynamic>? userInfo =
//         jsonDecode(jsonEncode(userEvent.snapshot.value));

//     String userName = "";

//     if (userInfo != null) {
//       String profType = userInfo["profileType"];
//       if (profType == "artist") {
//         // User is an artist
//         // Get the name from the user
//         DatabaseEvent artistEvent =
//             await database.ref("/Artists/$userID").once();
//         Map<String, dynamic>? artistInfo =
//             jsonDecode(jsonEncode(artistEvent.snapshot.value));
//         if (artistInfo != null) {
//           userName = userInfo["stageName"] ?? "UnnamedArtist";
//         }
//       } else if (profType == "venue") {
//         // User is a venue
//         // Get the name from the user
//         DatabaseEvent venueEvent =
//             await database.ref("/Venues/$userID").once();
//         Map<String, dynamic>? venueInfo =
//             jsonDecode(jsonEncode(venueEvent.snapshot.value));
//         if (venueInfo != null) {
//           userName = userInfo["name"] ?? "UnnamedVenue";
//         }
//       } else {
//         // Error!
//       }
//     } else {
//       // Error!
//     }
//     ChatUser newUser = ChatUser(id: userID, firstName: userName);
//     users.add(newUser.toJson());
//   }

//   List<Map<String, dynamic>> initMessage = [
//     ChatMessage(text: 'Hey!', user: user, createdAt: DateTime.now()).toJson()
//   ];

//   // Now that we have a list of users, create a chatroom in the database
//   Map<String, dynamic> chatroom = {"members": users, "messages": initMessage};

//   DatabaseReference chatRef = database.ref("Chatrooms/$chatID");
//   await chatRef.update(chatroom);
// }

// void initChatroom(int chatID) async {
//   // Build chatroom from chatroom id (1 for now)
//   DatabaseReference chatRef = database.ref("Chatrooms/$chatID");
//   DatabaseEvent chatEvent = await chatRef.once();
//   Map<String, dynamic> chatRoom =
//       jsonDecode(jsonEncode(chatEvent.snapshot.value));

//   if (chatRoom["messages"] != null) {
//     List<dynamic> messagesJSON = chatRoom["messages"];

//     // Convert the json messages to the necessary message class
//     List<ChatMessage> messageList = [];
//     for (var i = 0; i < messagesJSON.length; i++) {
//       Map<String, dynamic> inputMsg = {};
//       inputMsg["user"] = messagesJSON[i]["user"];
//       inputMsg["text"] = messagesJSON[i]["text"];
//       inputMsg["createdAt"] = messagesJSON[i]["createdAt"];
//       ChatUser msgUser = ChatUser(
//           id: inputMsg["user"]["id"],
//           firstName: inputMsg["user"]["firstname"]);

//       print("Adding message $inputMsg");

//       messageList.add(ChatMessage(
//           user: msgUser,
//           text: inputMsg["text"],
//           createdAt: DateTime.parse(inputMsg["createdAt"])));
//     }

//     setState(() => messages = messageList);
//   }
// }
