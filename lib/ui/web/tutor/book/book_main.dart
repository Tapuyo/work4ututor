import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/provider/init_provider.dart';


class BookMain extends HookWidget {
  const BookMain({Key? key}) : super(key: key);

  @override
   Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return  Container(
        height: size.height,
         width: size.width - 250,
        color: Colors.white,
      );
  }
}