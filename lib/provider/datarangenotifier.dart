import 'package:flutter/material.dart';

class DateRangeNotifier extends ChangeNotifier {
  DateTimeRange? _selectedDateRange;

  DateTimeRange? get selectedDateRange => _selectedDateRange;

  void updateDateRange(DateTimeRange? dateRange) {
    _selectedDateRange = dateRange;
    notifyListeners();
  }
    void clearDateRange() {
    _selectedDateRange = null;
    notifyListeners();
  }
}
