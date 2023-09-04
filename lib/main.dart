import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/constant/constant.dart';
import 'package:wokr4ututor/data_class/helpclass.dart';
import 'package:wokr4ututor/data_class/studentsEnrolledclass.dart';
import 'package:wokr4ututor/data_class/subject_class.dart';
import 'package:wokr4ututor/provider/chatmessagedisplay.dart';
import 'package:wokr4ututor/provider/classinfo_provider.dart';
import 'package:wokr4ututor/provider/classes_inquirey_provider.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/provider/inquirydisplay_provider.dart';
import 'package:wokr4ututor/provider/search_provider.dart';
import 'package:wokr4ututor/provider/tutor_reviews_provider.dart';
import 'package:wokr4ututor/provider/user_id_provider.dart';
import 'package:wokr4ututor/routes/route_generator.dart';
import 'package:wokr4ututor/routes/routes.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:wokr4ututor/services/classes_inquiry_service.dart';
import 'package:wokr4ututor/services/gethelpcategory.dart';
import 'package:wokr4ututor/services/services.dart';
import 'package:wokr4ututor/services/subjectServices.dart';
import 'package:wokr4ututor/splash_page.dart';
import 'package:wokr4ututor/ui/auth/auth.dart';
import 'package:wokr4ututor/ui/web/admin/executive_dashboard.dart';
import 'package:wokr4ututor/ui/web/login/login.dart';
import 'package:wokr4ututor/ui/web/student/main_dashboard/student_dashboard.dart';
import 'package:wokr4ututor/ui/web/student/search_tutor_login/find_tutors_login.dart';
import 'package:wokr4ututor/ui/web/tutor/tutor_profile/tutor_profile.dart';
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

  Get.lazyPut(() => DashboardController());
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => InitProvider()),
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
        value:
            DatabaseService(uid: 'YnLdZm2n7bPZSTbXS0VvHgG0Jor2').enrolleelist,
        initialData: const [],
      ),
      ChangeNotifierProvider(create: (_) => SearchTutorProvider()),
      ChangeNotifierProvider(create: (_) => UserIDProvider()),
      ChangeNotifierProvider(create: (_) => InquiryDisplayProvider()),
      ChangeNotifierProvider(create: (_) => ChatDisplayProvider()),
      ChangeNotifierProvider(create: (_) => ViewClassDisplayProvider()),
      ChangeNotifierProvider(create: (_) => ClassesInquiryProvider()),
      ChangeNotifierProvider(create: (_) => IndividualReviewProvider()),
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
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Nunito",
        canvasColor: Colors.white,
        primarySwatch: Colors.indigo,
      ),
    );
  }
}
