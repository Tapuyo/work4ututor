import 'package:flutter/material.dart';

import '../data_class/reviewclass.dart';
import '../services/classes_inquiry_service.dart';

class IndividualReviewProvider with ChangeNotifier {
  bool _onLoading = false;
  bool _isrefresh = false;

  List<ReviewModel> _reviews = [];

  List<ReviewModel> get reviews => _reviews;

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

  void setIndividualReviews(List<ReviewModel> value) {
    _reviews = value;
    notifyListeners();
  }

  void getReviews(BuildContext context, String userId) async{
    await IndividualReviews.getReviews(context, userId);
    notifyListeners();
  }
}
