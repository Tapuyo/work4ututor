import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectionNotifier extends ChangeNotifier {
  List<Map<String, dynamic>> _selectedItems = [];

  List<Map<String, dynamic>> get selectedItems => _selectedItems;

  void toggleSelection(Map<String, dynamic> item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
    } else {
      _selectedItems.add(item);
    }
    notifyListeners();
  }

  void selectAll(List<Map<String, dynamic>> items) {
    _selectedItems = items.where((item) {
      final disburseStatus = item['disburseStatus'] != 'Success';
      final adminReady = item['adminReady'] == false;
      final tutorStatus = item['tutorStatus'] == 'Completed';
      final daysDifference = DateTime.now()
                            .difference(DateFormat("yyyy-MM-dd HH:mm:ss.SSS")
                                .parse(item['dateclassFinished'], true)
                                .toLocal())
                            .inHours >
                        72;
      final studentStatus = item['studentStatus'] == 'Completed';

      return (disburseStatus && adminReady && tutorStatus && daysDifference) ||
          (disburseStatus && adminReady && tutorStatus && studentStatus);
    }).toList();

    notifyListeners();
  }

  void clearSelection() {
    _selectedItems.clear();
    notifyListeners();
  }

  bool isSelected(Map<String, dynamic> item) {
    return _selectedItems.contains(item);
  }

  bool isAllSelected(List<Map<String, dynamic>> items) {
    return _selectedItems.length == items.length;
  }
}
