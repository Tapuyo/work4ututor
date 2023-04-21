// // ignore_for_file: avoid_print

// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:wokr4ututor/services/services.dart';
import '../../data_class/user_class.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on firebaseuser
  Users? _userFromFirebaseUser(User? user) {
    if (user != null) {
      return Users(uid: user.uid);
    }
    return null;
  }

  //auth change user stream
  Stream<Users?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign w/ anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOutAnon() async {
    try {
      print("Success");
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in w/email and password
  Future signinwEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print("I am the user:$user");
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerwEmailandPassword(
      String email, String password, String role, String name, lastname) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      //create a new document for the user with the uid
      await DatabaseService(uid: user!.uid)
          .updateUserData(email, password, role);
      await DatabaseService(uid: user.uid).updateTutorData(name, lastname);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future addScheduleTimeavailable() async {
    try {
      //create a new document for the user with the uid
      await DatabaseService(uid: '93SBKEHBf8KJhZjE7vIeI')
          .addTutoravailbaleDays();
      return '93SBKEHBf8KJhZjE7vIeI';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  
  Future addDayoffs() async {
    try {
      //create a new document for the user with the uid
      await DatabaseService(uid: '93SBKEHBf8KJhZjE7vIeI')
          .addDayoffs();
      return '93SBKEHBf8KJhZjE7vIeI';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
