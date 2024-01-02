// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:work4ututor/data_class/studentsEnrolledclass.dart';
import 'package:work4ututor/provider/init_provider.dart';
import 'package:work4ututor/provider/schedulenotifier.dart';
import 'package:work4ututor/provider/search_provider.dart';
import 'package:work4ututor/provider/update_tutor_provider.dart';
import 'package:work4ututor/provider/user_id_provider.dart';
import 'package:work4ututor/services/getcountries.dart';
import 'package:work4ututor/services/getlanguages.dart';
import 'package:work4ututor/services/getstudentinfo.dart';
import 'package:work4ututor/services/services.dart';
import 'package:work4ututor/services/subjectServices.dart';

import 'constant/constant.dart';
import 'data_class/helpclass.dart';
import 'data_class/studentinfoclass.dart';
import 'data_class/subject_class.dart';
import 'data_class/tutor_info_class.dart';
import 'package:timezone/browser.dart' as tz;

import 'provider/chatmessagedisplay.dart';
import 'provider/classes_inquirey_provider.dart';
import 'provider/classinfo_provider.dart';
import 'provider/inquirydisplay_provider.dart';
import 'provider/studet_info_provider.dart';
import 'provider/tutor_reviews_provider.dart';
import 'routes/route_generator.dart';
import 'services/gethelpcategory.dart';
import 'ui/web/admin/executive_dashboard.dart';
import 'ui/web/web_main.dart';

Future<void> setup() async {
  await tz.initializeTimeZone('packages/timezone/data/latest_all.tzf');
}

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
  setup();
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

  Get.lazyPut(() => DashboardController());

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MultiProvider(
    providers: [
      StreamProvider<List<String>>(
        create: (_) => streamCountryNamesFromFirestore(),
        initialData: const [], // Initial data while the stream is initializing
      ),
      StreamProvider<List<LanguageData>>(
        create: (_) => streamLanguageNamesFromFirestore(),
        initialData: const [], // Initial data while the stream is initializing
      ),
      ChangeNotifierProvider(create: (_) => InitProvider()),
      ChangeNotifierProvider(create: (_) => MyModel()),
      ChangeNotifierProvider(create: (_) => TutorInformationProvider()),
      ChangeNotifierProvider(create: (_) => TutorInformationPricing()),
      ChangeNotifierProvider(create: (_) => ScheduleListNotifier()),
      StreamProvider<List<TutorInformation>>.value(
        value: DatabaseService(uid: '').tutorlist,
        initialData: const [],
      ),
      StreamProvider<List<Subjects>>.value(
        value: SubjectServices().subjectList,
        initialData: const [],
      ),
      StreamProvider<List<HelpCategory>>.value(
        value: HelpService().helplist,
        initialData: const [],
      ),
      StreamProvider<List<StudentsList>>.value(
        value: DatabaseService(uid: '').enrolleelist,
        initialData: const [],
      ),
      StreamProvider<List<StudentInfoClass>>.value(
        value: AllStudentInfoData().getallstudentinfo,
        catchError: (context, error) {
          return [];
        },
        initialData: const [],
      ),
      ChangeNotifierProvider(create: (_) => SearchTutorProvider()),
      ChangeNotifierProvider(create: (_) => UserIDProvider()),
      ChangeNotifierProvider(create: (_) => InquiryDisplayProvider()),
      ChangeNotifierProvider(create: (_) => ChatDisplayProvider()),
      ChangeNotifierProvider(create: (_) => ViewClassDisplayProvider()),
      ChangeNotifierProvider(create: (_) => ClassesInquiryProvider()),
      ChangeNotifierProvider(create: (_) => IndividualReviewProvider()),
      ChangeNotifierProvider(create: (_) => StudentInfoProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Work4uTutor',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Nunito",
        canvasColor: Colors.white,
        primarySwatch: Colors.indigo,
      ),
      home: const WebMainPage(),
    );
  }
}
