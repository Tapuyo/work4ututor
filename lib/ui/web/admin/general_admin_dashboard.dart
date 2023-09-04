// library dashboard;

// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:wokr4ututor/shared_components/responsive_builder.dart';
// import 'package:wokr4ututor/ui/web/admin/admin_components/user_profile.dart';
// import 'package:wokr4ututor/ui/web/admin/admin_sharedcomponents/card_task.dart';
// import 'package:wokr4ututor/ui/web/admin/admin_sharedcomponents/selection_button.dart';
// import 'package:wokr4ututor/ui/web/admin/helpers/app_helpers.dart';

// import '../../../constant/constant.dart';
// import '../student/main_dashboard/task_progress.dart';
// import 'admin_sharedcomponents/header_text.dart';
// import 'admin_sharedcomponents/list_task_assigned.dart';
// import 'admin_sharedcomponents/list_task_date.dart';
// import 'admin_sharedcomponents/search_field.dart';
// import 'admin_sharedcomponents/simple_selection_button.dart';
// import 'admin_sharedcomponents/simple_user_profile.dart';
// import 'package:get/get.dart';

// // binding
// part 'admin_bindings/admin_dashboard_bindings.dart';

// // controller
// part 'controllers/dashboard_controller.dart';

// part 'admin_components/member.dart';
// part 'admin_components/bottom_navbar.dart';
// part 'admin_components/task_menu.dart';
// part 'admin_components/weekly_task.dart';
// part 'admin_components/task_in_progress.dart';
// part 'admin_components/header_weekly_task.dart';
// part 'admin_components/task_group.dart';
// part 'admin_components/main_menu.dart';

// class ExecutiveDashboard extends GetView<DashboardController> {
//   const ExecutiveDashboard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: controller.scafoldKey,
//       drawer: ResponsiveBuilder.isDesktop(context)
//           ? null
//           : Drawer(
//               child: SafeArea(
//                 child: SingleChildScrollView(child: _buildSidebar(context)),
//               ),
//             ),
//       bottomNavigationBar: (ResponsiveBuilder.isDesktop(context) || kIsWeb)
//           ? null
//           : const _BottomNavbar(),
//       body: SafeArea(
//         child: ResponsiveBuilder(
//           mobileBuilder: (context, constraints) {
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTaskContent(
//                     onPressedMenu: () => controller.openDrawer(),
//                   ),
//                   _buildCalendarContent(),
//                 ],
//               ),
//             );
//           },
//           tabletBuilder: (context, constraints) {
//             return Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Flexible(
//                   flex: constraints.maxWidth > 800 ? 8 : 7,
//                   child: SingleChildScrollView(
//                     controller: ScrollController(),
//                     child: _buildTaskContent(
//                       onPressedMenu: () => controller.openDrawer(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height,
//                   child: const VerticalDivider(),
//                 ),
//                 Flexible(
//                   flex: 4,
//                   child: SingleChildScrollView(
//                     controller: ScrollController(),
//                     child: _buildCalendarContent(),
//                   ),
//                 ),
//               ],
//             );
//           },
//           desktopBuilder: (context, constraints) {
//             return Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Flexible(
//                   flex: constraints.maxWidth > 1350 ? 3 : 4,
//                   child: SingleChildScrollView(
//                     controller: ScrollController(),
//                     child: _buildSidebar(context),
//                   ),
//                 ),
//                 Flexible(
//                   flex: constraints.maxWidth > 1350 ? 10 : 9,
//                   child: SingleChildScrollView(
//                     controller: ScrollController(),
//                     child: _buildTaskContent(),
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height,
//                   child: const VerticalDivider(),
//                 ),
//                 Flexible(
//                   flex: 4,
//                   child: SingleChildScrollView(
//                     controller: ScrollController(),
//                     child: _buildCalendarContent(),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSidebar(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: UserProfile(
//             data: controller.dataProfil,
//             onPressed: controller.onPressedProfil,
//           ),
//         ),
//         const SizedBox(height: 15),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: _MainMenu(onSelected: controller.onSelectedMainMenu),
//         ),
//         const Divider(
//           indent: 20,
//           thickness: 1,
//           endIndent: 20,
//           height: 60,
//         ),
//         _Member(member: controller.member),
//         const SizedBox(height: kSpacing),
//         // _TaskMenu(
//         //   onSelected: controller.onSelectedTaskMenu,
//         // ),
//         // const SizedBox(height: kSpacing),
//         Padding(
//           padding: const EdgeInsets.all(kSpacing),
//           child: Text(
//             "2021 Work4uTutor License",
//             style: Theme.of(context).textTheme.bodySmall,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTaskContent({Function()? onPressedMenu}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: kSpacing),
//       child: Column(
//         children: [
//           const SizedBox(height: kSpacing),
//           Row(
//             children: [
//               if (onPressedMenu != null)
//                 Padding(
//                   padding: const EdgeInsets.only(right: kSpacing / 2),
//                   child: IconButton(
//                     onPressed: onPressedMenu,
//                     icon: const Icon(Icons.menu),
//                   ),
//                 ),
//               // Expanded(
//               //   child: SearchField(
//               //     onSearch: controller.searchTask,
//               //     hintText: "Search Task .. ",
//               //   ),
//               // ),
//             ],
//           ),
//           const SizedBox(height: kSpacing),
//           Row(
//             children: [
//               Expanded(
//                 child: HeaderText(
//                   DateTime.now().formatdMMMMY(),
//                 ),
//               ),
//               const SizedBox(width: kSpacing ),
//               SizedBox(
//                 width: 200,
//                 child: Text(
//                   "Graphical Presentations",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: kFontColorPallets[2],
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: kSpacing),
//           _TaskInProgress(data: controller.taskInProgress),
//           const SizedBox(height: kSpacing * 2),
//           const _HeaderWeeklyTask(),
//           const SizedBox(height: kSpacing),
//           _WeeklyTask(
//             data: controller.weeklyTask,
//             onPressed: controller.onPressedTask,
//             onPressedAssign: controller.onPressedAssignTask,
//             onPressedMember: controller.onPressedMemberTask,
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildCalendarContent() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: kSpacing),
//       child: Column(
//         children: [
//           const SizedBox(height: kSpacing),
//           Row(
//             children: [
//               const Expanded(child: HeaderText("Applicants")),
//               IconButton(
//                 onPressed: controller.onPressedCalendar,
//                 icon: const Icon(EvaIcons.calendarOutline),
//                 tooltip: "Schedule",
//               )
//             ],
//           ),
//           const SizedBox(height: kSpacing),
//           ...controller.applicants
//               .map(
//                 (e) => _TaskGroup(
//                   title: DateFormat('d MMMM').format(e[0].date),
//                   data: e,
//                   onPressed: controller.onPressedTaskGroup,
//                 ),
//               )
//               .toList()
//         ],
//       ),
//     );
//   }

//   // final scafoldKey = GlobalKey<ScaffoldState>();

//   // final dataProfil = const UserProfileData(
//   //   image: AssetImage("assets/images/man.png"),
//   //   name: "Rick",
//   //   jobDesk: "Executive Manager",
//   // );

//   // final member = ["Sarah Avelino", "Michael Greg"];

//   // final dataTask = const TaskProgressData(totalTask: 5, totalCompleted: 1);

//   // final taskInProgress = [
//   //   CardTaskData(
//   //     label: "Determine meeting schedule",
//   //     jobDesk: "System Analyst",
//   //     dueDate: DateTime.now().add(const Duration(minutes: 50)),
//   //   ),
//   //   CardTaskData(
//   //     label: "Personal branding",
//   //     jobDesk: "Marketing",
//   //     dueDate: DateTime.now().add(const Duration(hours: 4)),
//   //   ),
//   //   CardTaskData(
//   //     label: "UI UX",
//   //     jobDesk: "Design",
//   //     dueDate: DateTime.now().add(const Duration(days: 2)),
//   //   ),
//   //   CardTaskData(
//   //     label: "Determine meeting schedule",
//   //     jobDesk: "System Analyst",
//   //     dueDate: DateTime.now().add(const Duration(minutes: 50)),
//   //   )
//   // ];

//   // final weeklyTask = [
//   //   ListTaskAssignedData(
//   //     icon: const Icon(EvaIcons.monitor, color: Colors.blueGrey),
//   //     label: "Slicing UI",
//   //     jobDesk: "Programmer",
//   //     assignTo: "Alex Ferguso",
//   //     editDate: DateTime.now().add(-const Duration(hours: 2)),
//   //   ),
//   //   ListTaskAssignedData(
//   //     icon: const Icon(EvaIcons.star, color: Colors.amber),
//   //     label: "Personal branding",
//   //     jobDesk: "Marketing",
//   //     assignTo: "Justin Beck",
//   //     editDate: DateTime.now().add(-const Duration(days: 50)),
//   //   ),
//   //   const ListTaskAssignedData(
//   //     icon: Icon(EvaIcons.colorPalette, color: Colors.blue),
//   //     label: "UI UX ",
//   //     jobDesk: "Design",
//   //   ),
//   //   const ListTaskAssignedData(
//   //     icon: Icon(EvaIcons.pieChart, color: Colors.redAccent),
//   //     label: "Determine meeting schedule ",
//   //     jobDesk: "System Analyst",
//   //   ),
//   // ];

//   // final taskGroup = [
//   //   [
//   //     ListTaskDateData(
//   //       date: DateTime.now().add(const Duration(days: 2, hours: 10)),
//   //       label: "5 posts on instagram",
//   //       jobdesk: "Marketing",
//   //     ),
//   //     ListTaskDateData(
//   //       date: DateTime.now().add(const Duration(days: 2, hours: 11)),
//   //       label: "Platform Concept",
//   //       jobdesk: "Animation",
//   //     ),
//   //   ],
//   //   [
//   //     ListTaskDateData(
//   //       date: DateTime.now().add(const Duration(days: 4, hours: 5)),
//   //       label: "UI UX Marketplace",
//   //       jobdesk: "Design",
//   //     ),
//   //     ListTaskDateData(
//   //       date: DateTime.now().add(const Duration(days: 4, hours: 6)),
//   //       label: "Create Post For App",
//   //       jobdesk: "Marketing",
//   //     ),
//   //   ],
//   //   [
//   //     ListTaskDateData(
//   //       date: DateTime.now().add(const Duration(days: 6, hours: 5)),
//   //       label: "2 Posts on Facebook",
//   //       jobdesk: "Marketing",
//   //     ),
//   //     ListTaskDateData(
//   //       date: DateTime.now().add(const Duration(days: 6, hours: 6)),
//   //       label: "Create Icon App",
//   //       jobdesk: "Design",
//   //     ),
//   //     ListTaskDateData(
//   //       date: DateTime.now().add(const Duration(days: 6, hours: 8)),
//   //       label: "Fixing Error Payment",
//   //       jobdesk: "Programmer",
//   //     ),
//   //     ListTaskDateData(
//   //       date: DateTime.now().add(const Duration(days: 6, hours: 10)),
//   //       label: "Create Form Interview",
//   //       jobdesk: "System Analyst",
//   //     ),
//   //   ]
//   // ];

//   // void onPressedProfil() {}

//   // void onSelectedMainMenu(int index, SelectionButtonData value) {}
//   // void onSelectedTaskMenu(int index, String label) {}

//   // void searchTask(String value) {}

//   // void onPressedTask(int index, ListTaskAssignedData data) {}
//   // void onPressedAssignTask(int index, ListTaskAssignedData data) {}
//   // void onPressedMemberTask(int index, ListTaskAssignedData data) {}
//   // void onPressedCalendar() {}
//   // void onPressedTaskGroup(int index, ListTaskDateData data) {}

//   // void openDrawer() {
//   //   if (scafoldKey.currentState != null) {
//   //     scafoldKey.currentState!.openDrawer();
//   //   }
//   // }
// }
