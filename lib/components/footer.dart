import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 56, 59, 60),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, -1),
            blurRadius: 30,
            color: const Color.fromARGB(255, 47, 35, 35).withOpacity(0.16),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          const Text(
            "work4ututor",
            style:  TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontStyle: FontStyle.normal,
                decoration: TextDecoration.none,
              ),
          ),
          const Spacer(),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              onSurface: Colors.white,
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              // ignore: prefer_const_constructors
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontStyle: FontStyle.normal,
                decoration: TextDecoration.none,
              ),
            ),

            onPressed: () {
            },
            child: const Text('About Us'),
          ),
        ],
      ),
    );
  }
}