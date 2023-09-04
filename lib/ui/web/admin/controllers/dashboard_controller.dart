part of dashboard;

class DashboardController extends GetxController {
  final scafoldKey = GlobalKey<ScaffoldState>();
  late Rx<List<AdminsInformation>> adminsList;
  late Rx<List<ListTaskAssignedData>> taskList;
  late Rx<List<SubjectData>> subjectList;

  @override
  void onInit() {
    super.onInit();
    adminsList = Rx<List<AdminsInformation>>([]);
    listenForAdminsChanges();
    taskList = Rx<List<ListTaskAssignedData>>([]);
    listenForTaskChanges();
    subjectList = Rx<List<SubjectData>>([]);
    listenForSubjectChanges();
  }

  void listenForAdminsChanges() {
    final CollectionReference adminsCollection =
        FirebaseFirestore.instance.collection('admin');

    adminsCollection.snapshots().listen((querySnapshot) {
      List<AdminsInformation> newAdminsList = [];

      for (var documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        AdminsInformation admin = AdminsInformation(
          address: data['address'],
          dateRegister: (data['dateRegisterd'] as Timestamp).toDate(),
          firstname: data['adminFirstName'],
          middlename: data['adminMiddleName'],
          lastname: data['adminLastName'],
          email: data['adminemail'],
          position: data['adminposition'],
          adminID: data['adminID'],
          contactnumber: data['contactnumber'],
        );

        newAdminsList.add(admin);
      }

      adminsList.value = newAdminsList;
    });
  }

  void listenForSubjectChanges() {
    final CollectionReference subjectsCollection =
        FirebaseFirestore.instance.collection('subjects');

    subjectsCollection.snapshots().listen((querySnapshot) {
      List<SubjectData> newSubjectList = [];

      for (var documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        SubjectData subject = SubjectData(
          dateAccepted: (data['datetime'] as Timestamp).toDate(),
          subjectId: data['subjectid'],
          subjectName: data['subjectName'],
          subjectStatus: data['subjectStatus'],
          dataID: documentSnapshot.id,
        );

        newSubjectList.add(subject);
      }

      subjectList.value = newSubjectList;
    });
  }

  void listenForTaskChanges() {
    final CollectionReference adminsCollection =
        FirebaseFirestore.instance.collection('task');

    adminsCollection.snapshots().listen((querySnapshot) {
      List<ListTaskAssignedData> newtaskList = [];

      for (var documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        ListTaskAssignedData admin = ListTaskAssignedData(
          assignTo: data['assignTo'],
          dateassigned: (data['dateAssigned'] as Timestamp).toDate(),
          taskid: documentSnapshot.id,
          taskname: data['taskName'],
          taskstatus: data['taskStatus'],
          tasktype: data['taskType'],
          timeline: (data['timeline'] as Timestamp).toDate(),
        );

        newtaskList.add(admin);
      }

      taskList.value = newtaskList;
    });
  }

  RxBool openNew = false.obs;

  final dataProfil = const UserProfileData(
    image: AssetImage('assets/images/man.png'),
    name: "Rick",
    jobDesk: "Executive Manager",
  );

  final member = ["Sarah Avelino", "Melvin Jhon Amles", "Michelle Fox"];

  final dataTask = const TaskProgressData(totalTask: 5, totalCompleted: 1);

  final subjectdata = [
    SubjectData(
        dateAccepted: DateTime.now(),
        subjectId: '00001',
        subjectName: 'Math',
        subjectStatus: 'New',
        dataID: ''),
    SubjectData(
        dateAccepted: DateTime.now(),
        subjectId: '00002',
        subjectName: 'Science',
        subjectStatus: 'Accepted',
        dataID: ''),
    SubjectData(
        dateAccepted: DateTime.now(),
        subjectId: '00003',
        subjectName: 'English',
        subjectStatus: 'Accepted',
        dataID: ''),
    SubjectData(
        dateAccepted: DateTime.now(),
        subjectId: '00004',
        subjectName: 'Korean Language',
        subjectStatus: 'Accepted',
        dataID: ''),
  ];

  final taskInProgress = [
    CardTaskData(
      label: "Math",
      jobDesk: "System Analyst",
      dueDate: DateTime.now().add(const Duration(minutes: 50)),
    ),
    // CardTaskData(
    //   label: "Science",
    //   jobDesk: "Marketing",
    //   dueDate: DateTime.now().add(const Duration(hours: 4)),
    // ),
    // CardTaskData(
    //   label: "English",
    //   jobDesk: "Design",
    //   dueDate: DateTime.now().add(const Duration(days: 2)),
    // ),
    // CardTaskData(
    //   label: "Algebra",
    //   jobDesk: "System Analyst",
    //   dueDate: DateTime.now().add(const Duration(minutes: 50)),
    // ),
    // CardTaskData(
    //   label: "Math",
    //   jobDesk: "System Analyst",
    //   dueDate: DateTime.now().add(const Duration(minutes: 50)),
    // ),
    // CardTaskData(
    //   label: "Science",
    //   jobDesk: "Marketing",
    //   dueDate: DateTime.now().add(const Duration(hours: 4)),
    // ),
    // CardTaskData(
    //   label: "English",
    //   jobDesk: "Design",
    //   dueDate: DateTime.now().add(const Duration(days: 2)),
    // ),
    // CardTaskData(
    //   label: "Algebra",
    //   jobDesk: "System Analyst",
    //   dueDate: DateTime.now().add(const Duration(minutes: 50)),
    // ),
    // CardTaskData(
    //   label: "Math",
    //   jobDesk: "System Analyst",
    //   dueDate: DateTime.now().add(const Duration(minutes: 50)),
    // ),
    // CardTaskData(
    //   label: "Science",
    //   jobDesk: "Marketing",
    //   dueDate: DateTime.now().add(const Duration(hours: 4)),
    // ),
    // CardTaskData(
    //   label: "English",
    //   jobDesk: "Design",
    //   dueDate: DateTime.now().add(const Duration(days: 2)),
    // ),
    // CardTaskData(
    //   label: "Algebra",
    //   jobDesk: "System Analyst",
    //   dueDate: DateTime.now().add(const Duration(minutes: 50)),
    // )
  ];

  // final weeklyTask = [
  //   ListTaskAssignedData(
  //     icon: const Icon(EvaIcons.monitor, color: Colors.blueGrey),
  //     label: "Slicing UI",
  //     jobDesk: "Programmer",
  //     assignTo: "Alex Ferguso",
  //     editDate: DateTime.now().add(-const Duration(hours: 2)),
  //   ),
  //   ListTaskAssignedData(
  //     icon: const Icon(EvaIcons.star, color: Colors.amber),
  //     label: "Personal branding",
  //     jobDesk: "Marketing",
  //     assignTo: "Justin Beck",
  //     editDate: DateTime.now().add(-const Duration(days: 50)),
  //   ),
  //   const ListTaskAssignedData(
  //     icon: Icon(EvaIcons.colorPalette, color: Colors.blue),
  //     label: "UI UX ",
  //     jobDesk: "Design",
  //   ),
  //   const ListTaskAssignedData(
  //     icon: Icon(EvaIcons.pieChart, color: Colors.redAccent),
  //     label: "Determine meeting schedule ",
  //     jobDesk: "System Analyst",
  //   ),
  //   ListTaskAssignedData(
  //     icon: const Icon(EvaIcons.monitor, color: Colors.blueGrey),
  //     label: "Slicing UI",
  //     jobDesk: "Programmer",
  //     assignTo: "Alex Ferguso",
  //     editDate: DateTime.now().add(-const Duration(hours: 2)),
  //   ),
  //   ListTaskAssignedData(
  //     icon: const Icon(EvaIcons.star, color: Colors.amber),
  //     label: "Personal branding",
  //     jobDesk: "Marketing",
  //     assignTo: "Justin Beck",
  //     editDate: DateTime.now().add(-const Duration(days: 50)),
  //   ),
  //   const ListTaskAssignedData(
  //     icon: Icon(EvaIcons.colorPalette, color: Colors.blue),
  //     label: "UI UX ",
  //     jobDesk: "Design",
  //   ),
  //   const ListTaskAssignedData(
  //     icon: Icon(EvaIcons.pieChart, color: Colors.redAccent),
  //     label: "Determine meeting schedule ",
  //     jobDesk: "System Analyst",
  //   ),
  //   ListTaskAssignedData(
  //     icon: const Icon(EvaIcons.monitor, color: Colors.blueGrey),
  //     label: "Slicing UI",
  //     jobDesk: "Programmer",
  //     assignTo: "Alex Ferguso",
  //     editDate: DateTime.now().add(-const Duration(hours: 2)),
  //   ),
  //   ListTaskAssignedData(
  //     icon: const Icon(EvaIcons.star, color: Colors.amber),
  //     label: "Personal branding",
  //     jobDesk: "Marketing",
  //     assignTo: "Justin Beck",
  //     editDate: DateTime.now().add(-const Duration(days: 50)),
  //   ),
  //   const ListTaskAssignedData(
  //     icon: Icon(EvaIcons.colorPalette, color: Colors.blue),
  //     label: "UI UX ",
  //     jobDesk: "Design",
  //   ),
  //   const ListTaskAssignedData(
  //     icon: Icon(EvaIcons.pieChart, color: Colors.redAccent),
  //     label: "Determine meeting schedule ",
  //     jobDesk: "System Analyst",
  //   ),
  // ];

  final applicants = [
    [
      ListInterviewDateData(
        date: DateTime.now().add(const Duration(days: 2, hours: 10)),
        address: "Phillipines",
        name: "Melvin Amles",
      ),
      ListInterviewDateData(
        date: DateTime.now().add(const Duration(days: 2, hours: 11)),
        address: "Phillipines",
        name: "Angel Wig",
      ),
    ],
    [
      ListInterviewDateData(
        date: DateTime.now().add(const Duration(days: 4, hours: 5)),
        address: "Phillipines",
        name: "Michael Porter",
      ),
      ListInterviewDateData(
        date: DateTime.now().add(const Duration(days: 4, hours: 6)),
        address: "Phillipines",
        name: "Lebron James",
      ),
    ],
    [
      ListInterviewDateData(
        date: DateTime.now().add(const Duration(days: 6, hours: 5)),
        address: "Korea",
        name: "Jung Kok",
      ),
      ListInterviewDateData(
        date: DateTime.now().add(const Duration(days: 6, hours: 6)),
        address: "Dubai",
        name: "Abdul Jabbaar",
      ),
      ListInterviewDateData(
        date: DateTime.now().add(const Duration(days: 6, hours: 8)),
        address: "China",
        name: "Lee Min Hoo",
      ),
      ListInterviewDateData(
        date: DateTime.now().add(const Duration(days: 6, hours: 10)),
        address: "America",
        name: "Johannes Mike",
      ),
    ]
  ];

  void onPressedProfil() {}
  void onPressedshow() {
    openNew.value = !openNew.value;
  }

  void onSelectedTaskMenu(int index, String label) {}

  void searchTask(String value) {}

  void onPressedTask(int index, ListTaskAssignedData data) {}
  void onPressedAssignTask(int index, ListTaskAssignedData data) {}
  void onPressedMemberTask(int index, ListTaskAssignedData data) {}
  void onPressedCalendar() {}
  void onPressedTaskGroup(int index, dynamic data) {}

  void openDrawer() {
    if (scafoldKey.currentState != null) {
      scafoldKey.currentState!.openDrawer();
    }
  }
}
