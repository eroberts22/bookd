import 'package:application/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object from firebase user id
  // Nullable function
  BookdUser? _userFromFirebaseUser(User? user) {
    return user != null ? BookdUser(user.uid, "email", "name") : null;
  }

  // Authentication change in user stream
  Stream<BookdUser?> get user {
    // Map the stream of FirebaseUsers -> BookdUser calling the conversion function for each item
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Sign in anonymous
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      // Catch a null return value
      if (user == null) {
        print("Unable to login!");
        return null;
      }
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password

  // Register with email and password

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
