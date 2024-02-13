import 'dart:async';

import 'package:flutter/material.dart';
import 'package:work4ututor/routes/routes.dart';
import 'package:work4ututor/utils/themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 3),
        () => {
              Navigator.of(context).pushReplacementNamed(Routes.webMain),
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
