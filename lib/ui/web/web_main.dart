import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

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
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    final index = _items.length;
    if (index == 0) {
      // return const ScreenSharingWithSubProcess();
      // return const VideoCall(chatID: '', uID: '', classId: '1',);
      // return const FindTutor(
      //   userid: 'IiIJktktGfPS6oDhI5PWJFGt8e23',
      // );
      GoRouter.of(context).go('/signin');
      return Container();
    } else {
      debugPrint(index.toString());
      if (_items[0]['role'].toString() == 'student' &&
          _items[0]['userStatus'].toString() == 'unfinished') {
        GoRouter.of(context)
            .go('/studentsignup/${_items[0]['userID'].toString()}');
        return Container();
        // return StudentInfo(
        //   uid: _items[0]['userID'].toString(),
        //   email: _items[0]['email'].toString(),
        // );
        // return const VideoCall(chatID: '', uID: '',);
        // return const AdminLoginPage();
      } else if (_items[0]['role'].toString() == 'student' &&
          _items[0]['userStatus'].toString() == 'completed') {
        GoRouter.of(context)
            .go('/studentdiary/${_items[0]['userID'].toString()}');
        return Container();
        // return StudentDashboardPage(
        //   uID: _items[0]['userID'].toString(),
        //   email: _items[0]['email'].toString(),
        // );
        // return const VideoCall(chatID: '', uID: '',);
        // return const AdminLoginPage();
      } else if (_items[0]['role'].toString() == 'tutor' &&
          _items[0]['userStatus'].toString() == 'completed') {
        // return DashboardPage(uID: _items[0]['userID'].toString());
        GoRouter.of(context).go('/tutordesk/${_items[0]['userID'].toString()}');
        return Container();
      } else if (_items[0]['role'].toString() == 'tutor' &&
          _items[0]['userStatus'].toString() == 'unfinished') {
        // return TutorInfo(
        //   uid: _items[0]['userID'].toString(),
        //   email: _items[0]['email'].toString(),
        // );
        GoRouter.of(context)
            .go('/tutorsignup/${_items[0]['userID'].toString()}');
        return Container();
      } else {
        // return const FindTutor(
        //   userid: 'IiIJktktGfPS6oDhI5PWJFGt8e23',
        // );
        GoRouter.of(context).go('/signin');
        return Container();
        // return const VideoCall(chatID: '', uID: '',);
      }
    }
  }
}
