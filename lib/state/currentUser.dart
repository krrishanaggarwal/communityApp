import 'package:community/models/user.dart';
import 'package:community/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CurrentState extends ChangeNotifier {
  // String _uid;
  // String _email;
  FirebaseAuth _auth = FirebaseAuth.instance;
  OurUser _currentUser = OurUser();

  OurUser get getCurrentUser => _currentUser;

  Future<String> onStartUp() async {
    String retVal = "error";

    try {
      FirebaseUser _firebaseUser = await _auth.currentUser();
      if (_firebaseUser != null) {
        _currentUser = await OurDatabase().getUserInfo(_firebaseUser.uid);
        if (_currentUser != null) {
          retVal = "success";
        }
      }
    } catch (e) {
      print(e.message);
    }
    return retVal;
  }

  Future<String> signOut() async {
    String retVal = "error";

    try {
      await _auth.signOut();
      _currentUser = OurUser();
      retVal = "success";
    } catch (e) {
      print(e.message);
    }
    return retVal;
  }

  Future<String> signUpUser(
      String email, String password, String fullName) async {
    String retVal = "error";
    OurUser _user = OurUser();

    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user.id = _authResult.user.uid;
      _user.email = _authResult.user.email;
      _user.username = fullName;
      _user.displayName = fullName;
      _user.fieldOfInterest = "DA";
      _user.photoUrl =
          "https://lh3.googleusercontent.com/a/AATXAJwW4hjHbKQMIrZwWpD36jSd3tuQs8wt6Yea9XZ6=s96-c";
      _user.isOrganizer = false;
      String retString = await OurDatabase().createUser(_user);
      if (retString == "success") {
        if (_authResult.user != null) {
          retVal = "success";
        }
      }
    } catch (e) {
      retVal = e.message;
    }
    return retVal;
  }

  Future<String> loginInUserWithEmail(String email, String password) async {
    String retVal = "error";

    try {
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _currentUser = await OurDatabase().getUserInfo(_authResult.user.uid);
      if (_currentUser != null) {
        retVal = "success";
      }
    } catch (e) {
      retVal = e.message;
    }
    return retVal;
  }

  Future<String> loginInUserWithGoogle() async {
    String retVal = "error";
    GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);

    OurUser _user = new OurUser();
    try {
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      AuthResult _authResult = await _auth.signInWithCredential(credential);

      if (_authResult.additionalUserInfo.isNewUser) {
        _user.id = _authResult.user.uid;
        _user.email = _authResult.user.email;
        _user.photoUrl = _authResult.user.photoUrl;
        _user.displayName = _authResult.user.displayName;
        _user.username = _authResult.user.displayName;
        _user.fieldOfInterest = "DA";

        _user.isOrganizer = false;
        OurDatabase().createUser(_user);
      }
      _currentUser = await OurDatabase().getUserInfo(_authResult.user.uid);
      if (_currentUser != null) {
        retVal = "success";
      }
    } on PlatformException catch (e) {
      retVal = e.message;
    }
    return retVal;
  }
}
