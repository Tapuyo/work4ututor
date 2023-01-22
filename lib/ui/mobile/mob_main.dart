import 'package:flutter/material.dart';

class MobMainPage extends StatefulWidget {
  const MobMainPage({Key? key}) : super(key: key);

  @override
  State<MobMainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MobMainPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  Center(child:  Text('Home mobile')),
    );
  }
}