import 'package:flutter/foundation.dart';

class InitProvider with ChangeNotifier{
  bool refresh = false;

  int _menuIndex = 0;
  int _listindex = 0;
  
  String _tName = '';
  
  int get menuIndex => _menuIndex;
   int get listIndex => _listindex;

  bool get isRefresh => refresh;
  String get tName => _tName;

 void billRefresh() {
    refresh = !refresh;
    notifyListeners();
  }

  void setMenuIndex(int value){
    _menuIndex = value;
    notifyListeners();
  }
   void setSearch(String name){
    _tName = name;
    notifyListeners();
  }
}