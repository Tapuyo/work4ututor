import 'package:flutter/material.dart';

class MyModel extends ChangeNotifier {
  bool myBoolValue = false;

  bool get updateDisplay => myBoolValue;

  void updateBoolValue(bool newValue) {
    myBoolValue = newValue;
    notifyListeners(); // Notifies the listeners about the change
  }
}

class TutorInformationProvider extends ChangeNotifier {
  bool myBoolValue = false;

  bool get updateDisplay => myBoolValue;

  void updateBoolValue(bool newValue) {
    myBoolValue = newValue;
    notifyListeners(); // Notifies the listeners about the change
  }
}

class TutorInformationPricing extends ChangeNotifier {
  bool myBoolValue = false;

  bool get updateDisplay => myBoolValue;

  void updateBoolValue(bool newValue) {
    myBoolValue = newValue;
    notifyListeners(); // Notifies the listeners about the change
  }
}
