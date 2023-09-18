// // ignore_for_file: avoid_print

// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:wokr4ututor/services/services.dart';
import '../../data_class/user_class.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on firebaseuser
  Future<UserData?> _userFromFirebaseUser(User? user) async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('user')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        UserData userData = _getUser(snapshot);
        return userData;
      }
    }
    return null;
  }

  UserData _getUser(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return UserData(
      email: data['email'] ?? '',
      status: data['status'] ?? '',
      role: data['role'] ?? '',
      uid: snapshot.id,
    );
  }

  //auth change user stream
  Stream<UserData?> get user {
    return _auth.authStateChanges().asyncMap(_userFromFirebaseUser);
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
      String email, String password, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      //create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).updateUserData(email, role);
      await DatabaseService(uid: user.uid).updateTutorData(email);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerwEmailandPasswordforStudent(
    String email,
    String password,
    String role,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      //create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).updateUserData(email, role);
      await DatabaseService(uid: user.uid).updateStudentData(email);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  final _userinfo = Hive.box('userID');
  Future<void> adduserInfo(Map<String, dynamic> newData) async {
    await _userinfo.add(newData);
    print('Saving Successful');
  }
}
