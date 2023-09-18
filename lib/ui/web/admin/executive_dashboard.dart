// ignore_for_file: use_build_context_synchronously

library dashboard;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wokr4ututor/components/shared_popups/cancel_personal_account.dart';
import 'package:wokr4ututor/data_class/chatmessageclass.dart';
import 'package:wokr4ututor/data_class/classesdataclass.dart';
import 'package:wokr4ututor/data_class/studentanalyticsclass.dart';
import 'package:wokr4ututor/data_class/studentinfoclass.dart';
import 'package:wokr4ututor/data_class/user_class.dart';
import 'package:wokr4ututor/services/getenrolledclasses.dart';
import 'package:wokr4ututor/services/getmessages.dart';
import 'package:wokr4ututor/services/getstudentclassesanalytics.dart';
import 'package:wokr4ututor/services/getstudentinfo.dart';
import 'package:wokr4ututor/services/getuser.dart';
import 'package:wokr4ututor/shared_components/responsive_builder.dart';
import 'package:wokr4ututor/ui/web/admin/admin_components/user_profile.dart';
import 'package:wokr4ututor/ui/web/admin/admin_models/admin_model.dart';
import 'package:wokr4ututor/ui/web/admin/admin_sharedcomponents/assigned_task.dart';
import 'package:wokr4ututor/ui/web/admin/admin_sharedcomponents/card_task.dart';
import 'package:wokr4ututor/ui/web/admin/admin_sharedcomponents/rejected.dart';
import 'package:wokr4ututor/ui/web/admin/admin_sharedcomponents/selection_button.dart';
import 'package:wokr4ututor/ui/web/admin/admin_sharedcomponents/view_tutorinfo.dart';
import 'package:wokr4ututor/ui/web/admin/admin_views/admin_view_students.dart';
import 'package:wokr4ututor/ui/web/admin/helpers/app_helpers.dart';
import 'package:wokr4ututor/ui/web/admin/internal_data/internal_confirmation.dart';
import 'package:wokr4ututor/ui/web/admin/messages/admin_messages.dart';
import 'package:wokr4ututor/ui/web/admin/my_admins/add_admin.dart';
import 'package:wokr4ututor/ui/web/admin/my_admins/admin_archievelist.dart';
import 'package:wokr4ututor/ui/web/admin/my_admins/admin_list.dart';
import 'package:wokr4ututor/ui/web/admin/reports/mini_info_reports.dart';
import 'package:wokr4ututor/ui/web/admin/reports/report_charts.dart';
import 'package:wokr4ututor/ui/web/admin/subjects/view_new_subjects.dart';
import 'package:wokr4ututor/ui/web/admin/subjects/view_subject.dart';
import 'package:wokr4ututor/ui/web/tutor/mesages/message_main.dart';
import 'package:wokr4ututor/ui/web/tutor/mesages/messages.dart';
import 'package:wokr4ututor/utils/themes.dart';

import '../../../constant/constant.dart';
import '../../../provider/init_provider.dart';
import '../student/main_dashboard/task_progress.dart';
import '../tutor/tutor_profile/tutor_profile.dart';
import 'admin_sharedcomponents/add_interview_schedule.dart';
import 'admin_sharedcomponents/header_text.dart';
import 'admin_sharedcomponents/list_task_assigned.dart';
import 'admin_sharedcomponents/list_task_date.dart';
import 'admin_sharedcomponents/simple_selection_button.dart';
import 'admin_sharedcomponents/simple_user_profile.dart';
import 'package:get/get.dart';

// binding
part 'admin_bindings/admin_dashboard_bindings.dart';

// controller
part 'controllers/dashboard_controller.dart';

part 'admin_components/member.dart';
part 'admin_components/bottom_navbar.dart';
part 'admin_components/task_menu.dart';
part 'admin_components/weekly_task.dart';
part 'admin_components/task_in_progress.dart';
part 'admin_components/header_weekly_task.dart';
part 'admin_components/task_group.dart';
part 'admin_components/main_menu.dart';
part 'subjects/subjects_list.dart';
part 'subjects/new_subjects.dart';

class AdminPage extends StatefulWidget {
  final String uID;
  const AdminPage({super.key, required this.uID});
  @override
  State<AdminPage> createState() => _AdminPageState();
}

final _userinfo = Hive.box('userID');
List<Map<String, dynamic>> _items = [];
String firstname = '';
String middlename = '';
String lastname = '';
String fullName = '';
String studentID = '';
String profileurl = '';

bool _showModal = false;
GlobalKey _buttonKey = GlobalKey();
int newmessagecount = 0;
int newnotificationcount = 0;

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        // StreamProvider<List<StudentsList>>.value(
        //   value: DatabaseService(uid: '').enrolleelist,
        //   catchError: (context, error) {
        //     print('Error occurred: $error');
        //     return [];
        //   },
        //   initialData: const [],
        // ),
        StreamProvider<List<ChatMessage>>.value(
          value: GetMessageList(uid: widget.uID, role: '').getmessageinfo,
          catchError: (context, error) {
            print('Error occurred: $error');
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<StudentInfoClass>>.value(
          value: StudentInfoData(uid: 'XuQyf7S8gCOJBu6gTIb0').getstudentinfo,
          catchError: (context, error) {
            print('Error occurred: $error');
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<StudentGuardianClass>>.value(
          value: StudentGuardianData(uid: 'XuQyf7S8gCOJBu6gTIb0').guardianinfo,
          catchError: (context, error) {
            print('Error occurred: $error');
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<UserData>>.value(
          value: GetUsersData(uid: 'UhcbNwFHdQbclzdU2eC9NeIeziF2').getUserinfo,
          catchError: (context, error) {
            print('Error occurred: $error');
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<ClassesData>>.value(
          value: EnrolledClass(uid: 'XuQyf7S8gCOJBu6gTIb0', role: 'student')
              .getenrolled,
          catchError: (context, error) {
            // Handle the error here
            print('Error occurred: $error');
            // Return a default value or an alternative stream
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<STUanalyticsClass>>.value(
          value: StudentAnalytics(uid: 'XuQyf7S8gCOJBu6gTIb0').studentanalytics,
          catchError: (context, error) {
            // Handle the error here
            print('Error occurred: $error');
            // Return a default value or an alternative stream
            return [];
          },
          initialData: const [],
        )
      ],
      child: ExecutiveDashboard(),
    );
  }
}

class ExecutiveDashboard extends GetView<DashboardController> {
  ExecutiveDashboard({Key? key}) : super(key: key);
  final CollectionReference _drawingsCollection =
      FirebaseFirestore.instance.collection('drawings');

  bool select = false;
  DateTime? _fromselectedDate;
  DateTime? _toselectedDate;
  String actionValue = 'View';
  String dropdownValue = 'English';
  String statusValue = 'All';
  bool showApplicants = true;

  @override
  Widget build(BuildContext context) {
    final int menuIndex = context.select((InitProvider p) => p.menuIndex);
    return Scaffold(
      key: controller.scafoldKey,
      drawer: ResponsiveBuilder.isDesktop(context)
          ? null
          : Drawer(
              child: SafeArea(
                child: SingleChildScrollView(child: _buildSidebar(context)),
              ),
            ),
      bottomNavigationBar: (ResponsiveBuilder.isDesktop(context) || kIsWeb)
          ? null
          : const _BottomNavbar(),
      body: SafeArea(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTaskContent(
                    onPressedMenu: () => controller.openDrawer(),
                  ),
                  _buildCalendarContent(),
                ],
              ),
            );
          },
          tabletBuilder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: constraints.maxWidth > 800 ? 8 : 7,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: _buildTaskContent(
                      onPressedMenu: () => controller.openDrawer(),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const VerticalDivider(),
                ),
                Flexible(
                  flex: 4,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: _buildCalendarContent(),
                  ),
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: constraints.maxWidth > 1350 ? 3 : 4,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: _buildSidebar(context),
                  ),
                ),
                if (menuIndex == 0) ...[
                  Flexible(
                    flex: constraints.maxWidth > 1350 ? 10 : 9,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: _buildTaskContent(),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const VerticalDivider(),
                  ),
                  Flexible(
                    flex: 4,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: _buildCalendarContent(),
                    ),
                  ),
                ] else if (menuIndex == 1) ...[
                  Flexible(
                    flex: constraints.maxWidth > 1350 ? 14 : 13,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: _buildMessages(),
                    ),
                  ),
                ] else if (menuIndex == 2) ...[
                  Flexible(
                    flex: constraints.maxWidth > 1350 ? 14 : 13,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: _buildInternalaccess(),
                    ),
                  ),
                ] else if (menuIndex == 3) ...[
                  Flexible(
                    flex: constraints.maxWidth > 1350 ? 10 : 9,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: _buildSubjectsContent(),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const VerticalDivider(),
                  ),
                  Flexible(
                    flex: 4,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: _buildNewSubjects(),
                    ),
                  ),
                ] else if (menuIndex == 4) ...[
                  Obx(
                    () => Flexible(
                      flex: controller.openNew.value
                          ? constraints.maxWidth > 1350
                              ? 9
                              : 8
                          : constraints.maxWidth > 1350
                              ? 13
                              : 12,
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        child: _buildTutorslist(context),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const VerticalDivider(),
                  ),
                  Obx(
                    () => Flexible(
                      flex: controller.openNew.value ? 5 : 0,
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        child: _buildNewApplicantsTutorslist(context),
                      ),
                    ),
                  ),
                ] else if (menuIndex == 5) ...[
                  Flexible(
                    flex: constraints.maxWidth > 1350 ? 14 : 13,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: _buildStuentslist(context),
                    ),
                  ),
                ] else if (menuIndex == 6) ...[
                  Flexible(
                    flex: constraints.maxWidth > 1350 ? 14 : 13,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: _buildAdminList(context),
                    ),
                  ),
                ] else if (menuIndex == 7) ...[
                  Flexible(
                    flex: constraints.maxWidth > 1350 ? 14 : 13,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: _buildReports(),
                    ),
                  ),
                ] else ...[
                  Flexible(
                    flex: constraints.maxWidth > 1350 ? 14 : 13,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: _buildMessages(),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: UserProfile(
            data: controller.dataProfil,
            onPressed: controller.onPressedProfil,
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _MainMenu(onSelected: onSelectedMainMenu),
        ),
        const Divider(
          indent: 20,
          thickness: 1,
          endIndent: 20,
          height: 60,
        ),
        Obx(() {
          if (controller.adminsList.value.isNotEmpty) {
            return _Member(member: controller.adminsList.value);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
        const SizedBox(height: kSpacing),
        // _TaskMenu(
        //   onSelected: controller.onSelectedTaskMenu,
        // ),
        // const SizedBox(height: kSpacing),
        Padding(
          padding: const EdgeInsets.all(kSpacing),
          child: SelectableText (
            "2023 Work4uTutor License",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  void onSelectedMainMenu(
    int index,
    SelectionButtonData value,
  ) {}

  Widget _buildTaskContent({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing),
          Row(
            children: [
              if (onPressedMenu != null)
                Padding(
                  padding: const EdgeInsets.only(right: kSpacing / 2),
                  child: IconButton(
                    onPressed: onPressedMenu,
                    icon: const Icon(Icons.menu),
                  ),
                ),
            ],
          ),
          const SizedBox(height: kSpacing),
          Row(
            children: [
              Expanded(
                child: HeaderText(
                  DateTime.now().formatdMMMMY(),
                ),
              ),
              const SizedBox(width: kSpacing),
              SizedBox(
                width: 200,
                child: Text(
                  "Users Presentations",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kFontColorPallets[2],
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpacing),
          _TaskInProgress(data: controller.taskInProgress),
          const SizedBox(height: kSpacing * 2),
          const _HeaderWeeklyTask(),
          const SizedBox(height: kSpacing),
          Obx(() {
            if (controller.adminsList.value.isNotEmpty) {
              return _WeeklyTask(
                data: controller.taskList.value,
                onPressed: controller.onPressedTask,
                onPressedAssign: controller.onPressedAssignTask,
                onPressedMember: controller.onPressedMemberTask,
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey.withOpacity(.1),
                      ),
                      child: const Icon(
                        EvaIcons.clipboardOutline,
                        color: Colors.red,
                        size: 80,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'No Task Available',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing * 2),
          Row(
            children: const [
              Expanded(
                child: HeaderText(
                  'Admin Communication',
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Expanded(
                child: AdminMessagePage(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInternalaccess() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Expanded(
                child: InternalAccess(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing),
          Row(
            children: [
              const Expanded(child: HeaderText("Applicants")),
              IconButton(
                onPressed: controller.onPressedCalendar,
                icon: const Icon(EvaIcons.calendarOutline),
                tooltip: "Schedule",
              )
            ],
          ),
          const SizedBox(height: kSpacing),
          ...controller.applicants
              .map(
                (e) => _TaskGroup(
                  title: DateFormat('d MMMM').format(e[0].date),
                  data: e,
                  onPressed: controller.onPressedTaskGroup,
                ),
              )
              .toList()
        ],
      ),
    );
  }

  Widget _buildAdminList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing * 2),
          Row(
            children: [
              const Expanded(child: HeaderText("Administration")),
              ElevatedButton(
                onPressed: () {
                  controller.openArchieveAdmin.value =
                      !controller.openArchieveAdmin.value;
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey[850],
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: Obx(() {
                  return Text(controller.openArchieveAdmin.value
                      ? "Show Archived"
                      : 'Show Active');
                }),
              ),
              IconButton(
                onPressed: () {
                  showAddadmin(context);
                },
                icon: const Icon(EvaIcons.personAddOutline),
                tooltip: "Add",
              )
            ],
          ),
          const SizedBox(height: kSpacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Obx(() {
                  return controller.openArchieveAdmin.value
                      ? AdminList()
                      : const ArchieveAdminList();
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTutorslist(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing),
          Row(
            children: [
              const Expanded(
                child: HeaderText(
                  "Tutor Profiles",
                ),
              ),
              const SizedBox(width: kSpacing),
              SizedBox(
                width: 200,
                child: Text(
                  "",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kFontColorPallets[2],
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpacing),
          Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(kSpacing / 2),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Date Sign:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black45,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 95,
                          child: Text(
                            _fromselectedDate == null
                                ? 'From'
                                : DateFormat.yMMMMd()
                                    .format(_fromselectedDate!),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // _pickDateDialog();
                          },
                          child: const Icon(
                            Icons.calendar_month,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black45,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 95,
                          child: Text(
                            _toselectedDate == null
                                ? 'To'
                                : DateFormat.yMMMMd().format(_toselectedDate!),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // _pickDateDialog();
                          },
                          child: const Icon(
                            Icons.calendar_month,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Status:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    width: 150,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black45,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      elevation: 10,
                      value: statusValue,
                      onChanged: (statValue) {
                        statusValue = statValue!;
                      },
                      underline: Container(),
                      items: <String>[
                        'All',
                        'Subscribed',
                        'Unsubscribed',
                        'Cancelled',
                      ].map<DropdownMenuItem<String>>((String value1) {
                        return DropdownMenuItem<String>(
                          value: value1,
                          child: Container(
                            width: 110,
                            child: Text(
                              value1,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "TIN Number:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    width: 300,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black45,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 16),
                        hintText: 'Example: TTR*********',
                        border: InputBorder.none,
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter firstname' : null,
                      onChanged: (val) {
                        // adminname = val;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kColorPrimary,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: () {},
                      child: const Text('Search'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 10,
              right: 10,
              bottom: 8.0,
            ),
            child: DataTable(
              horizontalMargin: 0,
              columnSpacing: kSpacing / 2,
              dividerThickness: 1.0, // Adjust the thickness of column lines
              dataRowHeight: 50.0,
              columns: const [
                DataColumn(
                  label: Text(
                    "Tutor Name",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Date Sign",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Status",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "TIN Number",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Classes",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Actions",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
              rows: List.generate(
                0,
                (index) => recentUserDataRow(
                    controller.studentlist.value[index], context, index),
              ),
            ),
          ),
          const SizedBox(
            child: Divider(
              height: 1,
              thickness: 2,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('tutor').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No tutors available.'));
                } else {
                  final tutorslist = snapshot.data!.docs;
                  return SizedBox(
                    width: size.width - 500,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: tutorslist.length,
                      itemBuilder: (context, index) {
                        final tutorsinfo = tutorslist[index];
                        String tempimage = '';
                        return Scrollbar(
                          thumbVisibility: true,
                          controller: ScrollController(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: ScrollController(),
                            physics: const BouncingScrollPhysics(),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const TutorProfile(
                                            namex: '',
                                          )),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    color: (index % 2 == 0)
                                        ? Colors.white
                                        : Colors.grey[200],
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 10,
                                        right: 10,
                                        bottom: 5.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  tempimage.toString(),
                                                ),
                                                radius: 25,
                                              ),
                                              title: Text(
                                                '${(tutorsinfo['firstName'])}${(tutorsinfo['middleName'] == 'N/A' ? '' : ' ${(tutorsinfo['middleName'])}')} ${(tutorsinfo['lastName'])}',
                                                // 'Name',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              subtitle: Text(
                                                tutorsinfo['country'],
                                                // 'Country',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              DateFormat('MMMM dd, yyyy')
                                                  .format(tutorsinfo['dateSign']
                                                      .toDate())
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          // SizedBox(
                                          //   width: 150,
                                          //   height: 40,
                                          //   child: ElevatedButton.icon(
                                          //     icon: const Icon(
                                          //       EvaIcons.externalLinkOutline,
                                          //       color: Colors.white,
                                          //       size: 16,
                                          //     ),
                                          //     onPressed: () {
                                          //       // showAddschedule(context, data);
                                          //     },
                                          //     style: ElevatedButton.styleFrom(
                                          //       foregroundColor:
                                          //           Colors.grey[850],
                                          //       backgroundColor: Colors.blue,
                                          //       shape: RoundedRectangleBorder(
                                          //         borderRadius:
                                          //             BorderRadius.circular(20),
                                          //       ),
                                          //       elevation: 0,
                                          //     ),
                                          //     label: const Text(
                                          //       "Open Subjects",
                                          //       style: TextStyle(
                                          //           color: Colors.white),
                                          //     ),
                                          //   ),
                                          // ),
                                          // const SizedBox(
                                          //   width: 10,
                                          // ),
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              tutorsinfo['status'],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: 150,
                                            height: 40,
                                            child: ElevatedButton.icon(
                                              icon: const Icon(
                                                EvaIcons.externalLinkOutline,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              onPressed: () {
                                                // showAddschedule(context, data);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor:
                                                    Colors.grey[850],
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                elevation: 0,
                                              ),
                                              label: const Text(
                                                "Open Classes",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) => const TutorProfile(
                                              //             namex: '',
                                              //           )),
                                              // );
                                              showTutor(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.grey[850],
                                              backgroundColor: Colors.grey[100],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: const Text("View"),
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              width: 150,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black45,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.white,
                                              ),
                                              child: DropdownButton<String>(
                                                elevation: 10,
                                                value: statusValue,
                                                onChanged: (statValue) {
                                                  statusValue = statValue!;
                                                },
                                                underline: Container(),
                                                items: <String>[
                                                  'All',
                                                  'Blocked',
                                                  'Unblocked',
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value1) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value1,
                                                    child: Container(
                                                      width: 110,
                                                      child: Text(
                                                        value1,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    height: 1,
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

  Widget _buildNewApplicantsTutorslist(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: controller.onPressedshow,
                icon: const Icon(EvaIcons.calendarOutline),
                tooltip: "Scheduled Applicants",
              )
            ],
          ),
          Obx(
            () => Visibility(
              visible: controller.openNew.value,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 2,
                    child: Column(
                      children: [
                        const SizedBox(height: kSpacing),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Expanded(
                              child: HeaderText(
                                "New Applicants",
                              ),
                            ),
                            // IconButton(
                            //   onPressed: () {
                            //     showApplicants = !showApplicants;
                            //   },
                            //   icon: const Icon(EvaIcons.calendarOutline),
                            //   tooltip: "Scheduled Applicants",
                            // )
                          ],
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('tutor')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Center(
                                  child: Text('No tutors available.'));
                            } else {
                              final tutorslist = snapshot.data!.docs;
                              return SizedBox(
                                width: size.width - 1000,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: tutorslist.length,
                                  itemBuilder: (context, index) {
                                    final tutorsinfo = tutorslist[index];
                                    String tempimage = '';

                                    if (tutorsinfo['status'] == 'new') {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const TutorProfile(
                                                namex: '',
                                              ),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 10,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 200,
                                                    child: ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                          tempimage.toString(),
                                                        ),
                                                        radius: 25,
                                                      ),
                                                      title: Text(
                                                        '${tutorsinfo['firstName']}${tutorsinfo['middleName'] == 'N/A' ? '' : ' ${tutorsinfo['middleName']}'} ${tutorsinfo['lastName']}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      subtitle: Text(
                                                        tutorsinfo['country'],
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  _buildNewApplicantsbutton(
                                                      context, tutorsinfo),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 1,
                                              thickness: 1,
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      // Return an empty container for items with status other than "new"
                                      return Container();
                                    }
                                  },
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  _buildScheduleApplicantsContent()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStuentslist(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing),
          Row(
            children: [
              const Expanded(
                child: HeaderText(
                  "Student Profiles",
                ),
              ),
              const SizedBox(width: kSpacing),
              SizedBox(
                width: 200,
                child: Text(
                  "",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kFontColorPallets[2],
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpacing),
          Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(kSpacing / 2),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Date Sign:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black45,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 95,
                          child: Text(
                            _fromselectedDate == null
                                ? 'From'
                                : DateFormat.yMMMMd()
                                    .format(_fromselectedDate!),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // _pickDateDialog();
                          },
                          child: const Icon(
                            Icons.calendar_month,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black45,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 95,
                          child: Text(
                            _toselectedDate == null
                                ? 'To'
                                : DateFormat.yMMMMd().format(_toselectedDate!),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // _pickDateDialog();
                          },
                          child: const Icon(
                            Icons.calendar_month,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "SIN Number:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    width: 300,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black45,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 16),
                        hintText: 'Example: STU*********',
                        border: InputBorder.none,
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter firstname' : null,
                      onChanged: (val) {
                        // adminname = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kColorPrimary,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: () {},
                      child: const Text('Search'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 10,
                right: 10,
                bottom: 8.0,
              ),
              child: Obx(() {
                return DataTable(
                  horizontalMargin: 0,
                  columnSpacing: kSpacing / 2,
                  dividerThickness: 1.0, // Adjust the thickness of column lines
                  dataRowHeight: 50.0,
                  columns: const [
                    DataColumn(
                      label: Text(
                        "Student Name",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Country",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "E-mail",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "SIN Number",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Contact",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Date Registered",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Option",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                  rows: List.generate(
                    controller.studentlist.value.length,
                    (index) => recentUserDataRow(
                        controller.studentlist.value[index], context, index),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewApplicantsbutton(
      BuildContext context, QueryDocumentSnapshot<Object?> tutorsinfo) {
    Map<String, dynamic> data = tutorsinfo.data() as Map<String, dynamic>;

    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => const TutorProfile(
            //             namex: '',
            //           )),
            // );
            showTutor(context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey[850],
            backgroundColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          child: const Text("View"),
        ),
        const SizedBox(width: 5),
        ElevatedButton.icon(
          icon: const Icon(
            EvaIcons.plus,
            color: Colors.white,
            size: 16,
          ),
          onPressed: () {
            showAddschedule(context, data);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey[850],
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          label: const Text(
            "Schedule",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduledApplicantsbutton() {
    String _selectedValue = 'Status';
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey[850],
            backgroundColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          child: const Text("View"),
        ),
        const SizedBox(width: 5),
        DropdownButton<String>(
          value: _selectedValue,
          onChanged: (newValue) {
            _selectedValue = newValue!;
          },
          items: <String>['Status', 'Approve', 'Reject']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScheduleApplicantsContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing),
          Row(
            children: const [
              Expanded(child: HeaderText("Scheduled Applicants")),
              // IconButton(
              //   onPressed: controller.onPressedCalendar,
              //   icon: const Icon(EvaIcons.calendarOutline),
              //   tooltip: "Scheduled Applicants",
              // )
            ],
          ),
          const SizedBox(height: kSpacing),
          ...controller.applicants
              .map(
                (e) => _TaskGroup(
                  title: DateFormat('d MMMM').format(e[0].date),
                  data: e,
                  onPressed: controller.onPressedTaskGroup,
                ),
              )
              .toList()
        ],
      ),
    );
  }

  void showAddschedule(BuildContext context, Map<String, dynamic> tutorsinfo) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return SizedBox(
                    height: height - 200,
                    width: 500,
                    child: AddSchedule(
                      onDataReceived: tutorsinfo,
                    ),
                  );
                },
              ),
            ));
  }

  void showTutor(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return SizedBox(
                    height: height,
                    width: width - 400,
                    child: const ViewTutorsData(
                      namex: '',
                    ),
                  );
                },
              ),
            ));
  }

  Widget _buildSubjectsContent({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing),
          Row(
            children: [
              if (onPressedMenu != null)
                Padding(
                  padding: const EdgeInsets.only(right: kSpacing / 2),
                  child: IconButton(
                    onPressed: onPressedMenu,
                    icon: const Icon(Icons.menu),
                  ),
                ),
            ],
          ),
          const SizedBox(height: kSpacing),
          Row(
            children: const [
              Expanded(
                child: HeaderText(
                  "Subjects",
                ),
              ),
            ],
          ),
          Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(kSpacing / 2),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Subject Name:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    width: 200,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black45,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none, // This removes the underline
                        hintText: 'Enter subject...',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kColorPrimary,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: () {},
                      child: const Text('Search'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: kSpacing),
          const _Subjects(),
        ],
      ),
    );
  }

  Widget _buildNewSubjects({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing),
          Row(
            children: [
              if (onPressedMenu != null)
                Padding(
                  padding: const EdgeInsets.only(right: kSpacing / 2),
                  child: IconButton(
                    onPressed: onPressedMenu,
                    icon: const Icon(Icons.menu),
                  ),
                ),
            ],
          ),
          const SizedBox(height: kSpacing),
          Row(
            children: [
              const Expanded(
                child: HeaderText(
                  "New Subjects",
                ),
              ),
              IconButton(
                onPressed: controller.onPressedCalendar,
                icon: const Icon(EvaIcons.folderAddOutline),
                tooltip: "Add",
              )
            ],
          ),
          const SizedBox(height: kSpacing),
          const _NewSubjects(),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing),
          Row(
            children: [
              const Expanded(
                child: HeaderText(
                  "Student Profiles",
                ),
              ),
              const SizedBox(width: kSpacing),
              SizedBox(
                width: 200,
                child: Text(
                  "",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kFontColorPallets[2],
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpacing),
          Card(
            elevation: 4.0,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Date Sign:",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black45,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 95,
                        child: Text(
                          _fromselectedDate == null
                              ? 'From'
                              : DateFormat.yMMMMd().format(_fromselectedDate!),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // _pickDateDialog();
                        },
                        child: const Icon(
                          Icons.calendar_month,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(5),
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black45,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 95,
                        child: Text(
                          _toselectedDate == null
                              ? 'To'
                              : DateFormat.yMMMMd().format(_toselectedDate!),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // _pickDateDialog();
                        },
                        child: const Icon(
                          Icons.calendar_month,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Status:",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  width: 150,
                  height: 32,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black45,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: DropdownButton<String>(
                    elevation: 10,
                    value: statusValue,
                    onChanged: (statValue) {
                      statusValue = statValue!;
                    },
                    underline: Container(),
                    items: <String>[
                      'All',
                      'Subscribed',
                      'Unsubscribed',
                      'Cancelled',
                    ].map<DropdownMenuItem<String>>((String value1) {
                      return DropdownMenuItem<String>(
                        value: value1,
                        child: Container(
                          width: 110,
                          child: Text(
                            value1,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorPrimary,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    onPressed: () {},
                    child: const Text('Search'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 10,
              right: 10,
              bottom: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  checkColor: Colors.black,
                  activeColor: Colors.green,
                  value: select,
                  onChanged: (value) {
                    select = value!;
                  },
                ),
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  "Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
                const SizedBox(
                  width: 35,
                ),
                const Text(
                  "Date Enrolled",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(
                    // flex: 2,
                    ),
                const Text(
                  "Subject",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(
                    // flex: 1,
                    ),
                const Text(
                  "Status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(
                    // flex: 1,
                    ),
                const Text(
                  "Classes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(
                    // flex: 3,
                    ),
                const Text(
                  "Action",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            child: Divider(
              height: 1,
              thickness: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 10,
              right: 10,
              bottom: 8.0,
            ),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('students')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No students available.'));
                  } else {
                    final tutorslist = snapshot.data!.docs;
                    return SizedBox(
                      width: size.width - 500,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: tutorslist.length,
                        itemBuilder: (context, index) {
                          final tutorsinfo = tutorslist[index];
                          String tempimage = '';
                          return Scrollbar(
                            thumbVisibility: true,
                            controller: ScrollController(),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: ScrollController(),
                              physics: const BouncingScrollPhysics(),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TutorProfile(
                                              namex: '',
                                            )),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      color: (index % 2 == 0)
                                          ? Colors.white
                                          : Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5.0,
                                          left: 10,
                                          right: 10,
                                          bottom: 5.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.black,
                                              activeColor: Colors.red,
                                              value: select,
                                              onChanged: (value) {
                                                select = value!;
                                              },
                                            ),
                                            SizedBox(
                                              width: 300,
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    tempimage.toString(),
                                                  ),
                                                  radius: 25,
                                                ),
                                                title: Text(
                                                  '${(tutorsinfo['studentFirstName'])}${(tutorsinfo['studentMiddleName'] == 'N/A' ? '' : ' ${(tutorsinfo['studentFirstName'])}')} ${(tutorsinfo['studentLastName'])}',
                                                  // 'Name',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  tutorsinfo['country'],
                                                  // 'Country',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: 150,
                                              height: 40,
                                              child: ElevatedButton.icon(
                                                icon: const Icon(
                                                  EvaIcons.externalLinkOutline,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                onPressed: () {
                                                  // showAddschedule(context, data);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor:
                                                      Colors.grey[850],
                                                  backgroundColor: Colors.green,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  elevation: 0,
                                                ),
                                                label: const Text(
                                                  "Open Classes",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                width: 150,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black45,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.white,
                                                ),
                                                child: DropdownButton<String>(
                                                  elevation: 10,
                                                  value: statusValue,
                                                  onChanged: (statValue) {
                                                    statusValue = statValue!;
                                                  },
                                                  underline: Container(),
                                                  items: <String>[
                                                    'All',
                                                    'Blocked',
                                                    'Unblocked',
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value1) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value1,
                                                      child: Container(
                                                        width: 110,
                                                        child: Text(
                                                          value1,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  DataRow recentUserDataRow(
      StudentInfoClass userInfo, BuildContext context, int index) {
    return DataRow(
      color: index.isEven
          ? MaterialStateColor.resolveWith(
              (states) => const Color.fromARGB(255, 172, 221, 244))
          : null, // Set the background color

      cells: [
        DataCell(
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: kSpacing / 2),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.orange.withOpacity(.5),
                  child: Text(
                    userInfo.studentFirstname.getInitialName(1).toUpperCase() +
                        userInfo.studentLastname
                            .getInitialName(1)
                            .toUpperCase(),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 147, 89, 2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 1,
              ),
              Text(
                '${userInfo.studentFirstname} ${userInfo.studentMiddlename == 'N/A' ? '' : userInfo.studentMiddlename} ${userInfo.studentLastname}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        DataCell(Text(userInfo.country)),
        DataCell(Text(userInfo.emailadd)),
        DataCell(Text(userInfo.studentID)),
        DataCell(Text(userInfo.contact)),
        DataCell(Text(
          DateFormat('MMMM d, yyyy').format(userInfo.dateregistered),
        )),
        DataCell(
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(
                  EvaIcons.personOutline,
                  color: Colors.white,
                  size: 16,
                ),
                onPressed: () {
                  showStudentInfo(context, userInfo);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey[850],
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                label: const Text(
                  "View Info",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  EvaIcons.personRemoveOutline,
                  color: Colors.white,
                  size: 16,
                ),
                onPressed: () {
                  // QuickAlert.show(
                  //   context: context,
                  //   type: QuickAlertType.custom,
                  //   barrierDismissible: true,
                  //   confirmBtnText: 'Yes',
                  //   cancelBtnText: 'No',
                  //   confirmBtnColor: Colors.green,
                  //   showCancelBtn: true,
                  //   customAsset: 'assets/images/warning.gif',
                  //   widget: const Center(
                  //     child: Text(
                  //         'Are you sure you sure you want to close your Student Profile with Work4uTutor?'),
                  //   ),
                  //   onConfirmBtnTap: () async {
                  //     // if (message.length < 5) {
                  //     //   await
                  //     QuickAlert.show(
                  //       context: context,
                  //       type: QuickAlertType.error,
                  //       text: 'Please input something',
                  //     );
                  //     // return;
                  //     // }
                  //     Navigator.pop(context);
                  //     await Future.delayed(const Duration(milliseconds: 1000));
                  //     await QuickAlert.show(
                  //       context: context,
                  //       type: QuickAlertType.success,
                  //       text: "Phone number has been saved!.",
                  //     );
                  //   },
                  //   onCancelBtnTap: () {
                  //     QuickAlert.show(
                  //       context: context,
                  //       type: QuickAlertType.error,
                  //       text: 'Please input something',
                  //     );
                  //   },
                  // );
                  showCancelAccount(context, 'Are you sure you sure you want to close this Student Profile with Work4uTutor?');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey[850],
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                label: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // TextButton(
              //   child: const Text("Delete",
              //       style: TextStyle(color: Colors.redAccent)),
              //   onPressed: () {
              //     showDialog(
              //         context: context,
              //         builder: (_) {
              //           return AlertDialog(
              //               title: Center(
              //                 child: Column(
              //                   children: const [
              //                     Icon(Icons.warning_outlined,
              //                         size: 36, color: Colors.red),
              //                     SizedBox(height: 20),
              //                     Text("Confirm Deletion"),
              //                   ],
              //                 ),
              //               ),
              //               content: Container(
              //                 color: Colors.grey,
              //                 height: 70,
              //                 child: Column(
              //                   children: [
              //                     Text(
              //                         "Are you sure want to delete ${userInfo.studentFirstname} ${userInfo.studentMiddlename == 'N/A' ? '' : userInfo.studentMiddlename} ${userInfo.studentLastname} ?"),
              //                     const SizedBox(
              //                       height: 16,
              //                     ),
              //                     Row(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         ElevatedButton.icon(
              //                             icon: const Icon(
              //                               Icons.close,
              //                               size: 14,
              //                             ),
              //                             style: ElevatedButton.styleFrom(
              //                                 backgroundColor: Colors.grey),
              //                             onPressed: () {
              //                               Navigator.of(context).pop();
              //                             },
              //                             label: const Text("Blocked")),
              //                         const SizedBox(
              //                           width: 20,
              //                         ),
              //                         ElevatedButton.icon(
              //                             icon: const Icon(
              //                               Icons.delete,
              //                               size: 14,
              //                             ),
              //                             style: ElevatedButton.styleFrom(
              //                                 backgroundColor: Colors.red),
              //                             onPressed: () {},
              //                             label: const Text("Delete"))
              //                       ],
              //                     )
              //                   ],
              //                 ),
              //               ));
              //         });
              //   },
              //   // Delete
              // ),
            ],
          ),
        ),
      ],
    );
  }

  void showInternalLogin(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return SizedBox(
                    height: height,
                    width: 200,
                    child: const InternalAccess(),
                  );
                },
              ),
            ));
  }

  Widget _buildReports() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing * 2),
          Row(
            children: const [
              Expanded(
                child: HeaderText(
                  'Reports',
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpacing),
          const MiniInformation(),
          const SizedBox(height: kSpacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Expanded(
                child: Chart(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showStudentInfo(BuildContext context, StudentInfoClass data) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return SizedBox(
                    height: height - 100,
                    width: 800,
                    child: ViewStudentPersonalInfo(
                      data: data,
                    ),
                  );
                },
              ),
            ));
  }

  void showAddadmin(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Adjust the radius as needed
          ),
          contentPadding: EdgeInsets.zero,
          content: ClipRRect(
            borderRadius: BorderRadius.circular(15.0), // Same radius as above
            child: Container(
              color: Colors
                  .white, // Set the background color of the circular content

              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: height - 200,
                    width: 500,
                    child: const Newadmin(),
                  ),
                  Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
