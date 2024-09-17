import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:work4ututor/utils/themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
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
    _refreshItems();
    Timer(const Duration(seconds: 3), () {
      final index = _items.length;
      if (index == 0) {
        // GoRouter.of(context).go('/');
      } else {
        debugPrint(index.toString());
        if (_items[0]['role'].toString() == 'student' &&
            _items[0]['userStatus'].toString() == 'unfinished') {
          GoRouter.of(context)
              .go('/studentsignup/${_items[0]['userID'].toString()}');
        } else if (_items[0]['role'].toString() == 'student' &&
            _items[0]['userStatus'].toString() == 'completed') {
          Uri.base.toString().contains('/tutors')
              ? GoRouter.of(context)
                  .go('/studentdiary/${_items[0]['userID'].toString()}/tutors')
              : GoRouter.of(context)
                  .go('/studentdiary/${_items[0]['userID'].toString()}');
        } else if (_items[0]['role'].toString() == 'tutor' &&
            _items[0]['userStatus'].toString() == 'completed') {
          GoRouter.of(context)
              .go('/tutordesk/${_items[0]['userID'].toString()}');
        } else if (_items[0]['role'].toString() == 'tutor' &&
            _items[0]['userStatus'].toString() == 'unfinished') {
          GoRouter.of(context)
              .go('/tutorsignup/${_items[0]['userID'].toString()}');
        } else {
          GoRouter.of(context).go('/');
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          width: 40,
          height: 40,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kColorPrimary),
            strokeWidth: 5.0,
          ),
        ),
      ),
    );
  }
}
