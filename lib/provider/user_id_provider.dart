import 'package:flutter/foundation.dart';

class UserIDProvider with ChangeNotifier{
  String _userID = '';

  String get userID => _userID;

   void setUserID(String name){
    _userID = name;
    notifyListeners();
  }
}