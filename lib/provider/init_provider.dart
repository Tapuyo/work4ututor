import 'package:flutter/foundation.dart';

class InitProvider with ChangeNotifier{
  bool refresh = false;

  int _menuIndex = 0;
  
  int get menuIndex => _menuIndex;

  bool get isRefresh => refresh;

 void billRefresh() {
    refresh = !refresh;
    notifyListeners();
  }

  void setMenuIndex(int value){
    _menuIndex = value;
    notifyListeners();
  }
}