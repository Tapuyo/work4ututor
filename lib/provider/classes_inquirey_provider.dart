import 'package:flutter/material.dart';
import 'package:wokr4ututor/data_class/classes_inquiry_model.dart';
import 'package:wokr4ututor/services/classes_inquiry_service.dart';

class ClassesInquiryProvider with ChangeNotifier {
  bool _onLoading = false;
  bool _isrefresh = false;

  List<ClassesInquiryModel> _classesInquiry = [];

  List<ClassesInquiryModel> get classesInquiry => _classesInquiry;

  bool get onLoading => _onLoading;

  bool get isrefresh => _isrefresh;

  void setLoading(bool value) {
    _onLoading = value;
    notifyListeners();
  }

  void setRefresh(bool value) {
    _isrefresh = value;
    notifyListeners();
  }

  void setClassesInquiry(List<ClassesInquiryModel> value) {
    _classesInquiry = value;
    notifyListeners();
  }

  void getClassInquiry(BuildContext context, String userId) async{
    await ClassesInquiry.getClassesInquiry(context, userId);
    notifyListeners();
  }
}
