import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/constant/constant.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/routes/route_generator.dart';
import 'package:wokr4ututor/routes/routes.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:wokr4ututor/ui/auth/auth.dart';
import 'package:wokr4ututor/ui/web/login/login.dart';
import 'package:wokr4ututor/ui/web/signup/tutor_information_signup.dart';
import 'package:wokr4ututor/ui/web/student/main_dashboard/student_dashboard.dart';
import 'package:wokr4ututor/ui/web/terms/termpage.dart';
import 'package:wokr4ututor/ui/web/tutor/tutor_dashboard.dart';
import 'package:wokr4ututor/ui/web/web_main.dart';
import 'package:wokr4ututor/utils/themes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'data_class/user_class.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await setupFlutterNotifications();
}

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    usePathUrlStrategy();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: firebaseApiKey,
        appId: firebaseAppId,
        messagingSenderId: firebaseMessagingSenderId,
        projectId: firebaseProjectId,
        storageBucket: storageBucket,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => InitProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    //  StreamProvider<Users?>.value(
    //   value: AuthService().user,
    //   initialData: null,
    //   child:  
      MaterialApp(
        // builder: (context, child) {
        //   return kIsWeb ? const DashboardPage():ScrollConfiguration(
        //     behavior: MyBehavior(),
        //     child: child!,
        //   );
        // },
        title: 'Work4uTutor',
        initialRoute: Routes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        fontFamily: "Nunito",
        canvasColor: Colors.white,
        primarySwatch: Colors.indigo,
      ),
        home:  WebMainPage(),
      );
    // );
  }
}

class MyBehavior extends ScrollBehavior {

  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
