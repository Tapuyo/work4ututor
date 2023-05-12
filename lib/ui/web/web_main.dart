import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/ui/web/login/login.dart';
import 'package:wokr4ututor/ui/web/signup/tutor_information_signup.dart';

import '../../data_class/user_class.dart';
import '../../provider/user_id_provider.dart';
import 'tutor/tutor_dashboard/tutor_dashboard.dart';

class WebMainPage extends StatefulWidget {
  const WebMainPage({Key? key}) : super(key: key);

  @override
  State<WebMainPage> createState() => _MainPageState();
}

class _MainPageState extends State<WebMainPage> {
  final _userinfo = Hive.box('userID');
  List<Map<String, dynamic>> _items = [];
   _refreshItems() {
    final data = _userinfo.keys.map((key) {
      final item = _userinfo.get(key);
      return {
        "key": key,
        "userID": item["userID"],
        "userStatus": item["userStatus"]
      };
    }).toList();
    setState(() {
      _items = data.toList();
      print(_items.length);
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
//  final user = Provider.of<Users?>(context);
    final index = _items.length;
    if (index == 0) {
      return const LoginPage();
    } else {
      print(index);
      return DashboardPage();
    }
  }
}
