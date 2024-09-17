import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../../data_class/user_class.dart';
import '../../services/services.dart';

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
      return null;
    }
  }

  Future signOutAnon() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  //sign in w/email and password
  Future signinwEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
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
      if (e
          .toString()
          .contains("The email address is already in use by another account")) {
        return e.toString();
      } else {
        return null;
      }
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
      if (e
          .toString()
          .contains("The email address is already in use by another account")) {
        return e.toString();
      } else {
        return null;
      }
    }
  }

  final _userinfo = Hive.box('userID');
  Future<void> adduserInfo(Map<String, dynamic> newData) async {
    await _userinfo.add(newData);
  }
}
