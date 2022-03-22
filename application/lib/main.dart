import 'package:application/models/users.dart';
import 'package:application/screens/wrapper.dart';
import 'package:application/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize firebase
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<BookdUser?>.value(
      // Uses the stream of BookdUser? objects from auth.dart
      initialData: null, // when dependencies were updated for no-null-safety, it wanted me to include initialData parameter, but I dodn't know what to put so I just did null
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
