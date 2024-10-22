// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../../data_class/studentinfoclass.dart';
import '../../../../provider/update_tutor_provider.dart';
import '../../../../services/getlanguages.dart';
import '../../../../services/getstudentinfo.dart';
import '../../../../services/updatestudentinfo.dart';
import '../../../../shared_components/responsive_builder.dart';
import '../../../../utils/themes.dart';

class StudentInformation extends StatefulWidget {
  final String uID;
  final List<String> countryNames;
  final List<LanguageData> names;

  const StudentInformation(
      {super.key,
      required this.uID,
      required this.countryNames,
      required this.names});

  @override
  State<StudentInformation> createState() => _StudentInformationState();
}

class _StudentInformationState extends State<StudentInformation> {
  int? selectedindex;
  int? selectedgender;
  int? selectedcitizenship;

  //controllers
  TextEditingController confirstname = TextEditingController();
  TextEditingController conmiddlename = TextEditingController();
  TextEditingController conlastname = TextEditingController();
  TextEditingController conaddress = TextEditingController();
  TextEditingController concountry = TextEditingController();
  TextEditingController concontact = TextEditingController();
  TextEditingController conemailadd = TextEditingController();
  TextEditingController conemailacount = TextEditingController();
  TextEditingController conpassword = TextEditingController();
  TextEditingController connewpassword = TextEditingController();
  TextEditingController conconfirmpassword = TextEditingController();
  TextEditingController timezone = TextEditingController();

  List<String> languages = [];
  List<String> citizenships = [];

  //obscuretext
  bool obscurrent = true;
  bool obsnewpass = true;
  bool obsconfirm = true;

  //image
  String profileurl = '';
  String? downloadURL;
  String? downloadURL1;

  void updateResponse() async {
    String result = await getData();
    if (mounted) {
      setState(() {
        downloadURL1 = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTimezones();
  }

  @override
  void dispose() {
    // Cancel any ongoing asynchronous operations here
    super.dispose();
  }

  Future getData() async {
    try {
      await downloadURLExample(profileurl);
      return downloadURL;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<void> downloadURLExample(String path) async {
    downloadURL = await FirebaseStorage.instance.ref(path).getDownloadURL();
  }

  int newage = 0;

  void deleteLanguage(String language) {
    if (languages.contains(language)) {
      languages.remove(language);
    } else {}
  }

  Future<void> getTimezones() async {
    final response =
        await http.get(Uri.parse('http://worldtimeapi.org/api/timezone'));

    if (response.statusCode == 200) {
      final List<dynamic> timezones = json.decode(response.body);
      if (timezones.isNotEmpty) {
        setState(() {
          timezonesList = List<String>.from(timezones);
        });
      } else {
        throw Exception('No timezones found');
      }
    } else {
      throw Exception('Failed to load timezones: ${response.statusCode}');
    }
  }

  bool allowUpdate = false;
  String profilelink = '';
  Uint8List selectedImage = Uint8List(0);
  String filename = '';

// Function to select an image
  void selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        selectedImage = result.files.first.bytes!;
        filename = result.files.first.name;
      });
    }
  }

  String? data;
  ScrollController updatescrollController1 = ScrollController();

  List<String> newlanguages = [];
  List<dynamic> newselectedlanguages = [];
  List<String> timezonesList = [];
  List<Color> vibrantColors = [
    const Color.fromRGBO(185, 237, 221, 1),
    const Color.fromRGBO(135, 203, 185, 1),
    const Color.fromRGBO(86, 157, 170, 1),
    const Color.fromRGBO(87, 125, 134, 1),
  ];
  List<String> genders = ['Male', 'Female', 'Rather not say'];

  @override
  Widget build(BuildContext context) {
    final bool model = context.select((MyModel p) => p.updateDisplay);

    final studentinfodata = Provider.of<List<StudentInfoClass>>(context);
    const Color background = Color.fromRGBO(55, 116, 135, 1);
    const Color fill = Colors.white;

    const double fillPercent = 30; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    const List<double> stops = [0.0, fillStop, fillStop, 1.0];
    Size size = MediaQuery.of(context).size;
    if (downloadURL1 == null) {
      if (studentinfodata.isNotEmpty) {
        setState(() {
          final studentdata = studentinfodata.first;
          confirstname.text = studentdata.studentFirstname;
          conmiddlename.text = studentdata.studentMiddlename;
          conlastname.text = studentdata.studentLastname;
          concountry.text = studentdata.country;
          languages = studentdata.languages;
          citizenships = studentdata.citizenship;
          conaddress.text = studentdata.address;
          conemailadd.text = studentdata.emailadd;
          concontact.text = studentdata.contact;
          downloadURL1 = studentdata.profilelink;
          timezone.text = studentdata.timezone;
          newage = int.parse(calculateAge(
              DateFormat('MMMM dd, yyyy').parse(studentdata.dateofbirth)));
          for (var language in studentdata.languages) {
            if (!newlanguages.contains(language)) {
              newlanguages.add(language);
            }
          }
          // updateResponse();
        });
      }
    }
    return Stack(
      children: [
        Card(
          color: Colors.white,
          margin: EdgeInsets.zero,
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), // Adjust the radius as needed
              topRight: Radius.circular(10.0), // Adjust the radius as needed
            ),
          ),
          child: Container(
            alignment: Alignment.topCenter,
            width: size.width - 290,
            height: size.height - 140,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    Container(
                      width: ResponsiveBuilder.isDesktop(context)
                          ? size.width - 290
                          : size.width,
                      height: ResponsiveBuilder.isMobile(context) ? 200 : 250,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ...secondaryHeadercolors,
                              ...[Colors.white, Colors.white],
                            ],
                            stops: stops,
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: model == false
                              ? ResponsiveBuilder.isDesktop(context)
                                  ? const EdgeInsets.only(
                                      left: 250, top: 20, right: 20)
                                  : ResponsiveBuilder.isTablet(context)
                                      ? const EdgeInsets.only(
                                          left: 100, top: 20, right: 20)
                                      : const EdgeInsets.only(
                                          left: 10, top: 20, right: 10)
                              : ResponsiveBuilder.isDesktop(context)
                                  ? const EdgeInsets.only(
                                      left: 20, top: 20, right: 20)
                                  : ResponsiveBuilder.isTablet(context)
                                      ? const EdgeInsets.only(
                                          left: 20, top: 20, right: 20)
                                      : const EdgeInsets.only(
                                          left: 10, top: 20, right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: model
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 700,
                                child: Stack(children: [
                                  Container(
                                    height: 250,
                                    width: 250,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors
                                          .transparent, // You can adjust the fit as needed.
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: filename.isEmpty
                                          ? Image.network(
                                              downloadURL1!,
                                              fit: BoxFit
                                                  .cover, // You can adjust the fit as needed.
                                            )
                                          : Image.memory(
                                              selectedImage,
                                              fit: BoxFit
                                                  .cover, // You can adjust the fit as needed.
                                            ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: model,
                                    child: Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: SizedBox(
                                          width: 250,
                                          height: 40,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white60,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                            ),
                                            onPressed: () {
                                              selectImage();

                                              // if (filename != '' ||
                                              //     tutorfirstname.text !=
                                              //         tutorDataMap['firstName'] ||
                                              //     tutorlastname.text !=
                                              //         tutorDataMap['lastname'] ||
                                              //     tutormiddleName.text !=
                                              //         tutorDataMap['middleName'] ||
                                              //     birthdate !=
                                              //         DateTime.parse(tutorDataMap[
                                              //             'birthdate']) ||
                                              //     newage !=
                                              //         int.parse(
                                              //             tutorDataMap['age']) ||
                                              //     country.text !=
                                              //         tutorDataMap['country'] ||
                                              //     city.text !=
                                              //         tutorDataMap['city'] ||
                                              //     birthcountry.text !=
                                              //         tutorDataMap['birthPlace'] ||
                                              //     birthcity.text !=
                                              //         tutorDataMap['birthCity'] ||
                                              //     timezone.text !=
                                              //         tutorDataMap['timezone'] ||
                                              //     contactnumber.text !=
                                              //         tutorDataMap['contact'] ||
                                              //     selectedDate !=
                                              //         DateTime.parse(tutorDataMap[
                                              //             'birthdate']) ||
                                              //     areListsEqual == false) {
                                              //   setState(() {
                                              //     allowUpdate = true;
                                              //   });
                                              // } else {
                                              //   setState(() {
                                              //     allowUpdate = false;
                                              //   });
                                              // }
                                            },
                                            label: const Text(
                                              '',
                                              style: TextStyle(
                                                  color: kColorPrimary),
                                            ),
                                            icon: const Icon(
                                              Icons.camera_alt_outlined,
                                              size: 30,
                                              color: kColorPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                              Visibility(
                                  visible: model == false,
                                  child: const Spacer()),
                              Visibility(
                                visible: model == false,
                                child: TextButton.icon(
                                  onPressed: () {
                                    final provider = context.read<MyModel>();
                                    provider.updateBoolValue(true);
                                  },
                                  icon: const Icon(
                                    Icons.edit_document,
                                    color:
                                        kColorPrimaryDark, // Set the icon color to white
                                  ),
                                  label: const Text(
                                    'Edit',
                                    style: TextStyle(
                                      color:
                                          kColorPrimaryDark, // Set the text color to white
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Container(
                    //   width: ResponsiveBuilder.isDesktop(context)
                    //       ? size.width - 290
                    //       : size.width,
                    //   height: ResponsiveBuilder.isMobile(context) ? 200 : 250,
                    //   decoration: const BoxDecoration(
                    //       gradient: LinearGradient(
                    //         colors: [
                    //           ...secondaryHeadercolors,
                    //           ...[Colors.white, Colors.white],
                    //         ],
                    //         stops: stops,
                    //         end: Alignment.bottomCenter,
                    //         begin: Alignment.topCenter,
                    //       ),
                    //       borderRadius: BorderRadius.only(
                    //           topLeft: Radius.circular(15),
                    //           topRight: Radius.circular(15))),
                    //   child: Align(
                    //     alignment: Alignment.center,
                    //     child: Padding(
                    //       padding:
                    //           //  model == false
                    //           //     ?
                    //           ResponsiveBuilder.isDesktop(context)
                    //               ? const EdgeInsets.only(
                    //                   left: 250, top: 20, right: 20)
                    //               : ResponsiveBuilder.isTablet(context)
                    //                   ? const EdgeInsets.only(
                    //                       left: 100, top: 20, right: 20)
                    //                   : const EdgeInsets.only(
                    //                       left: 10, top: 20, right: 10),
                    //       // : ResponsiveBuilder.isDesktop(context)
                    //       //     ? const EdgeInsets.only(
                    //       //         left: 20, top: 20, right: 20)
                    //       //     : ResponsiveBuilder.isTablet(context)
                    //       //         ? const EdgeInsets.only(
                    //       //             left: 20, top: 20, right: 20)
                    //       //         : const EdgeInsets.only(
                    //       //             left: 10, top: 20, right: 10),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.stretch,
                    //         children: [
                    //           Flexible(
                    //             flex: 10,
                    //             child: SingleChildScrollView(
                    //               controller: ScrollController(),
                    //               child: Align(
                    //                 alignment: Alignment.topLeft,
                    //                 child: Column(
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                   mainAxisAlignment: MainAxisAlignment.start,
                    //                   children: [
                    //                     Padding(
                    //                       padding: const EdgeInsets.only(
                    //                           left: 200.0, right: 200, top: 20),
                    //                       child: Container(
                    //                         height: 250,
                    //                         width: 250,
                    //                         decoration: BoxDecoration(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(10),
                    //                             color: Colors.transparent,
                    //                             image: DecorationImage(
                    //                                 image: NetworkImage(
                    //                                   downloadURL1.toString(),
                    //                                 ),
                    //                                 fit: BoxFit.cover)),
                    //                         child: Align(
                    //                           alignment: Alignment.bottomCenter,
                    //                           child: SizedBox(
                    //                             width: 250,
                    //                             height: 40,
                    //                             child: ElevatedButton.icon(
                    //                               style: ElevatedButton.styleFrom(
                    //                                 backgroundColor: Colors.white60,
                    //                                 shape: const RoundedRectangleBorder(
                    //                                     borderRadius:
                    //                                         BorderRadius.only(
                    //                                             bottomLeft: Radius
                    //                                                 .circular(10),
                    //                                             bottomRight:
                    //                                                 Radius.circular(
                    //                                                     10))),
                    //                               ),
                    //                               onPressed: () {
                    //                                 setState(() {
                    //                                   updateImage(
                    //                                       widget.uID, profileurl);
                    //                                 });
                    //                               },
                    //                               label: const Text(
                    //                                 '',
                    //                                 style: TextStyle(
                    //                                     color: kColorPrimary),
                    //                               ),
                    //                               icon: const Icon(
                    //                                 Icons.camera_alt_outlined,
                    //                                 size: 30,
                    //                                 color: kColorPrimary,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    Padding(
                      padding: ResponsiveBuilder.isDesktop(context)
                          ? const EdgeInsets.only(left: 250, top: 20, right: 20)
                          : ResponsiveBuilder.isTablet(context)
                              ? const EdgeInsets.only(
                                  left: 100, top: 20, right: 20)
                              : const EdgeInsets.only(
                                  left: 10, top: 20, right: 10),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(),
                      ),
                    ),
                    model
                        ? Container(
                            alignment: Alignment.center,
                            width: size.width - 320,
                            padding: ResponsiveBuilder.isDesktop(context)
                                ? const EdgeInsets.only(
                                    left: 20, top: 20, right: 20)
                                : ResponsiveBuilder.isTablet(context)
                                    ? const EdgeInsets.only(
                                        left: 20, top: 20, right: 20)
                                    : const EdgeInsets.only(
                                        left: 10, top: 20, right: 10),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: 700,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 220,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'First Name',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(
                                            color: Colors.white,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 220,
                                              height: 45,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: TextFormField(
                                                  enabled: false,
                                                  controller: confirstname,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                        Colors.grey.shade200,
                                                    hintText: 'Firstname',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Rounded border
                                                      borderSide: BorderSide
                                                          .none, // No outline border
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                      color: kColorGrey),
                                                  onChanged: (value) {
                                                    // Your onChanged logic here
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 220,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Middle Name',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(
                                            color: Colors.white,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 220,
                                              height: 45,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: TextFormField(
                                                  enabled: false,

                                                  controller: conmiddlename,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                        Colors.grey.shade200,
                                                    hintText: '(Optional)',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Rounded border
                                                      borderSide: BorderSide
                                                          .none, // No outline border
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                      color: kColorGrey),
                                                  // validator: (val) => val!.isEmpty
                                                  //     ? 'Enter a middlename'
                                                  //     : null,
                                                  onChanged: (value) {
                                                    // bool areListsEqual = listEquals(
                                                    //   newlanguages,
                                                    //   (tutorDataMap['language']
                                                    //           as List<dynamic>)
                                                    //       .cast<dynamic>(),
                                                    // );
                                                    // if (filename != '' ||
                                                    //     tutorfirstname.text !=
                                                    //         tutorDataMap[
                                                    //             'firstName'] ||
                                                    //     tutorlastname.text !=
                                                    //         tutorDataMap[
                                                    //             'lastname'] ||
                                                    //     tutormiddleName.text !=
                                                    //         tutorDataMap[
                                                    //             'middleName'] ||
                                                    //     birthdate !=
                                                    //         DateTime.parse(
                                                    //             tutorDataMap[
                                                    //                 'birthdate']) ||
                                                    //     newage !=
                                                    //         int.parse(tutorDataMap[
                                                    //             'age']) ||
                                                    //     country.text !=
                                                    //         tutorDataMap[
                                                    //             'country'] ||
                                                    //     city.text !=
                                                    //         tutorDataMap['city'] ||
                                                    //     birthcountry.text !=
                                                    //         tutorDataMap[
                                                    //             'birthPlace'] ||
                                                    //     birthcity.text !=
                                                    //         tutorDataMap[
                                                    //             'birthCity'] ||
                                                    //     timezone.text !=
                                                    //         tutorDataMap[
                                                    //             'timezone'] ||
                                                    //     contactnumber.text !=
                                                    //         tutorDataMap[
                                                    //             'contact'] ||
                                                    //     selectedDate !=
                                                    //         DateTime.parse(
                                                    //             tutorDataMap[
                                                    //                 'birthdate']) ||
                                                    //     areListsEqual == false) {
                                                    //   setState(() {
                                                    //     allowUpdate = true;
                                                    //   });
                                                    // } else {
                                                    //   setState(() {
                                                    //     allowUpdate = false;
                                                    //   });
                                                    // }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 220,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Last Name',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(
                                            color: Colors.white,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 220,
                                              height: 45,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: TextFormField(
                                                  enabled: false,
                                                  controller: conlastname,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                        Colors.grey.shade200,
                                                    hintText: 'Lastname',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Rounded border
                                                      borderSide: BorderSide
                                                          .none, // No outline border
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                      color: kColorGrey),
                                                  onChanged: (value) {
                                                    // bool areListsEqual = listEquals(
                                                    //   newlanguages,
                                                    //   (tutorDataMap['language']
                                                    //           as List<dynamic>)
                                                    //       .cast<dynamic>(),
                                                    // );
                                                    // if (filename != '' ||
                                                    //     tutorfirstname.text !=
                                                    //         tutorDataMap[
                                                    //             'firstName'] ||
                                                    //     tutorlastname.text !=
                                                    //         tutorDataMap[
                                                    //             'lastname'] ||
                                                    //     tutormiddleName.text !=
                                                    //         tutorDataMap[
                                                    //             'middleName'] ||
                                                    //     birthdate !=
                                                    //         DateTime.parse(
                                                    //             tutorDataMap[
                                                    //                 'birthdate']) ||
                                                    //     newage !=
                                                    //         int.parse(tutorDataMap[
                                                    //             'age']) ||
                                                    //     country.text !=
                                                    //         tutorDataMap[
                                                    //             'country'] ||
                                                    //     city.text !=
                                                    //         tutorDataMap['city'] ||
                                                    //     birthcountry.text !=
                                                    //         tutorDataMap[
                                                    //             'birthPlace'] ||
                                                    //     birthcity.text !=
                                                    //         tutorDataMap[
                                                    //             'birthCity'] ||
                                                    //     timezone.text !=
                                                    //         tutorDataMap[
                                                    //             'timezone'] ||
                                                    //     contactnumber.text !=
                                                    //         tutorDataMap[
                                                    //             'contact'] ||
                                                    //     selectedDate !=
                                                    //         DateTime.parse(
                                                    //             tutorDataMap[
                                                    //                 'birthdate']) ||
                                                    //     areListsEqual == false) {
                                                    //   setState(() {
                                                    //     allowUpdate = true;
                                                    //   });
                                                    // } else {
                                                    //   setState(() {
                                                    //     allowUpdate = false;
                                                    //   });
                                                    // }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 400,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Date of Birth',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(
                                            color: Colors.white,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: Container(
                                              width: 400,
                                              height: 45,
                                              color: Colors.grey.shade200,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 5, 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    studentinfodata
                                                        .first.dateofbirth,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: kColorGrey),
                                                  ),
                                                  const Spacer(),
                                                  const IconButton(
                                                    hoverColor:
                                                        Colors.transparent,
                                                    icon: Icon(
                                                      EvaIcons.calendarOutline,
                                                      color: kColorPrimary,
                                                      size: 25,
                                                    ),
                                                    onPressed: null,
                                                    // onPressed: () {
                                                    //   _selectDate();
                                                    //   bool areListsEqual = listEquals(
                                                    //     newlanguages,
                                                    //     (tutorDataMap['language']
                                                    //             as List<dynamic>)
                                                    //         .cast<dynamic>(),
                                                    //   );
                                                    //   if (filename != '' ||
                                                    //       tutorfirstname.text !=
                                                    //           tutorDataMap[
                                                    //               'firstName'] ||
                                                    //       tutorlastname.text !=
                                                    //           tutorDataMap[
                                                    //               'lastname'] ||
                                                    //       tutormiddleName.text !=
                                                    //           tutorDataMap[
                                                    //               'middleName'] ||
                                                    //       birthdate !=
                                                    //           DateTime.parse(
                                                    //               tutorDataMap[
                                                    //                   'birthdate']) ||
                                                    //       newage !=
                                                    //           int.parse(tutorDataMap[
                                                    //               'age']) ||
                                                    //       country.text !=
                                                    //           tutorDataMap[
                                                    //               'country'] ||
                                                    //       city.text !=
                                                    //           tutorDataMap['city'] ||
                                                    //       birthcountry.text !=
                                                    //           tutorDataMap[
                                                    //               'birthPlace'] ||
                                                    //       birthcity.text !=
                                                    //           tutorDataMap[
                                                    //               'birthCity'] ||
                                                    //       timezone.text !=
                                                    //           tutorDataMap[
                                                    //               'timezone'] ||
                                                    //       contactnumber.text !=
                                                    //           tutorDataMap[
                                                    //               'contact'] ||
                                                    //       selectedDate !=
                                                    //           DateTime.parse(
                                                    //               tutorDataMap[
                                                    //                   'birthdate']) ||
                                                    //       areListsEqual == false) {
                                                    //     setState(() {
                                                    //       allowUpdate = true;
                                                    //     });
                                                    //   } else {
                                                    //     setState(() {
                                                    //       allowUpdate = false;
                                                    //     });
                                                    //   }
                                                    // },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 270,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Age',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(
                                            color: Colors.white,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: Container(
                                              width: 100,
                                              height: 45,
                                              color: Colors.grey.shade200,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 5, 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    newage.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: kColorGrey),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 270,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Gender',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(
                                            color: Colors.white,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: Container(
                                              width: 100,
                                              height: 45,
                                              color: Colors.grey.shade200,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 5, 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    studentinfodata
                                                        .first.gender,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: kColorGrey),
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 680,
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 10, 5),
                                        decoration: BoxDecoration(
                                          // color: const Color.fromRGBO(
                                          //     55, 116, 135, 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Citizenships',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: kColorLight),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Card(
                                            color: Colors.white,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 270,
                                              height: 45,
                                              child: TypeAheadFormField<String>(
                                                // Specify LanguageData as the generic type
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  decoration: InputDecoration(
                                                    hintText: 'Add Citizenship',
                                                    labelStyle: const TextStyle(
                                                        color: Colors.grey),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Rounded border
                                                      borderSide: BorderSide
                                                          .none, // No outline border
                                                    ),
                                                    suffixIcon: const Icon(
                                                        Icons.arrow_drop_down),
                                                  ),
                                                ),
                                                suggestionsCallback:
                                                    (String pattern) {
                                                  return widget.countryNames
                                                      .where((country) => country
                                                          .toLowerCase()
                                                          .contains(pattern
                                                              .toLowerCase()));
                                                },
                                                itemBuilder: (context,
                                                    String suggestion) {
                                                  return ListTile(
                                                    title: Text(suggestion),
                                                  );
                                                },
                                                onSuggestionSelected:
                                                    (suggestion) {
                                                  if (citizenships
                                                      .contains(suggestion)) {
                                                    null;
                                                  } else {
                                                    setState(() {
                                                      citizenships.add(
                                                          suggestion
                                                              .toString());
                                                    });
                                                  }
                                                  // bool areListsEqual = listEquals(
                                                  //   newlanguages,
                                                  //   (tutorDataMap['language']
                                                  //           as List<dynamic>)
                                                  //       .cast<dynamic>(),
                                                  // );
                                                  // if (filename != '' ||
                                                  //     tutorfirstname.text !=
                                                  //         tutorDataMap[
                                                  //             'firstName'] ||
                                                  //     tutorlastname.text !=
                                                  //         tutorDataMap[
                                                  //             'lastname'] ||
                                                  //     tutormiddleName.text !=
                                                  //         tutorDataMap[
                                                  //             'middleName'] ||
                                                  //     birthdate !=
                                                  //         DateTime.parse(
                                                  //             tutorDataMap[
                                                  //                 'birthdate']) ||
                                                  //     newage !=
                                                  //         int.parse(tutorDataMap[
                                                  //             'age']) ||
                                                  //     country.text !=
                                                  //         tutorDataMap['country'] ||
                                                  //     city.text !=
                                                  //         tutorDataMap['city'] ||
                                                  //     birthcountry.text !=
                                                  //         tutorDataMap[
                                                  //             'birthPlace'] ||
                                                  //     birthcity.text !=
                                                  //         tutorDataMap[
                                                  //             'birthCity'] ||
                                                  //     timezone.text !=
                                                  //         tutorDataMap[
                                                  //             'timezone'] ||
                                                  //     contactnumber.text !=
                                                  //         tutorDataMap['contact'] ||
                                                  //     selectedDate !=
                                                  //         DateTime.parse(
                                                  //             tutorDataMap[
                                                  //                 'birthdate']) ||
                                                  //     areListsEqual == false) {
                                                  //   setState(() {
                                                  //     allowUpdate = true;
                                                  //   });
                                                  // } else {
                                                  //   setState(() {
                                                  //     allowUpdate = false;
                                                  //   });
                                                  // }
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Tooltip(
                                            message: 'Remove Citizenship',
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: -4,
                                                      vertical: -4),
                                              icon: const Icon(Icons
                                                  .delete_outline_outlined),
                                              color: kCalendarColorB,
                                              iconSize: 30,
                                              onPressed:
                                                  selectedcitizenship == null
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            citizenships.removeAt(
                                                                selectedcitizenship!);
                                                          });
                                                        },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        child: SizedBox(
                                          height: 50,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
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
                                                  updatescrollController1
                                                      .animateTo(
                                                    updatescrollController1
                                                            .offset -
                                                        100.0, // Adjust the value as needed
                                                    duration: const Duration(
                                                        milliseconds:
                                                            500), // Adjust the duration as needed
                                                    curve: Curves.ease,
                                                  );
                                                },
                                              ),
                                              Container(
                                                width: 550,
                                                height: 45,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                child: ListView.builder(
                                                    controller:
                                                        updatescrollController1,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        citizenships.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10.0,
                                                                right: 10),
                                                        child: Card(
                                                          color: Colors.white,
                                                          margin:
                                                              EdgeInsets.zero,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          elevation: 5,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    5, 0, 5, 0),
                                                            decoration: selectedcitizenship ==
                                                                    index
                                                                ? const BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: Colors
                                                                              .black12,
                                                                          offset: Offset(
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
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(15)),
                                                                  )
                                                                : const BoxDecoration(
                                                                    boxShadow: [
                                                                        BoxShadow(
                                                                            color: Colors
                                                                                .black12,
                                                                            offset: Offset(0,
                                                                                4),
                                                                            blurRadius:
                                                                                5.0)
                                                                      ],
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            15)),
                                                                    color: Colors
                                                                        .white),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedcitizenship ==
                                                                            index
                                                                        ? selectedcitizenship =
                                                                            null
                                                                        : selectedcitizenship =
                                                                            index;
                                                                  });
                                                                },
                                                                child: Center(
                                                                  child: Text(
                                                                    citizenships[
                                                                        index],
                                                                    style: TextStyle(
                                                                        color: selectedgender ==
                                                                                index
                                                                            ? Colors.white
                                                                            : kColorGrey),
                                                                  ),
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
                                                  updatescrollController1
                                                      .animateTo(
                                                    updatescrollController1
                                                            .offset +
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
                                      ),
                                    ],
                                  ),

                                  // const SizedBox(
                                  //   height: 15,
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         Container(
                                  //           width: 370,
                                  //           padding: const EdgeInsets.fromLTRB(
                                  //               0, 5, 10, 5),
                                  //           decoration: BoxDecoration(
                                  //             // color: const Color.fromRGBO(
                                  //             //     55, 116, 135, 1),
                                  //             borderRadius:
                                  //                 BorderRadius.circular(5),
                                  //           ),
                                  //           child: const Align(
                                  //             alignment: Alignment.centerLeft,
                                  //             child: Text(
                                  //               'Country of Birth',
                                  //               style: TextStyle(
                                  //                   fontWeight: FontWeight.w600,
                                  //                   color: kColorLight),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Card(
                                  //           margin: EdgeInsets.zero,
                                  //           shape: RoundedRectangleBorder(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(10),
                                  //           ),
                                  //           elevation: 5,
                                  //           child: SizedBox(
                                  //             width: 370,
                                  //             height: 45,

                                  //             child: TypeAheadFormField<String>(
                                  //               enabled: false,
                                  //               textFieldConfiguration:
                                  //                   TextFieldConfiguration(
                                  //                 enabled: false,
                                  //                 style: const TextStyle(
                                  //                     color: kColorGrey),
                                  //                 controller: concountry,
                                  //                 decoration: InputDecoration(
                                  //                   hintText: 'Select a Country',
                                  //                   hintStyle: const TextStyle(
                                  //                       color: Colors.grey),
                                  //                   labelStyle: const TextStyle(
                                  //                       color: Colors.grey),
                                  //                   contentPadding:
                                  //                       const EdgeInsets.symmetric(
                                  //                           vertical: 12,
                                  //                           horizontal: 10),
                                  //                   border: OutlineInputBorder(
                                  //                     borderRadius:
                                  //                         BorderRadius.circular(
                                  //                             10.0), // Rounded border
                                  //                     borderSide: BorderSide
                                  //                         .none, // No outline border
                                  //                   ),
                                  //                   suffixIcon: const Icon(
                                  //                       Icons.arrow_drop_down),
                                  //                 ),
                                  //               ),
                                  //               suggestionsCallback:
                                  //                   (String pattern) {
                                  //                 return widget.countryNames.where(
                                  //                     (country) => country
                                  //                         .toLowerCase()
                                  //                         .contains(pattern
                                  //                             .toLowerCase()));
                                  //               },
                                  //               itemBuilder:
                                  //                   (context, String suggestion) {
                                  //                 return ListTile(
                                  //                   title: Text(suggestion),
                                  //                 );
                                  //               },
                                  //               onSuggestionSelected:
                                  //                   (String suggestion) {
                                  //                 concountry.text = suggestion;
                                  //                 bool areListsEqual = listEquals(
                                  //                   newlanguages,
                                  //                   (studentinfodata
                                  //                           .first.languages)
                                  //                       .cast<dynamic>(),
                                  //                 );
                                  //                 // if (filename != '' ||
                                  //                 //     tutorfirstname.text !=
                                  //                 //         tutorDataMap[
                                  //                 //             'firstName'] ||
                                  //                 //     tutorlastname.text !=
                                  //                 //         tutorDataMap[
                                  //                 //             'lastname'] ||
                                  //                 //     tutormiddleName.text !=
                                  //                 //         tutorDataMap[
                                  //                 //             'middleName'] ||
                                  //                 //     birthdate !=
                                  //                 //         DateTime.parse(
                                  //                 //             tutorDataMap[
                                  //                 //                 'birthdate']) ||
                                  //                 //     newage !=
                                  //                 //         int.parse(tutorDataMap[
                                  //                 //             'age']) ||
                                  //                 //     country.text !=
                                  //                 //         tutorDataMap['country'] ||
                                  //                 //     city.text !=
                                  //                 //         tutorDataMap['city'] ||
                                  //                 //     birthcountry.text !=
                                  //                 //         tutorDataMap[
                                  //                 //             'birthPlace'] ||
                                  //                 //     birthcity.text !=
                                  //                 //         tutorDataMap[
                                  //                 //             'birthCity'] ||
                                  //                 //     timezone.text !=
                                  //                 //         tutorDataMap[
                                  //                 //             'timezone'] ||
                                  //                 //     contactnumber.text !=
                                  //                 //         tutorDataMap['contact'] ||
                                  //                 //     selectedDate !=
                                  //                 //         DateTime.parse(
                                  //                 //             tutorDataMap[
                                  //                 //                 'birthdate']) ||
                                  //                 //     areListsEqual == false) {
                                  //                 //   setState(() {
                                  //                 //     allowUpdate = true;
                                  //                 //   });
                                  //                 // } else {
                                  //                 //   setState(() {
                                  //                 //     allowUpdate = false;
                                  //                 //   });
                                  //                 // }
                                  //               },
                                  //             ),
                                  //             // country.name
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     // const SizedBox(
                                  //     //   width: 10,
                                  //     // ),
                                  //     // Column(
                                  //     //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //     //   children: [
                                  //     //     Container(
                                  //     //       width: 300,
                                  //     //       padding: const EdgeInsets.fromLTRB(
                                  //     //           10, 5, 10, 5),
                                  //     //       decoration: BoxDecoration(
                                  //     //         // color: const Color.fromRGBO(
                                  //     //         //     55, 116, 135, 1),
                                  //     //         borderRadius: BorderRadius.circular(5),
                                  //     //       ),
                                  //     //       child: const Align(
                                  //     //         alignment: Alignment.centerLeft,
                                  //     //         child: Text(
                                  //     //           'City of Birth',
                                  //     //           style: TextStyle(
                                  //     //               fontWeight: FontWeight.w600,
                                  //     //               color: kColorLight),
                                  //     //         ),
                                  //     //       ),
                                  //     //     ),
                                  //     //     Card(
                                  //     //       margin: EdgeInsets.zero,
                                  //     //       shape: RoundedRectangleBorder(
                                  //     //         borderRadius: BorderRadius.circular(10),
                                  //     //       ),
                                  //     //       elevation: 5,
                                  //     //       child: Container(
                                  //     //         width: 300,
                                  //     //         height: 45,
                                  //     //         child: TextFormField(
                                  //     //           controller: birthcity,
                                  //     //           decoration: InputDecoration(
                                  //     //             fillColor: Colors.grey,
                                  //     //             hintText: 'City',
                                  //     //             hintStyle: const TextStyle(
                                  //     //                 color: Colors.grey,
                                  //     //                 fontSize: 15),
                                  //     //             contentPadding:
                                  //     //                 const EdgeInsets.symmetric(
                                  //     //                     vertical: 12,
                                  //     //                     horizontal: 10),
                                  //     //             border: OutlineInputBorder(
                                  //     //               borderRadius:
                                  //     //                   BorderRadius.circular(
                                  //     //                       10.0), // Rounded border
                                  //     //               borderSide: BorderSide
                                  //     //                   .none, // No outline border
                                  //     //             ),
                                  //     //           ),
                                  //     //           style: const TextStyle(
                                  //     //               color: kColorGrey),
                                  //     //           onChanged: (value) {
                                  //     //             bool areListsEqual = listEquals(
                                  //     //               newlanguages,
                                  //     //               (tutorDataMap['language']
                                  //     //                       as List<dynamic>)
                                  //     //                   .cast<dynamic>(),
                                  //     //             );
                                  //     //             if (filename != '' ||
                                  //     //                 tutorfirstname.text !=
                                  //     //                     tutorDataMap['firstName'] ||
                                  //     //                 tutorlastname.text !=
                                  //     //                     tutorDataMap['lastname'] ||
                                  //     //                 tutormiddleName.text !=
                                  //     //                     tutorDataMap[
                                  //     //                         'middleName'] ||
                                  //     //                 birthdate !=
                                  //     //                     DateTime.parse(tutorDataMap[
                                  //     //                         'birthdate']) ||
                                  //     //                 newage !=
                                  //     //                     int.parse(
                                  //     //                         tutorDataMap['age']) ||
                                  //     //                 country.text !=
                                  //     //                     tutorDataMap['country'] ||
                                  //     //                 city.text !=
                                  //     //                     tutorDataMap['city'] ||
                                  //     //                 birthcountry.text !=
                                  //     //                     tutorDataMap[
                                  //     //                         'birthPlace'] ||
                                  //     //                 birthcity.text !=
                                  //     //                     tutorDataMap['birthCity'] ||
                                  //     //                 timezone.text !=
                                  //     //                     tutorDataMap['timezone'] ||
                                  //     //                 contactnumber.text !=
                                  //     //                     tutorDataMap['contact'] ||
                                  //     //                 selectedDate !=
                                  //     //                     DateTime.parse(tutorDataMap[
                                  //     //                         'birthdate']) ||
                                  //     //                 areListsEqual == false) {
                                  //     //               setState(() {
                                  //     //                 allowUpdate = true;
                                  //     //               });
                                  //     //             } else {
                                  //     //               setState(() {
                                  //     //                 allowUpdate = false;
                                  //     //               });
                                  //     //             }
                                  //     //           },
                                  //     //         ),
                                  //     //       ),
                                  //     //     ),
                                  //     //   ],
                                  //     // ),
                                  //   ],
                                  // ),

                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 370,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Country of Residence',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(
                                            color: Colors.white,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 370,
                                              height: 45,
                                              child: TypeAheadFormField<String>(
                                                enabled: false,
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  style: const TextStyle(
                                                      color: kColorGrey),
                                                  controller: concountry,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Select a Country',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey),
                                                    labelStyle: const TextStyle(
                                                        color: Colors.grey),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Rounded border
                                                      borderSide: BorderSide
                                                          .none, // No outline border
                                                    ),
                                                    suffixIcon: const Icon(
                                                        Icons.arrow_drop_down),
                                                  ),
                                                ),
                                                suggestionsCallback:
                                                    (String pattern) {
                                                  return widget.countryNames
                                                      .where((country) => country
                                                          .toLowerCase()
                                                          .contains(pattern
                                                              .toLowerCase()));
                                                },
                                                itemBuilder: (context,
                                                    String suggestion) {
                                                  return ListTile(
                                                    title: Text(suggestion),
                                                  );
                                                },
                                                onSuggestionSelected:
                                                    (String suggestion) {
                                                  concountry.text = suggestion;

                                                  // bool areListsEqual = listEquals(
                                                  //   newlanguages,
                                                  //   (tutorDataMap['language']
                                                  //           as List<dynamic>)
                                                  //       .cast<dynamic>(),
                                                  // );
                                                  // if (filename != '' ||
                                                  //     tutorfirstname.text !=
                                                  //         tutorDataMap[
                                                  //             'firstName'] ||
                                                  //     tutorlastname.text !=
                                                  //         tutorDataMap[
                                                  //             'lastname'] ||
                                                  //     tutormiddleName.text !=
                                                  //         tutorDataMap[
                                                  //             'middleName'] ||
                                                  //     birthdate !=
                                                  //         DateTime.parse(
                                                  //             tutorDataMap[
                                                  //                 'birthdate']) ||
                                                  //     newage !=
                                                  //         int.parse(tutorDataMap[
                                                  //             'age']) ||
                                                  //     country.text !=
                                                  //         tutorDataMap['country'] ||
                                                  //     city.text !=
                                                  //         tutorDataMap['city'] ||
                                                  //     birthcountry.text !=
                                                  //         tutorDataMap[
                                                  //             'birthPlace'] ||
                                                  //     birthcity.text !=
                                                  //         tutorDataMap[
                                                  //             'birthCity'] ||
                                                  //     timezone.text !=
                                                  //         tutorDataMap[
                                                  //             'timezone'] ||
                                                  //     contactnumber.text !=
                                                  //         tutorDataMap['contact'] ||
                                                  //     selectedDate !=
                                                  //         DateTime.parse(
                                                  //             tutorDataMap[
                                                  //                 'birthdate']) ||
                                                  //     areListsEqual == false) {
                                                  //   setState(() {
                                                  //     allowUpdate = true;
                                                  //   });
                                                  // } else {
                                                  //   setState(() {
                                                  //     allowUpdate = false;
                                                  //   });
                                                  // }
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 300,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              // color: const Color.fromRGBO(
                                              //     55, 116, 135, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'City of Residence',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorLight),
                                              ),
                                            ),
                                          ),
                                          Card(
                                            color: Colors.white,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 300,
                                              height: 45,
                                              child: TextFormField(
                                                controller: conaddress,
                                                decoration: InputDecoration(
                                                  fillColor: Colors.grey,
                                                  hintText: 'City',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12,
                                                          horizontal: 10),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Rounded border
                                                    borderSide: BorderSide
                                                        .none, // No outline border
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                    color: kColorGrey),
                                                onChanged: (value) {
                                                  // bool areListsEqual = listEquals(
                                                  //   newlanguages,
                                                  //   (tutorDataMap['language']
                                                  //           as List<dynamic>)
                                                  //       .cast<dynamic>(),
                                                  // );
                                                  // if (filename != '' ||
                                                  //     tutorfirstname.text !=
                                                  //         tutorDataMap[
                                                  //             'firstName'] ||
                                                  //     tutorlastname.text !=
                                                  //         tutorDataMap[
                                                  //             'lastname'] ||
                                                  //     tutormiddleName.text !=
                                                  //         tutorDataMap[
                                                  //             'middleName'] ||
                                                  //     birthdate !=
                                                  //         DateTime.parse(
                                                  //             tutorDataMap[
                                                  //                 'birthdate']) ||
                                                  //     newage !=
                                                  //         int.parse(tutorDataMap[
                                                  //             'age']) ||
                                                  //     country.text !=
                                                  //         tutorDataMap['country'] ||
                                                  //     city.text !=
                                                  //         tutorDataMap['city'] ||
                                                  //     birthcountry.text !=
                                                  //         tutorDataMap[
                                                  //             'birthPlace'] ||
                                                  //     birthcity.text !=
                                                  //         tutorDataMap[
                                                  //             'birthCity'] ||
                                                  //     timezone.text !=
                                                  //         tutorDataMap[
                                                  //             'timezone'] ||
                                                  //     contactnumber.text !=
                                                  //         tutorDataMap['contact'] ||
                                                  //     selectedDate !=
                                                  //         DateTime.parse(
                                                  //             tutorDataMap[
                                                  //                 'birthdate']) ||
                                                  //     areListsEqual == false) {
                                                  //   setState(() {
                                                  //     allowUpdate = true;
                                                  //   });
                                                  // } else {
                                                  //   setState(() {
                                                  //     allowUpdate = false;
                                                  //   });
                                                  // }
                                                },
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
                                  Row(children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 370,
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 10, 5),
                                          decoration: BoxDecoration(
                                            // color:
                                            //     const Color.fromRGBO(55, 116, 135, 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Timezone',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: kColorLight),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: Colors.white,
                                          margin: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 5,
                                          child: SizedBox(
                                            width: 370,
                                            height: 45,
                                            child: TypeAheadFormField<String>(
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                style: const TextStyle(
                                                    color: kColorGrey),
                                                controller: timezone,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Select your Timezone',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey),
                                                  labelStyle: const TextStyle(
                                                      color: Colors.grey),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12,
                                                          horizontal: 10),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Rounded border
                                                    borderSide: BorderSide
                                                        .none, // No outline border
                                                  ),
                                                  suffixIcon: const Icon(
                                                      Icons.arrow_drop_down),
                                                ),
                                              ),
                                              suggestionsCallback:
                                                  (String pattern) {
                                                return timezonesList.where(
                                                    (timezone) => timezone
                                                        .toLowerCase()
                                                        .contains(pattern
                                                            .toLowerCase()));
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
                                                // setState(() {
                                                timezone.text = suggestion;
                                                //   bool areListsEqual = listEquals(
                                                //     newlanguages,
                                                //     (tutorDataMap['language']
                                                //             as List<dynamic>)
                                                //         .cast<dynamic>(),
                                                //   );
                                                //   if (filename != '' ||
                                                //       tutorfirstname.text !=
                                                //           tutorDataMap[
                                                //               'firstName'] ||
                                                //       tutorlastname.text !=
                                                //           tutorDataMap[
                                                //               'lastname'] ||
                                                //       tutormiddleName.text !=
                                                //           tutorDataMap[
                                                //               'middleName'] ||
                                                //       birthdate !=
                                                //           DateTime.parse(
                                                //               tutorDataMap[
                                                //                   'birthdate']) ||
                                                //       newage !=
                                                //           int.parse(tutorDataMap[
                                                //               'age']) ||
                                                //       country.text !=
                                                //           tutorDataMap['country'] ||
                                                //       city.text !=
                                                //           tutorDataMap['city'] ||
                                                //       birthcountry.text !=
                                                //           tutorDataMap[
                                                //               'birthPlace'] ||
                                                //       birthcity.text !=
                                                //           tutorDataMap[
                                                //               'birthCity'] ||
                                                //       timezone.text !=
                                                //           tutorDataMap[
                                                //               'timezone'] ||
                                                //       contactnumber.text !=
                                                //           tutorDataMap['contact'] ||
                                                //       selectedDate !=
                                                //           DateTime.parse(
                                                //               tutorDataMap[
                                                //                   'birthdate']) ||
                                                //       areListsEqual == false) {
                                                //     setState(() {
                                                //       allowUpdate = true;
                                                //     });
                                                //   } else {
                                                //     setState(() {
                                                //       allowUpdate = false;
                                                //     });
                                                //   }
                                                // });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 300,
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 10, 5),
                                          decoration: BoxDecoration(
                                            // color:
                                            //     const Color.fromRGBO(55, 116, 135, 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Contact Number',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: kColorLight),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: Colors.white,
                                          margin: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 5,
                                          child: SizedBox(
                                            width: 300,
                                            height: 45,
                                            child: TextFormField(
                                              controller: concontact,
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey,
                                                hintText: 'Contact Number',
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 10),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // Rounded border
                                                  borderSide: BorderSide
                                                      .none, // No outline border
                                                ),
                                              ),
                                              style: const TextStyle(
                                                  color: kColorGrey),
                                              onChanged: (value) {
                                                // bool areListsEqual = listEquals(
                                                //   newlanguages,
                                                //   (tutorDataMap['language']
                                                //           as List<dynamic>)
                                                //       .cast<dynamic>(),
                                                // );
                                                // if (filename != '' ||
                                                //     tutorfirstname.text !=
                                                //         tutorDataMap['firstName'] ||
                                                //     tutorlastname.text !=
                                                //         tutorDataMap['lastname'] ||
                                                //     tutormiddleName.text !=
                                                //         tutorDataMap[
                                                //             'middleName'] ||
                                                //     birthdate !=
                                                //         DateTime.parse(tutorDataMap[
                                                //             'birthdate']) ||
                                                //     newage !=
                                                //         int.parse(
                                                //             tutorDataMap['age']) ||
                                                //     country.text !=
                                                //         tutorDataMap['country'] ||
                                                //     city.text !=
                                                //         tutorDataMap['city'] ||
                                                //     birthcountry.text !=
                                                //         tutorDataMap[
                                                //             'birthPlace'] ||
                                                //     birthcity.text !=
                                                //         tutorDataMap['birthCity'] ||
                                                //     timezone.text !=
                                                //         tutorDataMap['timezone'] ||
                                                //     contactnumber.text !=
                                                //         tutorDataMap['contact'] ||
                                                //     selectedDate !=
                                                //         DateTime.parse(tutorDataMap[
                                                //             'birthdate']) ||
                                                //     areListsEqual == false) {
                                                //   setState(() {
                                                //     allowUpdate = true;
                                                //   });
                                                // } else {
                                                //   setState(() {
                                                //     allowUpdate = false;
                                                //   });
                                                // }
                                              },
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 680,
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 10, 5),
                                        decoration: BoxDecoration(
                                          // color: const Color.fromRGBO(
                                          //     55, 116, 135, 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Languages',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: kColorLight),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Card(
                                            color: Colors.white,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 5,
                                            child: SizedBox(
                                              width: 270,
                                              height: 45,
                                              child: TypeAheadFormField<
                                                  LanguageData>(
                                                // Specify LanguageData as the generic type
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  decoration: InputDecoration(
                                                    hintText: 'Add Language',
                                                    labelStyle: const TextStyle(
                                                        color: Colors.grey),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Rounded border
                                                      borderSide: BorderSide
                                                          .none, // No outline border
                                                    ),
                                                    suffixIcon: const Icon(
                                                        Icons.arrow_drop_down),
                                                  ),
                                                ),
                                                suggestionsCallback:
                                                    (pattern) async {
                                                  final suggestions = widget
                                                      .names
                                                      .where((language) => language
                                                          .languageNamesStream
                                                          .toLowerCase()
                                                          .contains(pattern
                                                              .toLowerCase()))
                                                      .toList(); // Return a list of LanguageData objects
                                                  return suggestions;
                                                },
                                                itemBuilder:
                                                    (context, suggestions) {
                                                  return ListTile(
                                                    title: Text(suggestions
                                                        .languageNamesStream), // Access the language name
                                                  );
                                                },
                                                onSuggestionSelected:
                                                    (suggestion) {
                                                  if (newlanguages.contains(
                                                      suggestion
                                                          .languageNamesStream)) {
                                                    null;
                                                  } else {
                                                    setState(() {
                                                      newlanguages.add(suggestion
                                                          .languageNamesStream
                                                          .toString()); // Add the LanguageData object to tlanguages
                                                    });
                                                  }
                                                  // bool areListsEqual = listEquals(
                                                  //   newlanguages,
                                                  //   (tutorDataMap['language']
                                                  //           as List<dynamic>)
                                                  //       .cast<dynamic>(),
                                                  // );
                                                  // if (filename != '' ||
                                                  //     tutorfirstname.text !=
                                                  //         tutorDataMap[
                                                  //             'firstName'] ||
                                                  //     tutorlastname.text !=
                                                  //         tutorDataMap[
                                                  //             'lastname'] ||
                                                  //     tutormiddleName.text !=
                                                  //         tutorDataMap[
                                                  //             'middleName'] ||
                                                  //     birthdate !=
                                                  //         DateTime.parse(
                                                  //             tutorDataMap[
                                                  //                 'birthdate']) ||
                                                  //     newage !=
                                                  //         int.parse(tutorDataMap[
                                                  //             'age']) ||
                                                  //     country.text !=
                                                  //         tutorDataMap['country'] ||
                                                  //     city.text !=
                                                  //         tutorDataMap['city'] ||
                                                  //     birthcountry.text !=
                                                  //         tutorDataMap[
                                                  //             'birthPlace'] ||
                                                  //     birthcity.text !=
                                                  //         tutorDataMap[
                                                  //             'birthCity'] ||
                                                  //     timezone.text !=
                                                  //         tutorDataMap[
                                                  //             'timezone'] ||
                                                  //     contactnumber.text !=
                                                  //         tutorDataMap['contact'] ||
                                                  //     selectedDate !=
                                                  //         DateTime.parse(
                                                  //             tutorDataMap[
                                                  //                 'birthdate']) ||
                                                  //     areListsEqual == false) {
                                                  //   setState(() {
                                                  //     allowUpdate = true;
                                                  //   });
                                                  // } else {
                                                  //   setState(() {
                                                  //     allowUpdate = false;
                                                  //   });
                                                  // }
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Tooltip(
                                            message: 'Remove Language',
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: -4,
                                                      vertical: -4),
                                              icon: const Icon(Icons
                                                  .delete_outline_outlined),
                                              color: kCalendarColorB,
                                              iconSize: 30,
                                              onPressed: selectedindex == null
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        newlanguages.removeAt(
                                                            selectedindex!);
                                                      });
                                                    },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        child: SizedBox(
                                          height: 50,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
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
                                                  updatescrollController1
                                                      .animateTo(
                                                    updatescrollController1
                                                            .offset -
                                                        100.0, // Adjust the value as needed
                                                    duration: const Duration(
                                                        milliseconds:
                                                            500), // Adjust the duration as needed
                                                    curve: Curves.ease,
                                                  );
                                                },
                                              ),
                                              Container(
                                                width: 550,
                                                height: 45,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                child: ListView.builder(
                                                    controller:
                                                        updatescrollController1,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        newlanguages.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      bool isIndexEven =
                                                          index % 2 == 0;

                                                      String datalanguage =
                                                          newlanguages[index];
                                                      Color color =
                                                          vibrantColors[index %
                                                              vibrantColors
                                                                  .length]; // Cycle through colors

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10.0,
                                                                right: 10),
                                                        child: Card(
                                                          color: Colors.white,
                                                          margin:
                                                              EdgeInsets.zero,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          elevation: 5,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    5, 0, 5, 0),
                                                            decoration: selectedindex ==
                                                                    index
                                                                ? const BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: Colors
                                                                              .black12,
                                                                          offset: Offset(
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
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(15)),
                                                                  )
                                                                : const BoxDecoration(
                                                                    boxShadow: [
                                                                        BoxShadow(
                                                                            color: Colors
                                                                                .black12,
                                                                            offset: Offset(0,
                                                                                4),
                                                                            blurRadius:
                                                                                5.0)
                                                                      ],
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            15)),
                                                                    color: Colors
                                                                        .white),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedindex ==
                                                                            index
                                                                        ? selectedindex =
                                                                            null
                                                                        : selectedindex =
                                                                            index;
                                                                  });
                                                                },
                                                                child: Center(
                                                                  child: Text(
                                                                    datalanguage,
                                                                    style: TextStyle(
                                                                        color: selectedindex ==
                                                                                index
                                                                            ? Colors.white
                                                                            : kColorGrey),
                                                                  ),
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
                                                  updatescrollController1
                                                      .animateTo(
                                                    updatescrollController1
                                                            .offset +
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
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : viewinfo(studentinfodata.first),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 0, right: 0, top: 20),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       Align(
                    //         alignment: Alignment.centerRight,
                    //         child: SizedBox(
                    //           width: 130,
                    //           height: 40,
                    //           child: ElevatedButton(
                    //             style: ElevatedButton.styleFrom(
                    //               backgroundColor: kColorPrimary,
                    //               shape: const RoundedRectangleBorder(
                    //                   borderRadius:
                    //                       BorderRadius.all(Radius.circular(20))),
                    //             ),
                    //             onPressed: () {
                    //               setState(() {
                    //                 // updateStudentInfo(
                    //                 //     'XuQyf7S8gCOJBu6gTIb0',
                    //                 //     confirstname.text,
                    //                 //     conmiddlename.text,
                    //                 //     conlastname.text,
                    //                 //     languages,
                    //                 //     concontact.text,
                    //                 //     conemailadd.text,
                    //                 //     conaddress.text,
                    //                 //     concountry.text);
                    //               });
                    //             },
                    //             child: const Text('Update'),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: model,
          child: Positioned(
            top: 17,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.transparent),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    elevation: WidgetStateProperty.all<double>(0),
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {
                          return Colors.white.withOpacity(0.3); // Hover color
                        }
                        return null; // Use the default color for other states
                      },
                    ),
                  ),
                  onPressed: () async {
                    // if (allowUpdate == false) {
                    // } else {
                    if (filename != '') {
                      data = await uploadStudentProfile(
                          widget.uID, selectedImage, filename);
                    }

                    String? result = await updateStudentInformation(
                        widget.uID,
                        concountry.text,
                        conaddress.text,
                        concontact.text,
                        timezone.text,
                        citizenships,
                        newlanguages,
                        data == null || data!.isEmpty ? '' : data!);
                    if (result == 'success') {
                      filename = '';
                      selectedImage = Uint8List(0);
                      final provider = context.read<MyModel>();
                      provider.updateBoolValue(false);
                    } else {
                      filename = '';
                      CoolAlert.show(
                        context: context,
                        width: 200,
                        type: CoolAlertType.error,
                        text: 'Update Error',
                      );
                    }

                    allowUpdate = false;
                    // }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                        color: kColorPrimary, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.transparent),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    elevation: WidgetStateProperty.all<double>(0),
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {
                          return Colors.white.withOpacity(0.3); // Hover color
                        }
                        return null; // Use the default color for other states
                      },
                    ),
                  ),
                  onPressed: () {
                    // bool areListsEqual = listEquals(
                    //   newlanguages,
                    //   (tutorDataMap['language']
                    //           as List<dynamic>)
                    //       .cast<dynamic>(),
                    // );
                    // if (filename != '' ||
                    //     tutorfirstname.text !=
                    //         tutorDataMap['firstName'] ||
                    //     tutorlastname.text !=
                    //         tutorDataMap['lastname'] ||
                    //     tutormiddleName.text !=
                    //         tutorDataMap['middleName'] ||
                    //     birthdate !=
                    //         DateTime.parse(tutorDataMap[
                    //             'birthdate']) ||
                    //     newage !=
                    //         int.parse(
                    //             tutorDataMap['age']) ||
                    //     country.text !=
                    //         tutorDataMap['country'] ||
                    //     city.text !=
                    //         tutorDataMap['city'] ||
                    //     birthcountry.text !=
                    //         tutorDataMap['birthPlace'] ||
                    //     birthcity.text !=
                    //         tutorDataMap['birthCity'] ||
                    //     timezone.text !=
                    //         tutorDataMap['timezone'] ||
                    //     contactnumber.text !=
                    //         tutorDataMap['contact'] ||
                    //     selectedDate !=
                    //         DateTime.parse(tutorDataMap[
                    //             'birthdate']) ||
                    //     areListsEqual == false) {
                    //   CoolAlert.show(
                    //     context: context,
                    //     barrierDismissible: false,
                    //     width: 200,
                    //     type: CoolAlertType.confirm,
                    //     text:
                    //         'You want to cancel update?',
                    //     confirmBtnText: 'Proceed',
                    //     confirmBtnColor:
                    //         Colors.greenAccent,
                    //     cancelBtnText: 'Go back',
                    //     showCancelBtn: true,
                    //     cancelBtnTextStyle:
                    //         const TextStyle(
                    //             color: Colors.red),
                    //     onCancelBtnTap: () {
                    //       Navigator.of(context).pop;
                    //     },
                    //     onConfirmBtnTap: () {
                    //       filename = '';
                    //       initializeWidget();
                    //       final provider =
                    //           context.read<MyModel>();
                    //       provider.updateBoolValue(false);
                    //     },
                    //   );
                    // } else {
                    filename = '';
                    // initializeWidget();
                    final provider = context.read<MyModel>();
                    provider.updateBoolValue(false);
                    // }
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: kCalendarColorB, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget viewinfo(StudentInfoClass data) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerLeft,
      width: ResponsiveBuilder.isDesktop(context)
          ? size.width - 320
          : size.width - 30,
      padding: ResponsiveBuilder.isDesktop(context)
          ? const EdgeInsets.only(left: 250, right: 20)
          : ResponsiveBuilder.isTablet(context)
              ? const EdgeInsets.only(left: 100, right: 20)
              : const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Name:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text:
                      '${data.studentFirstname}${data.studentMiddlename == '' ? ' ${data.studentLastname}' : ' ${data.studentMiddlename} ${data.studentLastname}'}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Date of Birth:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.dateofbirth,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                const TextSpan(
                  text: 'Age:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: calculateAge(
                      DateFormat('MMMM dd, yyyy').parse(data.dateofbirth)),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Gender:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.gender,
                  //  text: '${data.birthCity}, ${data.birthPlace}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Citizenship :',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.citizenship.join(', '),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Country of Residence:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: '${data.address}, ${data.country}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Timezone:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.timezone,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Contact:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.contact,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
          const SizedBox(
            height: 12,
          ),
          SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: 'Languages:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                const TextSpan(text: '     '),
                TextSpan(
                  text: data.languages.join(', '),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: kColorGrey),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            onTap: () {
              // Add any onTap behavior if needed
            },
          ),
        ],
      ),
    );
  }

  String calculateAge(DateTime birthdate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthdate.year;

    if (currentDate.month < birthdate.month ||
        (currentDate.month == birthdate.month &&
            currentDate.day < birthdate.day)) {
      age--;
    }

    return age.toString();
  }
}
