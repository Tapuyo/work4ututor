
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../splash_page.dart';
import '../ui/mobile/mob_main.dart';
import '../ui/web/admin/adminlogin.dart';
import '../ui/web/login/login.dart';
import '../ui/web/search_tutor/find_tutors.dart';
import '../ui/web/signup/student_signup.dart';
import '../ui/web/signup/tutor_signup.dart';
import '../ui/web/web_main.dart';
import 'routes.dart';

class RouteGenerator {
  static final _userinfo = Hive.box('userID');

  static String _getUserData() {
    final data = _userinfo.keys.map((key) {
      final item = _userinfo.get(key);
      return {
        "key": key,
        "userID": item["userID"],
        "role": item["role"],
        "userStatus": item["userStatus"]
      };
    }).toList();

    return data.isNotEmpty ? data.first['userID'] : {};
  }
   
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case Routes.mobMain:
        return MaterialPageRoute(builder: (_) => const MobMainPage());

      case Routes.webMain:
        return MaterialPageRoute(builder: (_) => const WebMainPage());

      case Routes.tutorSignup:
        return MaterialPageRoute(builder: (_) => const TutorSignup());

      case Routes.studentSignup:
        return MaterialPageRoute(builder: (_) => const StudentSignup());

      case Routes.adminLogin:
        return MaterialPageRoute(builder: (_) => const AdminLoginPage());

      case Routes.tutorList:
        return MaterialPageRoute(builder: (_) =>  FindTutor(userid: _getUserData(),));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
