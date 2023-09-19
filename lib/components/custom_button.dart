import 'package:flutter/material.dart';

import '../utils/themes.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double elevation;
  final double borderRadius;
  final EdgeInsets padding;
  final double textSize;

  const CustomButton({
    required Key key,
    required this.text,
    required this.onPressed,
    this.elevation = 0,
    this.borderRadius = 0,
    this.padding = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.textSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: elevation,
      fillColor: kColorBlue,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontSize:
                      textSize),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
