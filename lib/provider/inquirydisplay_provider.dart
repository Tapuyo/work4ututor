import 'package:flutter/material.dart';

class InquiryDisplayProvider with ChangeNotifier{
  bool _opeInquiry = false;

  bool get openDisplay => _opeInquiry;

   void setOpen(bool set){
    _opeInquiry = set;
    notifyListeners();
  }
}