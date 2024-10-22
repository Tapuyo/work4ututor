import 'package:flutter/material.dart';
import 'package:work4ututor/utils/themes.dart';

class HeaderText extends StatelessWidget {
  const HeaderText(this.data, {Key? key}) : super(key: key);

  final String data;
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: kColorGrey
      ),
    );
  }
}
