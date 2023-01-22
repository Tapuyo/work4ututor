import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/constant/constant.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/routes/route_generator.dart';
import 'package:wokr4ututor/routes/routes.dart';
import 'package:wokr4ututor/ui/web/web_main.dart';
import 'package:wokr4ututor/utils/themes.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

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
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: firebaseApiKey,
        appId: firebaseAppId,
        messagingSenderId: firebaseMessagingSenderId,
        projectId: firebaseProjectId,
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
    return MaterialApp(
      builder: (context, child) {
        return kIsWeb ? const WebMainPage():ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
      title: 'Work4u',
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        platform: !kIsWeb ? TargetPlatform.iOS:TargetPlatform.fuchsia,
        scaffoldBackgroundColor: Colors.white,
        toggleableActiveColor: kColorPrimary,
        appBarTheme: const AppBarTheme(
          elevation: 1,
          color: Colors.white,
          iconTheme: IconThemeData(
            color: kColorPrimary,
          ),
          actionsIconTheme: IconThemeData(
            color: kColorPrimary,
          ),
          // ignore: deprecated_member_use
          textTheme: TextTheme(
            headline6: TextStyle(
              color: kColorDarkBlue,
              fontFamily: 'NunitoSans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        dividerColor: Colors.grey[300],
        textTheme: TextTheme(
          button: kTextStyleButton,
          subtitle1: kTextStyleSubtitle1.copyWith(color: kColorPrimaryDark),
          subtitle2: kTextStyleSubtitle2.copyWith(color: kColorPrimaryDark),
          bodyText2: kTextStyleBody2.copyWith(color: kColorPrimaryDark),
          headline6: kTextStyleHeadline6.copyWith(color: kColorPrimaryDark),
        ),
        iconTheme: const IconThemeData(
          color: kColorPrimary,
        ),
        fontFamily: 'NunitoSans',
        cardTheme: CardTheme(
          elevation: 0,
          color: const Color(0xffEBF2F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            //side: BorderSide(width: 1, color: Colors.grey[200]),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
