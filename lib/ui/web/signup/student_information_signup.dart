// ignore_for_file: avoid_web_libraries_in_flutter, avoid_print, use_build_context_synchronously, prefer_final_fields

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_pickers/country.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;

import '../../../components/nav_bar.dart';
import '../../../data_class/studentinfoclass.dart';
import '../../../services/getlanguages.dart';
import '../../../services/getstudentinfo.dart';
import '../../../services/send_email.dart';
import '../../../shared_components/alphacode3.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

import '../../../utils/themes.dart';
import '../../auth/auth.dart';
import '../login/login.dart';
import '../terms/termpage.dart';

class StudentInfo extends StatefulWidget {
  final String uid;
  final String email;
  const StudentInfo({Key? key, required this.uid, required this.email})
      : super(key: key);

  @override
  State<StudentInfo> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<StudentInfoClass>>.value(
          value: StudentInfoData(uid: widget.uid).getstudentinfo,
          catchError: (context, error) {
            print('Error occurred: $error');
            return [];
          },
          initialData: const [],
        ),
      ],
      child: StudentInfoBody(
        uid: widget.uid,
        email: widget.email,
      ),
    );
  }
}

class StudentInfoBody extends StatefulWidget {
  final String uid;
  final String email;
  const StudentInfoBody({Key? key, required this.uid, required this.email})
      : super(key: key);

  @override
  State<StudentInfoBody> createState() => _StudentInfoBodyState();
}

class _StudentInfoBodyState extends State<StudentInfoBody> {
  // void main() {
  //   super.initState();
  //   _initData();
  //   tz.initializeTimeZone();
  // }

  String _selectedTimeZone = 'UTC';
  var dtf = js.context['Intl'].callMethod('DateTimeFormat');
  var ops = js.context['Intl']
      .callMethod('DateTimeFormat')
      .callMethod('resolvedOptions');
  String? dropdownvalue;
  String? dropdownvaluesubject;
  bool select = false;

//student information
  TextEditingController firstname = TextEditingController();
  TextEditingController middlename = TextEditingController();
  TextEditingController lastname = TextEditingController();
  String tcontactNumber = "";
  String selectedCountry = "";
  String tCity = "";
  String tTimezone = "";
  String contactNumber = "";
  String uID = "Upload your ID";
  String uPicture = "";
  List<String> uCertificates = [];
  List<String> tlanguages = [];
  String uCV = "";
  String uVideo = "";
  String tAbout = "";
  bool shareInfo = false;
  int age = 0;
  bool selection2 = false;
  bool selection3 = false;
  bool selection4 = false;
  bool selection5 = false;
  bool onlineclas = false;
  bool inperson = false;
  int languageCount = 1;
  int subjectcount = 1;
  double subjecthieght = 250;
  double thieght = 45;
  List<String> genders = ['Male', 'Female', 'Rather not say'];

  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'PH');
  TextEditingController phoneNumberController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateguardian = DateTime.now();
  String studentIDNumber = 'STU*********';
  String bdate = "Date of Birth";
  String myage = "Age";
  TextEditingController guardianfullname = TextEditingController();
  String guardianbdate = "Date of Birth";
  String guardianage = "Age";
  String guardianID = "";
  String guardianpPicture = "";
  TextEditingController guardiancontactnumber = TextEditingController();
  TextEditingController guardiansemail = TextEditingController();

  //new added
  List<String> citizenship = [];

  String currentLanguage = '';
  String currentctzship = '';
  ScrollController updatescrollController1 = ScrollController();
  ScrollController updatescrollController2 = ScrollController();

  TextEditingController _selectedBirthCountryController =
      TextEditingController();
  bool countryStatus = false;
  TextEditingController birthtCity = TextEditingController();
  String selectedbirthCountry = "";
  FocusNode _selectedTimeZonefocusNode = FocusNode();
  TextEditingController tCity1 = TextEditingController();
  bool showselectedTimeZoneSuggestions = false;
  TextEditingController _selectedTimeZone1 = TextEditingController();
  TextEditingController _selectedGenderController = TextEditingController();
  String selectedGender = "";

  void _selectDate(String infodata) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(5000));
    if (picked != null && picked != selectedDate) {
      setState(() {
        if (infodata == 'student') {
          selectedDate = picked;
          bdate = selectedDate.toString();
        } else if (infodata == 'guardian') {
          selectedDateguardian = picked;
          guardianbdate =
              DateFormat("MMMM dd, yyyy").format(selectedDateguardian);
        }
        bdate = DateFormat("MMMM dd, yyyy").format(selectedDate);
        calculateAge(picked, infodata);
      });
    }
  }

  List<Color> vibrantColors = [
    const Color.fromRGBO(185, 237, 221, 1),
    const Color.fromRGBO(135, 203, 185, 1),
    const Color.fromRGBO(86, 157, 170, 1),
    const Color.fromRGBO(87, 125, 134, 1),
  ];

  void calculateAge(DateTime birthDate, String info) {
    DateTime currentDate = DateTime.now();
    int currentage = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (currentage < 0) {
      print("Add notification here not valid date selection");
    } else {
      if (month2 > month1) {
        currentage--;
        setState(() {
          if (info == 'student') {
            setState(() {
              age = currentage;
              myage = age.toString();
            });
          } else if (info == 'guardian') {
            guardianage = currentage.toString();
          }
        });
      } else if (month1 == month2) {
        int day1 = currentDate.day;
        int day2 = birthDate.day;
        if (day2 > day1) {
          currentage--;
          setState(() {
            if (info == 'student') {
              setState(() {
                age = currentage;
                myage = age.toString();
              });
            } else if (info == 'guardian') {
              guardianage = currentage.toString();
            }
          });
        } else if (day2 <= day1) {
          setState(() {
            if (info == 'student') {
              setState(() {
                age = currentage;
                myage = age.toString();
              });
            } else if (info == 'guardian') {
              guardianage = currentage.toString();
            }
          });
        }
      } else if (month1 > month2) {
        setState(() {
          if (info == 'student') {
            setState(() {
              age = currentage;
              myage = age.toString();
            });
          } else if (info == 'guardian') {
            guardianage = currentage.toString();
          }
        });
      }
    }
  }

  //term
  bool termStatus = false;
  String profileurl = '';

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  List<String> timezonesList = [];
  @override
  void initState() {
    super.initState();
    _initData();
    getTimezones();
    // _timeZones = tz.timeZoneDatabase.locations;
  }

  Future<void> _initData() async {
    try {
      _selectedTimeZone = await FlutterNativeTimezone
          .getLocalTimezone(); // Set local timezone here
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getTimezones() async {
    final response =
        await http.get(Uri.parse('http://worldtimeapi.org/api/timezone'));

    if (response.statusCode == 200) {
      final List<dynamic> timezones = json.decode(response.body);
      if (timezones.isNotEmpty) {
        // Initialize Firestore
        final firestore = FirebaseFirestore.instance;

        // Add the timezonesList to the "timezones" collection
        // await firestore.collection('timezones').doc('timezone_document').set({
        //   'timezonesList': timezones,
        // });
        setState(() {
          timezonesList = List<String>.from(timezones);
        });
      } else {
        //to do
        // final studentinfodata = Provider.of<List<StudentInfoClass>>(context);
        throw Exception('No timezones found');
      }
    } else {
      throw Exception('Failed to load timezones: ${response.statusCode}');
    }
  }

  String getLocalTimeZone() {
    final dateTime = DateTime.now();
    final timeZoneOffset = dateTime.timeZoneOffset;
    final hours = timeZoneOffset.inHours.abs();
    final minutes = timeZoneOffset.inMinutes.abs() % 60;
    final sign = timeZoneOffset.isNegative ? '-' : '+';

    final timeZoneName =
        html.window.navigator.language; // Get the local time zone name

    return '$timeZoneName (GMT$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')})';
  }

  final AuthService _auth = AuthService();

  Uint8List? selectedImage;
  String filename = '';
  Uint8List? guardianselectedImage;
  String guadianfilename = '';

// Function to select an image
  void selectImage(String role) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result != null && role == 'student') {
      setState(() {
        selectedImage = result.files.first.bytes;
        filename = result.files.first.name;
      });
    } else if (result != null && role == 'guardian') {
      setState(() {
        guardianselectedImage = result.files.first.bytes;
        guadianfilename = result.files.first.name;
      });
    }
  }

  List<Uint8List?> selectedIDfiles = [];
  List<String> idfilenames = [];
  List<String> idfilenamestype = [];
  void selectImagesID() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedIDfiles.addAll(result.files.map((file) => file.bytes));
        idfilenames.addAll(result.files.map((file) => file.name));
        // Determine file types and add them to idfilenamestype list
        List<String> fileExtensions = result.files.map((file) {
          final fileName = file.name;
          final extension = fileName.split('.').last.toLowerCase();
          return extension;
        }).toList();

        idfilenamestype.addAll(fileExtensions.map((extension) {
          // List common image extensions
          List<String> imageExtensions = [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'bmp',
            'webp'
          ];

          // Check if the extension is in the list of image extensions
          if (imageExtensions.contains(extension)) {
            return "Image";
          } else {
            return extension;
          }
        }));
      });

      print("Images selected: $idfilenames");
    }
  }

  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  @override
  Widget build(BuildContext context) {
    List<String> countryNames = Provider.of<List<String>>(context);
    List<LanguageData> names = Provider.of<List<LanguageData>>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarLog(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 130,
                    child: const Text(
                      "Subscribe with your information",
                      style: TextStyle(
                        // textStyle: Theme.of(context).textTheme.headlineMedium,
                        color: Color.fromRGBO(1, 118, 132, 1),
                        fontSize: 60,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 15, 5),
                    alignment: Alignment.centerLeft,
                    width: 680,
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.centerLeft,
                          children: <Widget>[
                            Card(
                              margin: const EdgeInsets.all(5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                              child: SizedBox(
                                width: 350,
                                height: 350,
                                // decoration: BoxDecoration(
                                //     borderRadius: const BorderRadius.all(
                                //         Radius.circular(20)),
                                //     color: Colors.grey.shade100,
                                //     border: Border.all(
                                //         color: Colors.grey, width: .5)),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FadeInImage(
                                      fadeInDuration:
                                          const Duration(milliseconds: 500),
                                      placeholder: const AssetImage(
                                          "assets/images/login.png"),
                                      image: (selectedImage != null)
                                          ? MemoryImage(selectedImage!)
                                          : const AssetImage(
                                                  "assets/images/login.png")
                                              as ImageProvider<
                                                  Object>, // Display image from profileurl
                                      // imageErrorBuilder:
                                      //     (context, error, stackTrace) {
                                      //   return Image.asset(
                                      //       "assets/images/login.png");
                                      // },
                                      fit: BoxFit.cover,
                                      height: 70,
                                      width: 70,
                                    )),
                              ),
                            ),
                            Positioned(
                                bottom: 12,
                                right: 12,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      // String? downloadURL =
                                      // await uploadData(widget.uid);

                                      // if (downloadURL != null) {
                                      //   // The upload was successful, and downloadURL contains the URL.
                                      //   print(
                                      //       "File uploaded successfully. URL: $downloadURL");
                                      //   setState(() {
                                      //     profileurl = downloadURL;
                                      //     updateProfile(widget.uid, profileurl);
                                      //   });
                                      // } else {
                                      //   // There was an error during file selection or upload.
                                      //   print("Error uploading file.");
                                      // }
                                      selectImage('student');
                                    },
                                    icon: const Icon(
                                      Icons.add_a_photo,
                                      size: 25.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        Column(
                          children: [Container()],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 15, 5),
                    alignment: Alignment.centerLeft,
                    width: 680,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: const [
                            Text(
                              "Student Identification Number",
                              style: TextStyle(
                                color: kColorLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "(Auto Generated once Country is selected!)*",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 300,
                              height: 45,
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1)),
                              child: Row(
                                children: [
                                  Text(
                                    studentIDNumber.toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: kColorGrey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: const [
                            Text(
                              "Student Information.",
                              style: TextStyle(
                                color: kColorLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "Required*",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "First Name",
                                  style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.w600),
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  child: Container(
                                    width: 190,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    // decoration: BoxDecoration(
                                    //     borderRadius: const BorderRadius.all(
                                    //         Radius.circular(5)),
                                    //     color: Colors.white,
                                    //     border: Border.all(
                                    //         color: Colors.grey.shade300, width: 1)),
                                    child: TextFormField(
                                      controller: firstname,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.grey,
                                        hintText: 'Firstname',
                                        hintStyle: TextStyle(color: kColorGrey),
                                      ),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter an firstname'
                                          : null,
                                      // onChanged: (val) {
                                      //   setState(() {
                                      //     firstname.text = val;
                                      //   });
                                      // },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Middlename",
                                  style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.w600),
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  child: Container(
                                    width: 190,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    // decoration: BoxDecoration(
                                    //     borderRadius: const BorderRadius.all(
                                    //         Radius.circular(5)),
                                    //     color: Colors.white,
                                    //     border: Border.all(
                                    //         color: Colors.grey.shade300, width: 1)),
                                    child: TextFormField(
                                      controller: middlename,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.grey,
                                        hintText: 'Middlename',
                                        hintStyle: TextStyle(color: kColorGrey),
                                      ),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter an middlename'
                                          : null,
                                      // onChanged: (val) {
                                      //   setState(() {
                                      //     middlename.text = val;
                                      //   });
                                      // },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Lastname",
                                  style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.w600),
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  child: Container(
                                    width: 190,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    // decoration: BoxDecoration(
                                    //     borderRadius: const BorderRadius.all(
                                    //         Radius.circular(5)),
                                    //     color: Colors.white,
                                    //     border: Border.all(
                                    //         color: Colors.grey.shade300, width: 1)),
                                    child: TextFormField(
                                      controller: lastname,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.grey,
                                        hintText: 'Lastname',
                                        hintStyle: TextStyle(color: kColorGrey),
                                      ),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter an lastname'
                                          : null,
                                      // onChanged: (val) {
                                      //   setState(() {
                                      //     lastname.text = val;
                                      //   });
                                      // },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Date of Birth",
                                  style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.w600),
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  child: Container(
                                    width: 400,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    // decoration: BoxDecoration(
                                    //     borderRadius: const BorderRadius.all(
                                    //         Radius.circular(5)),
                                    //     color: Colors.white,
                                    //     border: Border.all(
                                    //         color: Colors.grey.shade300, width: 1)),
                                    child: Row(
                                      children: [
                                        Text(
                                          bdate.toString(),
                                          style: const TextStyle(
                                              fontSize: 16, color: kColorGrey),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          tooltip: "Date of Birth",
                                          hoverColor: Colors.transparent,
                                          icon: const Icon(
                                            EvaIcons.calendarOutline,
                                            color: Colors.blue,
                                            size: 25,
                                          ),
                                          onPressed: () {
                                            _selectDate('student');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Age",
                                  style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.w600),
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  child: Container(
                                    width: 150,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    // decoration: BoxDecoration(
                                    //     borderRadius: const BorderRadius.all(
                                    //         Radius.circular(5)),
                                    //     color: Colors.white,
                                    //     border: Border.all(
                                    //         color: Colors.grey.shade300, width: 1)),
                                    child: Row(
                                      children: [
                                        Text(
                                          myage.toString(),
                                          style: const TextStyle(
                                              fontSize: 16, color: kColorGrey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Gender",
                                  style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.w600),
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  child: SizedBox(
                                    width: 300,
                                    height: 45,

                                    child: TypeAheadFormField<String>(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        controller: _selectedGenderController,
                                        decoration: InputDecoration(
                                          hintText: 'Select a Gender',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0), // Rounded border
                                            borderSide: BorderSide
                                                .none, // No outline border
                                          ),
                                          suffixIcon:
                                              const Icon(Icons.arrow_drop_down),
                                        ),
                                      ),
                                      suggestionsCallback: (String pattern) {
                                        return genders.where((country) =>
                                            country.toLowerCase().contains(
                                                pattern.toLowerCase()));
                                      },
                                      itemBuilder:
                                          (context, String suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion,
                                            style: const TextStyle(
                                                color: kColorGrey),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected:
                                          (String suggestion) {
                                        setState(() {
                                          selectedGender = suggestion;
                                          _selectedGenderController.text =
                                              suggestion;
                                        });
                                      },
                                    ),
                                    // country.name
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Country of Residence",
                                  style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.w600),
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  child: SizedBox(
                                    width: 300,
                                    height: 45,
                                    // decoration: BoxDecoration(
                                    //     borderRadius: const BorderRadius.all(
                                    //         Radius.circular(5)),
                                    //     color: Colors.white,
                                    //     border: Border.all(
                                    //         color: Colors.grey.shade300,
                                    //         width: 1)),
                                    child: TypeAheadFormField<String>(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        controller:
                                            _selectedBirthCountryController,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          hintText: 'Select a Country',
                                          hintStyle:
                                              TextStyle(color: kColorGrey),
                                          border: InputBorder.none,
                                          suffixIcon:
                                              Icon(Icons.arrow_drop_down),
                                        ),
                                      ),
                                      suggestionsCallback: (String pattern) {
                                        return countryNames.where((country) =>
                                            country.toLowerCase().contains(
                                                pattern.toLowerCase()));
                                      },
                                      itemBuilder:
                                          (context, String suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      onSuggestionSelected:
                                          (String suggestion) {
                                        final alpha3Code =
                                            getAlpha3Code(suggestion);
                                        Random random = Random();

                                        DateTime datenow = DateTime.now();
                                        String currenttime =
                                            DateFormat('HHmmss')
                                                .format(datenow);
                                        String randomNumber =
                                            random.nextInt(1000000).toString() +
                                                currenttime.toString();
                                        String currentyear =
                                            DateFormat('yyyyMMdd')
                                                .format(datenow);
                                        //todo please replace the random number with legnth of students enrolled
                                        setState(() {
                                          studentIDNumber =
                                              'STU$alpha3Code$currentyear$currenttime';
                                          selectedbirthCountry = suggestion;
                                          _selectedBirthCountryController.text =
                                              suggestion;
                                        });
                                      },
                                    ),
                                    // country.name
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "City of Residence",
                                  style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.w600),
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  child: Container(
                                    width: 266,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    // decoration: BoxDecoration(
                                    //     borderRadius: const BorderRadius.all(
                                    //         Radius.circular(5)),
                                    //     color: Colors.white,
                                    //     border: Border.all(
                                    //         color: Colors.grey.shade300,
                                    //         width: 1)),
                                    child: TextFormField(
                                      controller: birthtCity,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.grey,
                                        hintText: 'City',
                                        hintStyle: TextStyle(
                                            color: kColorGrey, fontSize: 15),
                                      ),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter your City'
                                          : null,
                                      // onChanged: (val) {
                                      //   tCity = val;
                                      // },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Citizenship",
                                      style: TextStyle(
                                          color: kColorLight,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "(You can select more than one citizenship.)",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w100,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  child: SizedBox(
                                    width: 300,
                                    height: 45,

                                    child: TypeAheadFormField<String>(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        // controller:
                                        //     _selectedBirthCountryController,
                                        decoration: InputDecoration(
                                          hintText: 'Select a Citizenship',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0), // Rounded border
                                            borderSide: BorderSide
                                                .none, // No outline border
                                          ),
                                          suffixIcon:
                                              const Icon(Icons.arrow_drop_down),
                                        ),
                                      ),
                                      suggestionsCallback: (String pattern) {
                                        return countryNames.where((country) =>
                                            country.toLowerCase().contains(
                                                pattern.toLowerCase()));
                                      },
                                      itemBuilder:
                                          (context, String suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      onSuggestionSelected:
                                          (String suggestion) {
                                        if (citizenship.contains(suggestion)) {
                                          null;
                                        } else {
                                          setState(() {
                                            citizenship.add(suggestion
                                                .toString()); // Add the LanguageData object to tlanguages
                                          });
                                        }
                                      },
                                    ),
                                    // country.name
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Visibility(
                          visible: citizenship.isNotEmpty ? true : false,
                          child: const SizedBox(
                            height: 10,
                          ),
                        ),
                        Visibility(
                          visible: citizenship.isNotEmpty ? true : false,
                          child: Container(
                            width: 680,
                            height: 45,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            // decoration: BoxDecoration(
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(5)),
                            //     color: Colors.white,
                            //     border: Border.all(
                            //         color: Colors.grey.shade300, width: 1)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 600,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        iconSize: 12,
                                        padding: EdgeInsets.zero,
                                        splashRadius: 1,
                                        icon: const Icon(
                                          Icons
                                              .arrow_back_ios, // Left arrow icon
                                          color: kColorPrimary,
                                        ),
                                        onPressed: () {
                                          // Scroll to the left
                                          updatescrollController2.animateTo(
                                            updatescrollController2.offset -
                                                100.0, // Adjust the value as needed
                                            duration: const Duration(
                                                milliseconds:
                                                    500), // Adjust the duration as needed
                                            curve: Curves.ease,
                                          );
                                        },
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            controller: updatescrollController1,
                                            itemCount: citizenship.length,
                                            itemBuilder: (context, index) {
                                              String language =
                                                  citizenship[index];
                                              Color color = vibrantColors[index %
                                                  vibrantColors
                                                      .length]; // Cycle through colors

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (citizenship[index] ==
                                                          currentctzship) {
                                                        currentctzship = '';
                                                      } else {
                                                        currentctzship =
                                                            citizenship[index];
                                                      }
                                                    });
                                                  },
                                                  child: Card(
                                                    margin: EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    elevation: 5,
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 10, 0),
                                                      decoration: citizenship[
                                                                  index] ==
                                                              currentctzship
                                                          ? const BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black12,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            4),
                                                                    blurRadius:
                                                                        5.0)
                                                              ],
                                                              gradient:
                                                                  LinearGradient(
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                                stops: [
                                                                  0.0,
                                                                  1.0
                                                                ],
                                                                colors:
                                                                    buttonFocuscolors,
                                                              ),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15)),
                                                            )
                                                          : const BoxDecoration(
                                                              boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black12,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              4),
                                                                      blurRadius:
                                                                          5.0)
                                                                ],
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15)),
                                                              color:
                                                                  Colors.white),
                                                      child: Center(
                                                        child: Text(
                                                          language,
                                                          style: TextStyle(
                                                              color: citizenship[
                                                                          index] ==
                                                                      currentctzship
                                                                  ? Colors.white
                                                                  : kColorGrey),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      IconButton(
                                        iconSize: 12,
                                        padding: EdgeInsets.zero,
                                        splashRadius: 1,
                                        icon: const Icon(
                                          Icons
                                              .arrow_forward_ios, // Right arrow icon
                                          color: kColorPrimary,
                                        ),
                                        onPressed: () {
                                          // Scroll to the right
                                          updatescrollController2.animateTo(
                                            updatescrollController2.offset +
                                                100.0, // Adjust the value as needed
                                            duration: const Duration(
                                                milliseconds:
                                                    500), // Adjust the duration as needed
                                            curve: Curves.ease,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  icon:
                                      const Icon(Icons.delete_outline_outlined),
                                  color: Colors.red,
                                  iconSize: 18,
                                  onPressed: currentctzship == ''
                                      ? null
                                      : () {
                                          setState(() {
                                            citizenship.removeWhere((item) =>
                                                item == currentctzship);
                                          });
                                        },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Timezone",
                                style: TextStyle(
                                    color: kColorLight,
                                    fontWeight: FontWeight.w600),
                              ),
                              Card(
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                                child: SizedBox(
                                  width: 300,
                                  height: 45,
                                  // decoration: BoxDecoration(
                                  //     borderRadius: const BorderRadius.all(
                                  //         Radius.circular(5)),
                                  //     color: Colors.white,
                                  //     border: Border.all(
                                  //         color: Colors.grey.shade300, width: 1)),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_selectedTimeZonefocusNode.hasFocus) {
                                        _selectedTimeZonefocusNode.unfocus();
                                        setState(() {
                                          showselectedTimeZoneSuggestions =
                                              false;
                                        });
                                      }
                                    },
                                    child: TypeAheadFormField<String>(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        controller: _selectedTimeZone1,
                                        focusNode: _selectedTimeZonefocusNode,
                                        onTap: () {
                                          setState(() {
                                            showselectedTimeZoneSuggestions =
                                                false;
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          hintText: 'Select your Timezone',
                                          hintStyle:
                                              TextStyle(color: kColorGrey),
                                          border: InputBorder.none,
                                          suffixIcon:
                                              Icon(Icons.arrow_drop_down),
                                        ),
                                      ),
                                      suggestionsCallback: (String pattern) {
                                        return timezonesList.where((timezone) =>
                                            timezone.toLowerCase().contains(
                                                pattern.toLowerCase()));
                                      },
                                      itemBuilder:
                                          (context, String suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      onSuggestionSelected:
                                          (String suggestion) {
                                        setState(() {
                                          _selectedTimeZone1.text = suggestion;
                                          _selectedTimeZone = suggestion;
                                        });
                                      },
                                      hideOnEmpty:
                                          true, // Hide suggestions when the input is empty.
                                      hideOnLoading:
                                          true, // Hide suggestions during loading.
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Contact Number",
                                style: TextStyle(
                                    color: kColorLight,
                                    fontWeight: FontWeight.w600),
                              ),
                              Card(
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                                child: Container(
                                  width: 266,
                                  height: 45,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  // decoration: BoxDecoration(
                                  //     borderRadius: const BorderRadius.all(
                                  //         Radius.circular(5)),
                                  //     color: Colors.white,
                                  //     border: Border.all(
                                  //         color: Colors.grey.shade300, width: 1)),
                                  child: InternationalPhoneNumberInput(
                                    maxLength: 20,
                                    onInputChanged: (PhoneNumber number) {
                                      phoneNumber = number;
                                    },
                                    selectorConfig: const SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.DIALOG,
                                      trailingSpace: false,
                                      leadingPadding: 0,
                                      setSelectorButtonAsPrefixIcon: true,
                                    ),
                                    ignoreBlank: false,
                                    autoValidateMode: AutovalidateMode.disabled,
                                    selectorTextStyle: const TextStyle(
                                        color: Colors.black, fontSize: 15),
                                    formatInput: true,
                                    inputDecoration: const InputDecoration(
                                        filled: false,
                                        isCollapsed: false,
                                        isDense: false,
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(bottom: 9)),
                                    // keyboardType:
                                    //     const TextInputType.numberWithOptions(
                                    //         signed: true, decimal: true),
                                    initialValue: phoneNumber,
                                    textFieldController: phoneNumberController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Language",
                                  style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  " (You can select more than one language.)",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w100,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            Card(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                              child: SizedBox(
                                width: 680,
                                height: 45,
                                child: TypeAheadFormField<LanguageData>(
                                  // Specify LanguageData as the generic type
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    // controller: _selectedLanguageController,
                                    decoration: InputDecoration(
                                      hintText: 'Choose your language',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Rounded border
                                        borderSide: BorderSide
                                            .none, // No outline border
                                      ),
                                      suffixIcon:
                                          const Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    // Assuming names is a List<LanguageData>
                                    final suggestions = names
                                        .where((language) => language
                                            .languageNamesStream
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()))
                                        .toList(); // Return a list of LanguageData objects
                                    return suggestions;
                                  },
                                  itemBuilder: (context, suggestions) {
                                    return ListTile(
                                      title: Text(
                                        suggestions.languageNamesStream,
                                        style:
                                            const TextStyle(color: kColorGrey),
                                      ), // Access the language name
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    if (tlanguages.contains(
                                        suggestion.languageNamesStream)) {
                                      null;
                                    } else {
                                      setState(() {
                                        tlanguages.add(suggestion
                                            .languageNamesStream
                                            .toString()); // Add the LanguageData object to tlanguages
                                      });
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        Visibility(
                          visible: tlanguages.isNotEmpty ? true : false,
                          child: const SizedBox(
                            height: 10,
                          ),
                        ),
                        Visibility(
                          visible: tlanguages.isNotEmpty ? true : false,
                          child: Container(
                            width: 680,
                            height: 45,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            // decoration: BoxDecoration(
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(5)),
                            //     color: Colors.white,
                            //     border: Border.all(
                            //         color: Colors.grey.shade300, width: 1)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 600,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        iconSize: 12,
                                        padding: EdgeInsets.zero,
                                        splashRadius: 1,
                                        icon: const Icon(
                                          Icons
                                              .arrow_back_ios, // Left arrow icon
                                          color: kColorPrimary,
                                        ),
                                        onPressed: () {
                                          // Scroll to the left
                                          updatescrollController1.animateTo(
                                            updatescrollController1.offset -
                                                100.0, // Adjust the value as needed
                                            duration: const Duration(
                                                milliseconds:
                                                    500), // Adjust the duration as needed
                                            curve: Curves.ease,
                                          );
                                        },
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            controller: updatescrollController1,
                                            itemCount: tlanguages.length,
                                            itemBuilder: (context, index) {
                                              String language =
                                                  tlanguages[index];
                                              Color color = vibrantColors[index %
                                                  vibrantColors
                                                      .length]; // Cycle through colors

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (tlanguages[index] ==
                                                          currentLanguage) {
                                                        currentLanguage = '';
                                                      } else {
                                                        currentLanguage =
                                                            tlanguages[index];
                                                      }
                                                    });
                                                  },
                                                  child: Card(
                                                    margin: EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    elevation: 5,
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 10, 0),
                                                      decoration: tlanguages[
                                                                  index] ==
                                                              currentLanguage
                                                          ? const BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black12,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            4),
                                                                    blurRadius:
                                                                        5.0)
                                                              ],
                                                              gradient:
                                                                  LinearGradient(
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                                stops: [
                                                                  0.0,
                                                                  1.0
                                                                ],
                                                                colors:
                                                                    buttonFocuscolors,
                                                              ),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15)),
                                                            )
                                                          : const BoxDecoration(
                                                              boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black12,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              4),
                                                                      blurRadius:
                                                                          5.0)
                                                                ],
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15)),
                                                              color:
                                                                  Colors.white),
                                                      child: Center(
                                                        child: Text(
                                                          language,
                                                          style: TextStyle(
                                                              color: tlanguages[
                                                                          index] ==
                                                                      currentLanguage
                                                                  ? Colors.white
                                                                  : kColorGrey),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      IconButton(
                                        iconSize: 12,
                                        padding: EdgeInsets.zero,
                                        splashRadius: 1,
                                        icon: const Icon(
                                          Icons
                                              .arrow_forward_ios, // Right arrow icon
                                          color: kColorPrimary,
                                        ),
                                        onPressed: () {
                                          // Scroll to the right
                                          updatescrollController1.animateTo(
                                            updatescrollController1.offset +
                                                100.0, // Adjust the value as needed
                                            duration: const Duration(
                                                milliseconds:
                                                    500), // Adjust the duration as needed
                                            curve: Curves.ease,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  icon:
                                      const Icon(Icons.delete_outline_outlined),
                                  color: Colors.red,
                                  iconSize: 18,
                                  onPressed: currentLanguage == ''
                                      ? null
                                      : () {
                                          setState(() {
                                            tlanguages.removeWhere((item) =>
                                                item == currentLanguage);
                                          });
                                        },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: age < 18 && age > 0 ? true : false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "Guardians Information.",
                                    style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "Required.*",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Card(
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                                child: Container(
                                  width: 680,
                                  height: 45,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  // decoration: BoxDecoration(
                                  //     borderRadius: const BorderRadius.all(
                                  //         Radius.circular(5)),
                                  //     color: Colors.white,
                                  //     border: Border.all(
                                  //         color: Colors.grey.shade300, width: 1)),
                                  child: TextFormField(
                                    controller: guardianfullname,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Colors.grey,
                                      hintText: 'Full Name',
                                      hintStyle: TextStyle(color: kColorGrey),
                                    ),
                                    validator: (val) => val!.isEmpty
                                        ? 'Enter an Full Name'
                                        : null,
                                    // onChanged: (val) {
                                    //   guardianfullname = val;
                                    // },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              Row(
                                children: [
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      width: 400,
                                      height: 45,
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                      // decoration: BoxDecoration(
                                      //     borderRadius: const BorderRadius.all(
                                      //         Radius.circular(5)),
                                      //     color: Colors.white,
                                      //     border: Border.all(
                                      //         color: Colors.grey.shade300,
                                      //         width: 1)),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _selectDate('guardian');
                                            },
                                            child: Text(
                                              guardianbdate,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: kColorGrey),
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            tooltip: "Date of Birth",
                                            hoverColor: Colors.transparent,
                                            icon: const Icon(
                                              EvaIcons.calendarOutline,
                                              color: Colors.blue,
                                              size: 25,
                                            ),
                                            onPressed: () {
                                              _selectDate('guardian');
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      width: 150,
                                      height: 45,
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                      // decoration: BoxDecoration(
                                      //     borderRadius: const BorderRadius.all(
                                      //         Radius.circular(5)),
                                      //     color: Colors.white,
                                      //     border: Border.all(
                                      //         color: Colors.grey.shade300,
                                      //         width: 1)),
                                      child: Row(
                                        children: [
                                          Text(
                                            guardianage.toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: kColorGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              Row(
                                children: [
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      width: 250,
                                      height: 45,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      // decoration: BoxDecoration(
                                      //     borderRadius: const BorderRadius.all(
                                      //         Radius.circular(5)),
                                      //     color: Colors.white,
                                      //     border: Border.all(
                                      //         color: Colors.grey.shade300,
                                      //         width: 1)),
                                      child: TextFormField(
                                        controller: guardiancontactnumber,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          fillColor: Colors.grey,
                                          hintText: 'Contact',
                                          hintStyle:
                                              TextStyle(color: kColorGrey),
                                        ),
                                        validator: (val) => val!.isEmpty
                                            ? 'Enter your Contact'
                                            : null,
                                        // onChanged: (val) {
                                        //   guardiancontactnumber = val;
                                        // },
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      width: 280,
                                      height: 45,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      // decoration: BoxDecoration(
                                      //     borderRadius: const BorderRadius.all(
                                      //         Radius.circular(5)),
                                      //     color: Colors.white,
                                      //     border: Border.all(
                                      //         color: Colors.grey.shade300,
                                      //         width: 1)),
                                      child: TextFormField(
                                        controller: guardiansemail,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          fillColor: Colors.grey,
                                          hintText: 'Email',
                                          hintStyle:
                                              TextStyle(color: kColorGrey),
                                        ),
                                        validator: (val) => val!.isEmpty
                                            ? 'Enter your email'
                                            : null,
                                        // onChanged: (val) {
                                        //   guardiansemail = val;
                                        // },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "Upload Guardian documents.",
                                    style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    width: 180,
                                    height: 55,
                                    child: TextButton(
                                      onPressed: () async {
                                        selectImagesID();
                                      },
                                      child: const Text(
                                        'Upload ID',
                                        style: TextStyle(
                                            color: kColorPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  idfilenames.isNotEmpty
                                      ? Container(
                                          width: 400,
                                          height: 55,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                iconSize: 15,
                                                icon: const Icon(
                                                  Icons
                                                      .arrow_back_ios, // Left arrow icon
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  // Scroll to the left
                                                  _scrollController.animateTo(
                                                    _scrollController.offset -
                                                        100.0, // Adjust the value as needed
                                                    duration: const Duration(
                                                        milliseconds:
                                                            500), // Adjust the duration as needed
                                                    curve: Curves.ease,
                                                  );
                                                },
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  controller:
                                                      _scrollController, // Assign the ScrollController to the ListView
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: idfilenames.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Color color = vibrantColors[
                                                        index %
                                                            vibrantColors
                                                                .length];

                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                          color: color,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(idfilenames[
                                                                index]),
                                                            IconButton(
                                                              iconSize: 15,
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  idfilenames
                                                                      .removeAt(
                                                                          index);
                                                                  selectedIDfiles
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              IconButton(
                                                iconSize: 15,
                                                icon: const Icon(
                                                  Icons
                                                      .arrow_forward_ios, // Right arrow icon
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  // Scroll to the right
                                                  _scrollController.animateTo(
                                                    _scrollController.offset +
                                                        100.0, // Adjust the value as needed
                                                    duration: const Duration(
                                                        milliseconds:
                                                            500), // Adjust the duration as needed
                                                    curve: Curves.ease,
                                                  );
                                                },
                                              ),
                                            ],
                                          ))
                                      : Container(
                                          width: 400,
                                          height: 55,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: const Center(
                                            child: Text(
                                                '"You can upload front and back of ID."'),
                                          ),
                                        )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    width: 180,
                                    height: 55,
                                    child: TextButton(
                                      onPressed: () async {
                                        selectImage('guardian');
                                      },
                                      child: const Text(
                                        'Upload Picture',
                                        style: TextStyle(
                                            color: kColorPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  guadianfilename.isNotEmpty
                                      ? Container(
                                          width: 400,
                                          height: 55,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 5, 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  15)),
                                                      color: vibrantColors[1 %
                                                          vibrantColors.length],
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(guadianfilename),
                                                        IconButton(
                                                          iconSize: 15,
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              guadianfilename ==
                                                                  '';
                                                              guardianselectedImage ==
                                                                  null;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))
                                      : Container(
                                          width: 400,
                                          height: 55,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: const Center(
                                            child: Text(
                                                '"Please upload your personal Picture"'),
                                          ),
                                        )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: CheckboxListTile(
                            title: const Text(
                              'Agree to Work4uTutor Terms & Condition and Privacy Policy.',
                              style: TextStyle(fontSize: 15, color: kColorGrey),
                            ),
                            // subtitle: const Text(
                            //     'A computer science portal for geeks.'),
                            // secondary: const Icon(Icons.code),
                            autofocus: false,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: termStatus,
                            value: termStatus,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) async {
                              dynamic accept = await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    var height =
                                        MediaQuery.of(context).size.height;
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            15.0), // Adjust the radius as needed
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      content: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            15.0), // Same radius as above
                                        child: Container(
                                          color: Colors
                                              .white, // Set the background color of the circular content

                                          child: Stack(
                                            children: <Widget>[
                                              SizedBox(
                                                height: height,
                                                width: 900,
                                                child: const TermPage(
                                                  pdfurl: '',
                                                ),
                                              ),
                                              Positioned(
                                                top: 10.0,
                                                right: 10.0,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop(
                                                        false); // Close the dialog
                                                  },
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });

                              setState(() {
                                if (accept != null) {
                                  termStatus = accept;
                                }
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          width: 380,
                          height: 75,
                          child: TextButton(
                              onPressed: () async {
                                if (age >= 18) {
                                  if (firstname.text.isEmpty) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Firstname Required!",
                                    );
                                  } else if (lastname.text == '') {
                                    CoolAlert.show(
                                      context: context,
                                      title: 'Error',
                                      width: 200,
                                      type: CoolAlertType.error,
                                      text: "Lastname Required!",
                                    );
                                  } else if (filename == '') {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Profile Picture Required!",
                                    );
                                  } else if (age == 0) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Select Birth Date!",
                                    );
                                  } else if (termStatus == false) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      type: CoolAlertType.error,
                                      text: "Please accept terms & conditions!",
                                    );
                                  } else if (birthtCity.text == '') {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Input City!",
                                    );
                                  } else if (_selectedBirthCountryController
                                          .text ==
                                      '') {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Select Country!",
                                    );
                                  } else if (_selectedTimeZone1.text == '') {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Select Timezone!",
                                    );
                                  } else if (tlanguages.isEmpty) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Select Language!",
                                    );
                                  } else if (selectedGender.isEmpty) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Select Gender!",
                                    );
                                  } else if (citizenship.isEmpty) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Select Citizenship!",
                                    );
                                  } else if (studentIDNumber.isNotEmpty &&
                                      studentIDNumber != 'STU*********' &&
                                      firstname.text.isNotEmpty &&
                                      lastname.text.isNotEmpty &&
                                      age != 0 &&
                                      _selectedBirthCountryController
                                          .text.isNotEmpty &&
                                      birthtCity.text.isNotEmpty &&
                                      _selectedTimeZone1.text.isNotEmpty &&
                                      tlanguages.isNotEmpty) {
                                    CoolAlert.show(
                                        context: context,
                                        width: 200,
                                        barrierDismissible: false,
                                        type: CoolAlertType.loading,
                                        text: 'Uploading your data....');
                                    updateStudentInfo(
                                            widget.uid,
                                            selectedGender,
                                            citizenship,
                                            birthtCity.text,
                                            _selectedBirthCountryController
                                                .text,
                                            firstname.text,
                                            middlename.text,
                                            lastname.text,
                                            tlanguages,
                                            studentIDNumber,
                                            widget.uid,
                                            phoneNumber.phoneNumber.toString(),
                                            await uploadStudentProfile(
                                                widget.uid,
                                                selectedImage!,
                                                filename),
                                            DateTime.now(),
                                            age.toString(),
                                            bdate.toString(),
                                            _selectedTimeZone1.text,
                                            'completed')
                                        .then(
                                      (value) async {
                                        _auth.signOutAnon();
                                        deleteAllData();
                                        {
                                          GoRouter.of(context).go('/');
                                        }
                                      },
                                    );
                                  }
                                  //else {
                                  //   CoolAlert.show(
                                  //       context: context,
                                  //       width: 200,
                                  //       barrierDismissible: false,
                                  //       type: CoolAlertType.loading,
                                  //       text: 'Uploading your data....');
                                  //   updateStudentInfo(
                                  //           widget.uid,
                                  //           birthtCity.text,
                                  //           _selectedBirthCountryController
                                  //               .text,
                                  //           firstname.text,
                                  //           middlename.text,
                                  //           lastname.text,
                                  //           tlanguages,
                                  //           studentIDNumber,
                                  //           widget.uid,
                                  //           phoneNumber.phoneNumber.toString(),
                                  //           uploadStudentProfile(
                                  //               widget.uid,
                                  //               selectedImage!,
                                  //               filename) as String,
                                  //           DateTime.now(),
                                  //           age.toString(),
                                  //           bdate.toString(),
                                  //           _selectedTimeZone1.text,
                                  //           'unfinished')
                                  //       .then(
                                  //     (value) async {
                                  //       _auth.signOutAnon();
                                  //       deleteAllData();
                                  //       setState(() {
                                  //         CoolAlert.show(
                                  //           context: context,
                                  //           type: CoolAlertType.success,
                                  //           text: 'Sign up succesfully!',
                                  //           autoCloseDuration:
                                  //               const Duration(seconds: 1),
                                  //         ).then((value) =>
                                  //             Navigator.pushReplacement(
                                  //               context,
                                  //               MaterialPageRoute(
                                  //                   builder: (context) =>
                                  //                       const LoginPage()),
                                  //             ));
                                  //       });
                                  //     },
                                  //   );
                                  // }
                                } else if (age < 18 && age != 0) {
                                  if (firstname.text.isEmpty) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Firstname Required!",
                                    );
                                  } else if (termStatus == false) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      type: CoolAlertType.error,
                                      text: "Please accept terms & conditions!",
                                    );
                                  } else if (lastname.text == '') {
                                    CoolAlert.show(
                                      context: context,
                                      title: 'Error',
                                      width: 200,
                                      type: CoolAlertType.error,
                                      text: "Lastname Required!",
                                    );
                                  } else if (filename == '') {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Profile Picture Required!",
                                    );
                                  } else if (age == 0) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Select Birth Date!",
                                    );
                                  } else if (birthtCity.text == '') {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Input City!",
                                    );
                                  } else if (_selectedBirthCountryController
                                          .text ==
                                      '') {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Select Country!",
                                    );
                                  } else if (_selectedTimeZone1.text == '') {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Select Timezone!",
                                    );
                                  } else if (tlanguages.isEmpty) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Select Language!",
                                    );
                                  } else if (guardianfullname.text.isEmpty) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Input Guardian Fullname!",
                                    );
                                  } else if (guardianage.isEmpty ||
                                      guardianage == '0') {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Select Guardian Birthdate!",
                                    );
                                  } else if (guardiancontactnumber
                                      .text.isEmpty) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Input Contact Number!",
                                    );
                                  } else if (guadianfilename.isEmpty) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Select Guardian Picture!",
                                    );
                                  } else if (idfilenames.isEmpty) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please Upload ID Pictures!",
                                    );
                                  } else if (guardiansemail.text.isEmpty) {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      title: 'Error',
                                      type: CoolAlertType.error,
                                      text: "Please input Guradian Email!",
                                    );
                                  } else if (studentIDNumber.isNotEmpty &&
                                      studentIDNumber != 'STU*********' &&
                                      firstname.text.isNotEmpty &&
                                      lastname.text.isNotEmpty &&
                                      age != 0 &&
                                      _selectedBirthCountryController
                                          .text.isNotEmpty &&
                                      birthtCity.text.isNotEmpty &&
                                      _selectedTimeZone1.text.isNotEmpty &&
                                      tlanguages.isNotEmpty &&
                                      guardianfullname.text.isNotEmpty &&
                                      guardianage != '0' &&
                                      guardiancontactnumber.text.isNotEmpty &&
                                      guadianfilename.isNotEmpty &&
                                      guardiansemail.text.isNotEmpty &&
                                      idfilenames.isNotEmpty) {
                                    CoolAlert.show(
                                        context: context,
                                        width: 200,
                                        barrierDismissible: false,
                                        type: CoolAlertType.loading,
                                        text: 'Uploading your data....');
                                    updateStudentInfowGuardian(
                                            widget.uid,
                                            selectedGender,
                                            citizenship,
                                            birthtCity.text,
                                            _selectedBirthCountryController
                                                .text,
                                            firstname.text,
                                            middlename.text,
                                            lastname.text,
                                            tlanguages,
                                            studentIDNumber,
                                            widget.uid,
                                            phoneNumber.phoneNumber.toString(),
                                            await uploadStudentProfile(
                                                widget.uid,
                                                selectedImage!,
                                                filename),
                                            DateTime.now(),
                                            age.toString(),
                                            bdate.toString(),
                                            _selectedTimeZone1.text,
                                            guardianfullname.text,
                                            guardiancontactnumber.text,
                                            guardiansemail.text,
                                            guardianbdate,
                                            guardianage,
                                            'completed',
                                            await uploadGuardianIDList(
                                                widget.uid,
                                                'guardian',
                                                selectedIDfiles,
                                                idfilenames),
                                            await uploadGuardianProfile(
                                                widget.uid,
                                                guardianselectedImage!,
                                                'guardian',
                                                guadianfilename))
                                        .then(
                                      (value) async {
                                        _auth.signOutAnon();
                                        SendWelcomeEmailtoUser.sendMail(
                                            email: widget.email,
                                            name: firstname.text);
                                        deleteAllData();
                                        setState(() {
                                          CoolAlert.show(
                                            context: context,
                                            width: 200,
                                            type: CoolAlertType.success,
                                            text: 'Sign up succesfully!',
                                            autoCloseDuration:
                                                const Duration(seconds: 1),
                                          ).then((value) {
                                            GoRouter.of(context).go('/');
                                          });
                                        });
                                      },
                                    );
                                  }
                                  // else {
                                  //   CoolAlert.show(
                                  //       context: context,
                                  //       width: 200,
                                  //       barrierDismissible: false,
                                  //       type: CoolAlertType.loading,
                                  //       text: 'Uploading your data....');
                                  //   updateStudentInfowGuardian(
                                  //           widget.uid,
                                  //           birthtCity.text,
                                  //           _selectedBirthCountryController
                                  //               .text,
                                  //           firstname.text,
                                  //           middlename.text,
                                  //           lastname.text,
                                  //           tlanguages,
                                  //           studentIDNumber,
                                  //           widget.uid,
                                  //           phoneNumber.phoneNumber.toString(),
                                  //           await uploadStudentProfile(
                                  //               widget.uid,
                                  //               selectedImage!,
                                  //               filename),
                                  //           DateTime.now(),
                                  //           age.toString(),
                                  //           bdate.toString(),
                                  //           _selectedTimeZone1.text,
                                  //           guardianfullname.text,
                                  //           guardiancontactnumber.text,
                                  //           guardiansemail.text,
                                  //           guardianbdate,
                                  //           guardianage,
                                  //           'unfinished',
                                  //           await uploadGuardianIDList(
                                  //               widget.uid,
                                  //               'guardian',
                                  //               selectedIDfiles,
                                  //               idfilenames),
                                  //           await uploadGuardianProfile(
                                  //               widget.uid,
                                  //               guardianselectedImage!,
                                  //               'guardian',
                                  //               guadianfilename))
                                  //       .then(
                                  //     (value) async {
                                  //       _auth.signOutAnon();
                                  //       deleteAllData();
                                  //       Navigator.pushReplacement(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (context) =>
                                  //                 const LoginPage()),
                                  //       );
                                  //     },
                                  //   );
                                  // }
                                } else {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    title: 'Error',
                                    type: CoolAlertType.error,
                                    text: "Please Check Inputs!",
                                  );
                                }
                              },
                              child: const Text(
                                'Proceed Now',
                                style: TextStyle(
                                    color: kColorPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteAllData() async {
    final box = await Hive.openBox('userID');
    await box.clear();
  }

  // ignore: prefer_function_declarations_over_variables
  final languageBuilder = (language) => Text(language.name);

  Widget _buildDropdownItem(Country country) => Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              const SizedBox(
                width: 8.0,
              ),
              Text(country.name),
            ],
          ),
        ],
      );
}
