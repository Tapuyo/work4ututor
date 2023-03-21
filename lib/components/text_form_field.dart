import 'package:flutter/material.dart';
import 'package:wokr4ututor/utils/themes.dart';


class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool? obscureText;
  final bool? enabled;
  final Widget? suffixIcon;
  final bool? suffixIconTap;
  final String? error;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    required Key key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText,
    this.enabled,
    this.suffixIcon,
    this.suffixIconTap,
    this.error,
  }) : super(key: key);

  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;
  @override
  void initState() {
    _obscureText = widget.obscureText!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      controller: widget.controller,
      enabled: widget.enabled ?? true,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xffbcbcbc),
          fontFamily: 'NunitoSans',
        ),
        errorText: widget.error,
        suffixIcon: (widget.obscureText != null && widget.obscureText!)
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    size: 15,
                  ),
                ),
              )
            : widget.suffixIcon,
      ),
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xff575757),
        fontFamily: 'NunitoSans',
      ),
      cursorColor: kColorBlue,
      cursorWidth: 1,
    );
  }
}
