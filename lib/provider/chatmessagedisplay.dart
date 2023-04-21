import 'package:flutter/material.dart';

class ChatDisplayProvider with ChangeNotifier{
  bool _openMessage = false;

  bool get openMessage => _openMessage;

   void setOpenMessage(bool set){
    _openMessage = set;
    notifyListeners();
  }
}