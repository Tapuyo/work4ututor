import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 70,
      padding: const EdgeInsets.fromLTRB(40, 0, 30, 10),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(1, 118, 132, 1),
        
      ),
      child: Row(
        children:  <Widget>[
          SizedBox(
            height: 180,
            width: 200,
            child: Image.asset(
              "assets/images/worklogo.png",
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
    
  }
}