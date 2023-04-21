import 'package:flutter/foundation.dart';

class SearchTutorProvider with ChangeNotifier{
  String _tName = '';

  String get tName => _tName;

   void setSearch(String name){
    _tName = name;
    notifyListeners();
  }
}