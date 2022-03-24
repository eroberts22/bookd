import 'package:application/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object from firebase user id
  // Nullable function
  BookdUser? _userFromFirebaseUser(User? user) {
    return user != null ? BookdUser(user.uid, userEmail) : null;
  }

  // Authentication change in user stream
  Stream<BookdUser?> get user {
    // user is the current user of the app
    // Map the stream of FirebaseUsers -> BookdUser calling the conversion function for each item
    return _auth
        .authStateChanges()
        .map(_userFromFirebaseUser); //listens for if a user is signed in or not
  }

  String? get userEmail {
    return _auth.currentUser?.email;
  }

  String? get userID {
    return _auth.currentUser?.uid;
  }

  // Sign in anonymous
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      if (result.user == null) {
        // catch null firebase user before assigning it to an app user
        return null; //an error will be outputed from signin page
      }
      User user = result
          .user!; //use result.user! here since we know result.user isn't null
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password:
              password); // same as register but gets existing firebase user
      if (result.user == null) {
        // catch null firebase user before assigning it to an app user
        return null;
      }
      User user = result.user!; //turn firebase user into bookd user
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user == null) {
        // catch null firebase user before assigning it to an app user
        return null;
      }
      User user = result.user!; //turn firebase user into bookd user
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    //TODO: error box pop-up in main app if signout fails
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
