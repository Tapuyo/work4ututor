import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/ui/web/login/login.dart';

import '../../data_class/user_class.dart';
import 'tutor/tutor_dashboard/tutor_dashboard.dart';

class WebMainPage extends StatefulWidget {
  const WebMainPage({Key? key}) : super(key: key);

  @override
  State<WebMainPage> createState() => _MainPageState();
}

class _MainPageState extends State<WebMainPage> {
  @override
  Widget build(BuildContext context) {
//  final user = Provider.of<Users?>(context);
//      if(user == null){
//     return const LoginPage();
//    }else{
//     print( user );
//     return DashboardPage(uid: user.uid, name: "",);
//    }
return const LoginPage();
  }
}