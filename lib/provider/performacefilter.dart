import 'package:flutter/material.dart';

class FilterPerformanceProvider with ChangeNotifier {
  DateTime? _fromdate;
  DateTime? _todate;

  DateTime? get fromdate => _fromdate;
  DateTime? get todate => _todate;

  void setFromDate(DateTime set) {
    _fromdate = set;
    notifyListeners();
  }

  void setToDate(DateTime set) {
    _todate = set;
    notifyListeners();
  }
}
