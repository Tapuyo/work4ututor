import 'package:flutter/material.dart';

class DisplayedItemCountProvider with ChangeNotifier {
  int _displayedItemCount = 8;

  int get displayedItemCount => _displayedItemCount;

  void incrementDisplayedItemCount(int incrementBy) {
    _displayedItemCount += incrementBy;
    notifyListeners();
  }
}
