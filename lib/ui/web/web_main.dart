import 'package:flutter/material.dart';

class WebMainPage extends StatefulWidget {
  const WebMainPage({Key? key}) : super(key: key);

  @override
  State<WebMainPage> createState() => _MainPageState();
}

class _MainPageState extends State<WebMainPage> {
  @override
  Widget build(BuildContext context) {

    return  Container(
      color: Colors.teal,
      child:  Text('Home Web'),
    );
  }
}