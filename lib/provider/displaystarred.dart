import 'package:flutter/material.dart';

class StarDisplayProvider with ChangeNotifier{
  bool _openstarred = false;

  bool get openstarred => _openstarred;

   void setOpenstarred(bool set){
    _openstarred = set;
    notifyListeners();
  }
}