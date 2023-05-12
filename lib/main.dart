import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/constant/constant.dart';
import 'package:wokr4ututor/data_class/studentsEnrolledclass.dart';
import 'package:wokr4ututor/provider/chatmessagedisplay.dart';
import 'package:wokr4ututor/provider/classinfo_provider.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/provider/inquirydisplay_provider.dart';
import 'package:wokr4ututor/provider/search_provider.dart';
import 'package:wokr4ututor/provider/user_id_provider.dart';
import 'package:wokr4ututor/routes/route_generator.dart';
import 'package:wokr4ututor/routes/routes.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:wokr4ututor/services/services.dart';
import 'package:wokr4ututor/ui/auth/auth.dart';
import 'package:wokr4ututor/ui/web/web_main.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'data_class/tutor_info_class.dart';
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

  await Hive.initFlutter();
  await Hive.openBox('userID');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => InitProvider()),
      StreamProvider<List<TutorInformation>>.value(
      value: DatabaseService(uid: '').tutorlist,
      initialData: const [],),
      StreamProvider<List<StudentsList>>.value(
      value: DatabaseService(uid: 'YnLdZm2n7bPZSTbXS0VvHgG0Jor2').enrolleelist,
      initialData: const [],),
      ChangeNotifierProvider(create: (_) => SearchTutorProvider()),
      ChangeNotifierProvider(create: (_) => UserIDProvider()),
      ChangeNotifierProvider(create: (_) => InquiryDisplayProvider()),
      ChangeNotifierProvider(create: (_) => ChatDisplayProvider()),
      ChangeNotifierProvider(create: (_) => ViewClassDisplayProvider()),
    ],
    child: const MyApp(),
  ));
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
     StreamProvider<Users?>.value(
      value: AuthService().user,
      initialData: null,
      child:  
      MaterialApp(
        // builder: (context, child) {
        //   return kIsWeb ? const DashboardPage():ScrollConfiguration(
        //     behavior: MyBehavior(),
        //     child: child!,
        //   );
        // },
        title: 'Work4uTutor',
        initialRoute: Routes.splash,
        // onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        fontFamily: "Nunito",
        canvasColor: Colors.white,
        primarySwatch: Colors.indigo,
      ),
        home: const WebMainPage(),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {

  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
