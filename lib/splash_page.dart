import 'dart:async';

import 'package:flutter/material.dart';
import 'package:work4ututor/routes/routes.dart';

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
          width: 240,
          child: Image.asset(
            "assets/images/WORK4U_NO_BG.png",
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
