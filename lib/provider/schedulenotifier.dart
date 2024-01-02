import 'package:flutter/foundation.dart';

import '../data_class/classesdataclass.dart';

class ScheduleListNotifier extends ChangeNotifier {
  List<ScheduleData> _scheduleList = [];

  List<ScheduleData> get scheduleList => _scheduleList;

  void setScheduleList(List<ScheduleData> newList) {
    _scheduleList = newList;
    notifyListeners();
  }
}
