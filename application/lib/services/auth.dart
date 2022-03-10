import 'package:application/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object from firebase user id
  // Nullable function
  BookdUser? _userFromFirebaseUser(User user) {
    if (user != null) {
      return BookdUser(user.uid, "email", "name");
    } else {
      return null;
    }
  }

  // Sign in with email and password

  // Register with email and password

  // Sign out

}
