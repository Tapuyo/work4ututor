import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wokr4ututor/ui/web/communication.dart/videocall.dart';
import 'package:wokr4ututor/ui/web/login/login.dart';
import 'admin/adminlogin.dart';
import 'tutor/tutor_dashboard/tutor_dashboard.dart';
import 'student/main_dashboard/student_dashboard.dart';

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
        "role": item["role"],
        "userStatus": item["userStatus"]
      };
    }).toList();
    setState(() {
      _items = data.toList();
      debugPrint(_items.length.toString());
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
      // return const VideoCall(chatID: '', uID: '',);
      return const LoginPage();
    } else {
      debugPrint(index.toString());
      if (_items[0]['role'].toString() == 'student') {
        return StudentDashboardPage(uID: _items[0]['userID'].toString());
        // return const VideoCall(chatID: '', uID: '',);
        // return const AdminLoginPage();
      } else if (_items[0]['role'].toString() == 'tutor') {
        return DashboardPage(uID: _items[0]['userID'].toString());
      } else {
        return const LoginPage();
      }
    }
  }
}
