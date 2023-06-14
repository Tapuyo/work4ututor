import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wokr4ututor/splash_page.dart';
import 'package:wokr4ututor/ui/mobile/mob_main.dart';
import 'package:wokr4ututor/ui/web/search_tutor/find_tutors.dart';
import 'package:wokr4ututor/ui/web/signup/tutor_signup.dart';
import 'package:wokr4ututor/ui/web/web_main.dart';

import '../ui/web/tutor/tutor_profile/tutor_profile.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch (settings.name) {
      case Routes.splash:
        return CupertinoPageRoute(builder: (_) => const SplashPage());

      case Routes.mobMain:
        return CupertinoPageRoute(builder: (_) => const MobMainPage());

      case Routes.webMain:
        return CupertinoPageRoute(builder: (_) => const WebMainPage());

      case Routes.tutorSignup:
        return CupertinoPageRoute(builder: (_) => const TutorSignup());

      case Routes.tutorInfo:
        return CupertinoPageRoute(builder: (_) => const TutorProfile());

      case Routes.tutorList:
        return CupertinoPageRoute(builder: (_) => const FindTutor());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
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
