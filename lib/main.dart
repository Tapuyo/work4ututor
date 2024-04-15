// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:work4ututor/data_class/studentsEnrolledclass.dart';
import 'package:work4ututor/provider/displaystarred.dart';
import 'package:work4ututor/provider/init_provider.dart';
import 'package:work4ututor/provider/performacefilter.dart';
import 'package:work4ututor/provider/schedulenotifier.dart';
import 'package:work4ututor/provider/search_provider.dart';
import 'package:work4ututor/provider/update_tutor_provider.dart';
import 'package:work4ututor/provider/user_id_provider.dart';
import 'package:work4ututor/routes/routes.dart';
import 'package:work4ututor/services/addgetstarmessages.dart';
import 'package:work4ututor/services/addpreftutor.dart';
import 'package:work4ututor/services/getcart.dart';
import 'package:work4ututor/services/getcountries.dart';
import 'package:work4ututor/services/getlanguages.dart';
import 'package:work4ututor/services/getmyrating.dart';
import 'package:work4ututor/services/getstudentinfo.dart';
import 'package:work4ututor/services/services.dart';
import 'package:work4ututor/services/subjectServices.dart';
import 'package:work4ututor/splash_page.dart';
import 'package:work4ututor/ui/web/login/resetpassword.dart';
import 'package:work4ututor/ui/web/search_tutor/find_tutors.dart';
import 'package:work4ututor/ui/web/signup/tutor_information_signup.dart';

import 'constant/constant.dart';
import 'data_class/helpclass.dart';
import 'data_class/studentinfoclass.dart';
import 'data_class/subject_class.dart';
import 'data_class/tutor_info_class.dart';

import 'provider/chatmessagedisplay.dart';
import 'provider/classes_inquirey_provider.dart';
import 'provider/classinfo_provider.dart';
import 'provider/inquirydisplay_provider.dart';
import 'provider/studet_info_provider.dart';
import 'provider/tutor_reviews_provider.dart';
import 'services/gethelpcategory.dart';
import 'services/getmaterials.dart';
import 'ui/web/communication.dart/videocall.dart';
import 'ui/web/login/login.dart';
import 'ui/web/signup/student_information_signup.dart';
import 'ui/web/signup/student_signup.dart';
import 'ui/web/signup/tutor_signup.dart';
import 'ui/web/student/main_dashboard/student_dashboard.dart';
import 'ui/web/tutor/tutor_dashboard/tutor_dashboard.dart';
import 'ui/web/web_main.dart';

// Future<void> setup() async {
//   await tz.initializeTimeZone('packages/timezone/data/latest_all.tzf');
// }

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
    if (runas == 'dev') {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: firebaseConfig['apiKey'].toString(),
          appId: firebaseConfig['appId'].toString(),
          messagingSenderId: firebaseConfig['messagingSenderId'].toString(),
          projectId: firebaseConfig['projectId'].toString(),
          storageBucket: firebaseConfig['storageBucket'].toString(),
        ),
      );
    } else {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: firebaseApiKey,
          appId: firebaseAppId,
          messagingSenderId: firebaseMessagingSenderId,
          projectId: firebaseProjectId,
          storageBucket: storageBucket,
        ),
      );
    }
  } else {
    await Firebase.initializeApp();
  }

  await Hive.initFlutter();
  await Hive.openBox('userID');

  // Get.lazyPut(() => DashboardController());

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
      ChangeNotifierProvider(create: (_) => StarMessagesNotifier()),
      ChangeNotifierProvider(create: (_) => StarDisplayProvider()),
      ChangeNotifierProvider(create: (_) => RatingNotifier()),
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
      ChangeNotifierProvider(create: (_) => GotMessageProvider()),
      ChangeNotifierProvider(create: (_) => ViewClassDisplayProvider()),
      ChangeNotifierProvider(create: (_) => ClassesInquiryProvider()),
      ChangeNotifierProvider(create: (_) => IndividualReviewProvider()),
      ChangeNotifierProvider(create: (_) => StudentInfoProvider()),
      ChangeNotifierProvider(create: (_) => PreferredTutorsNotifier()),
      ChangeNotifierProvider(create: (_) => MaterialNotifier()),
      ChangeNotifierProvider(create: (_) => CartNotifier()),
      ChangeNotifierProvider(create: (_) => FilterPerformanceProvider()),
    ],
    child: const MyApp(),
  ));
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'account/student', // Define route with parameters
          builder: (context, state) {
            // Retrieve parameters
            return const StudentSignup();
          },
        ),
        GoRoute(
          path: 'account/tutor', // Define route with parameters
          builder: (context, state) {
            // Retrieve parameters
            return const TutorSignup();
          },
        ),
        GoRoute(
          path: 'account/reset', // Define route with parameters
          builder: (context, state) {
            // Retrieve parameters
            return const ResetPage();
          },
        ),
        GoRoute(
          path: 'tutorsignup/:uid', // Define route with parameters
          builder: (context, state) {
            final Map<String, String> params =
                state.pathParameters; // Retrieve parameters
            return TutorInfo(
              uid: params['uid'] ?? '',
              email: params['email'] ?? '',
            );
          },
        ),
        GoRoute(
          path: 'studentsignup/:uid', // Define route with parameters
          builder: (context, state) {
            final Map<String, String> params =
                state.pathParameters; // Retrieve parameters
            return StudentInfo(
              uid: params['uid'] ?? '',
              email: params['email'] ?? '',
            );
          },
        ),
        GoRoute(
          path: 'studentdiary/:uid', // Define route with parameters
          builder: (context, state) {
            final Map<String, String> params =
                state.pathParameters; // Retrieve parameters
            return StudentDashboardPage(
              uID: params['uid'] ?? '',
              email: params['email'] ?? '',
            );
          },
        ),
        GoRoute(
          path: 'studentdiary/:uid/tutors', // Define route with parameters
          builder: (
            context,
            state,
          ) {
            final Map<String, String> params =
                state.pathParameters; // Retrieve parameters
            return FindTutor(
              userid: params['uid'] ?? '',
            );
          },
        ),
        GoRoute(
          path: 'tutordesk/:uid', // Define route with parameters
          builder: (context, state) {
            final Map<String, String> params =
                state.pathParameters; // Retrieve parameters
            return DashboardPage(
              uID: params['uid'] ?? '',
            );
          },
        ),
        GoRoute(
          path: 'videocall/:uid&:cId&:chatId', // Define route with parameters
          builder: (context, state) {
            final Map<String, String> params =
                state.pathParameters; // Retrieve parameters
            return VideoCall(
              uID: params['uid'] ?? '',
              chatID: '',
              classId: '',
            );
          },
        ),
        GoRoute(
          path: 'webmain', // Define route with parameters
          builder: (context, state) {
            // Retrieve parameters
            return const WebMainPage();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Work4ututor',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Nunito",
        canvasColor: Colors.white,
        primarySwatch: Colors.indigo,
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
