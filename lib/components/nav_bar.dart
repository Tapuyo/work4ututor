import 'package:flutter/material.dart';
import 'package:wokr4ututor/constant/constant.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        // color: Colors.transparent,
        color: Color.fromARGB(255, 9, 93, 116),
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 150,
            width: 500,
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Image.asset(
              "assets/images/NewLogo3-removebg-preview.png",
              height: 25,
              alignment: Alignment.topCenter,
            ),
          ),
          // Text(
          //   "Foodi".toUpperCase(),
          //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          // ),
          Spacer(),

          // DefaultButton(
          //   text: "Get Started",
          //   press: () {},
          // ),
           TextButton(
    child: Text('About Us'),
    style: TextButton.styleFrom(
      primary: Colors.white,
      onSurface: Colors.white,
      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      // ignore: prefer_const_constructors
      textStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontStyle: FontStyle.normal,
          decoration: TextDecoration.underline,
      ),
    ),
    
    onPressed: () {
      print('Pressed');
    },
  ),
          const SizedBox(
            width: 100,
          )
        ],
      ),
    );
  }
}
