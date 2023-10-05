import 'dart:typed_data';

import 'package:cool_alert/cool_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/provider/update_tutor_provider.dart';
import 'package:work4ututor/ui/web/tutor/tutor_profile/view_file.dart';

import '../../../../data_class/tutor_info_class.dart';
import '../../../../utils/themes.dart';

class UpdateTutorSevices extends StatefulWidget {
  final TutorInformation tutordata;

  const UpdateTutorSevices({super.key, required this.tutordata});

  @override
  State<UpdateTutorSevices> createState() => _UpdateTutorSevicesState();
}

class _UpdateTutorSevicesState extends State<UpdateTutorSevices> {
  Map<String, dynamic> tutorInformationToJson(TutorInformation tutorData) {
    return {
      // Add other properties as needed
      'contact': tutorData.contact,
      'birthPlace': tutorData.birthPlace,
      'country': tutorData.country,
      'certificates': tutorData.certificates,
      'resume': tutorData.resume,
      'promotionalMessage': tutorData.promotionalMessage,
      'withdrawal': tutorData.withdrawal,
      'status': tutorData.status,
      'extensionName': tutorData.extensionName,
      'dateSign': tutorData.dateSign,
      'firstName': tutorData.firstName,
      'imageID': tutorData.imageID,
      'language': tutorData.language,
      'lastname': tutorData.lastname,
      'middleName': tutorData.middleName,
      'presentation': tutorData.presentation,
      'tutorID': tutorData.tutorID,
      'userId': tutorData.userId,
      'age': tutorData.age,
      'applicationID': tutorData.applicationID,
      'birthCity': tutorData.birthCity,
      'birthdate': tutorData.birthdate,
      'emailadd': tutorData.emailadd,
      'city': tutorData.city,
      'servicesprovided': tutorData.servicesprovided,
      'timezone': tutorData.timezone,
      'validIds': tutorData.validIds,
      'certificatestype': tutorData.certificatestype,
      'resumelinktype': tutorData.resumelinktype,
      'validIDstype': tutorData.validIDstype,
    };
  }

// Declare a ScrollController
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  ScrollController _scrollController3 = ScrollController();
  String uID = "Upload your ID";
  bool selection1 = false;
  bool selection2 = false;
  bool selection3 = false;
  bool selection4 = false;
  bool selection5 = false;
  TextEditingController _aboutmecontroller = TextEditingController();
// Declare a ScrollController
  ScrollController updatescrollController = ScrollController();
  ScrollController updatescrollController1 = ScrollController();
  ScrollController updatescrollController2 = ScrollController();
  ScrollController updatescrollController3 = ScrollController();
  bool updateselection1 = false;
  bool updateselection2 = false;
  bool updateselection3 = false;
  bool updateselection4 = false;
  bool updateselection5 = false;
  TextEditingController updateaboutmecontroller = TextEditingController();
  List<dynamic> validIds = [];
  List<dynamic> validIDstype = [];
  List<dynamic> resume = [];
  List<dynamic> resumelinktype = [];
  List<dynamic> certificates = [];
  List<dynamic> certificatestype = [];
  List<dynamic> presentation = [];
  @override
  void initState() {
    super.initState();
    initializeWidget();
  }

  void initializeWidget() {
    Map<String, dynamic> tutorDataMap =
        tutorInformationToJson(widget.tutordata);
    updateselection1 =
        tutorDataMap['servicesprovided'].contains('Recovery Lessons');
    updateselection2 = tutorDataMap['servicesprovided']
        .contains('Kids with Learning Difficulties');

    updateselection3 =
        tutorDataMap['servicesprovided'].contains('Pre Exam Classes');

    updateselection4 =
        tutorDataMap['servicesprovided'].contains('Deaf Language');

    updateselection5 = tutorDataMap['servicesprovided'].contains('Own Program');

    updateaboutmecontroller.text = tutorDataMap['promotionalMessage'];
    for (var validid in tutorDataMap['validIds']) {
      // You can process each language here if needed
      // For example, you can check if it's already in newlanguages before adding
      if (!validIds.contains(validid)) {
        validIds.add(validid);
      }
    }
    for (var valididtype in tutorDataMap['validIDstype']) {
      // You can process each language here if needed
      // For example, you can check if it's already in newlanguages before adding
      if (!validIDstype.contains(valididtype)) {
        validIDstype.add(valididtype);
      }
    }
    for (var resumedata in tutorDataMap['resume']) {
      // You can process each language here if needed
      // For example, you can check if it's already in newlanguages before adding
      if (!resume.contains(resumedata)) {
        resume.add(resumedata);
      }
    }
    for (var resumelink in tutorDataMap['resumelinktype']) {
      // You can process each language here if needed
      // For example, you can check if it's already in newlanguages before adding
      if (!resumelinktype.contains(resumelink)) {
        resumelinktype.add(resumelink);
      }
    }
    for (var certifcatesdata in tutorDataMap['certificates']) {
      // You can process each language here if needed
      // For example, you can check if it's already in newlanguages before adding
      if (!certificates.contains(certifcatesdata)) {
        certificates.add(certifcatesdata);
      }
    }
    for (var certificates1 in tutorDataMap['certificatestype']) {
      // You can process each language here if needed
      // For example, you can check if it's already in newlanguages before adding
      if (!certificatestype.contains(certificates1)) {
        certificatestype.add(certificates1);
      }
    }
    for (var presentationdata in tutorDataMap['presentation']) {
      // You can process each language here if needed
      // For example, you can check if it's already in newlanguages before adding
      if (!presentation.contains(presentationdata)) {
        presentation.add(presentationdata);
      }
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

  List<Uint8List?> selectedresume = [];
  List<String> resumefilenames = [];
  List<String> resumefilenamestype = [];
  void selectResumes() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedresume.addAll(result.files.map((file) => file.bytes));
        resumefilenames.addAll(result.files.map((file) => file.name));
        List<String> fileExtensions = result.files.map((file) {
          final fileName = file.name;
          final extension = fileName.split('.').last.toLowerCase();
          return extension;
        }).toList();

        resumefilenamestype.addAll(fileExtensions.map((extension) {
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

  List<Uint8List?> selectedCertificates = [];
  List<String> certificatesfilenames = [];
  List<String> certificatesfilenamestype = [];
  void selectCertificates() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedCertificates.addAll(result.files.map((file) => file.bytes));
        certificatesfilenames.addAll(result.files.map((file) => file.name));
        List<String> fileExtensions = result.files.map((file) {
          final fileName = file.name;
          final extension = fileName.split('.').last.toLowerCase();
          return extension;
        }).toList();

        certificatesfilenamestype.addAll(fileExtensions.map((extension) {
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

  List<Uint8List?> selectedVideos = [];
  List<String> videoFilenames = [];

  void selectVideos() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video, // Specify that only video files should be allowed.
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedVideos.addAll(result.files.map((file) => file.bytes));
        videoFilenames.addAll(result.files.map((file) => file.name));
      });

      print("Videos selected: $videoFilenames");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TutorInformation> tutorinfodata =
        Provider.of<List<TutorInformation>>(context);
    const Color background = Color.fromRGBO(55, 116, 135, 1);
    if (tutorinfodata.isNotEmpty) {
      selection1 =
          tutorinfodata.first.servicesprovided.contains('Recovery Lessons');
      selection2 = tutorinfodata.first.servicesprovided
          .contains('Kids with Learning Difficulties');
      selection3 =
          tutorinfodata.first.servicesprovided.contains('Pre Exam Classes');

      selection4 =
          tutorinfodata.first.servicesprovided.contains('Deaf Language');

      selection5 = tutorinfodata.first.servicesprovided.contains('Own Program');
      _aboutmecontroller.text = tutorinfodata.first.promotionalMessage;
    }
    final bool model =
        context.select((TutorInformationProvider p) => p.updateDisplay);

    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          elevation: 5,
          child: Container(
            width: size.width - 320,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: background,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 250.0,
                  right: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    model
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  if (0 == 0) {
                                    CoolAlert.show(
                                      context: context,
                                      barrierDismissible: false,
                                      width: 200,
                                      type: CoolAlertType.confirm,
                                      text: 'You want to cancel update?',
                                      confirmBtnText: 'Proceed',
                                      confirmBtnColor: Colors.greenAccent,
                                      cancelBtnText: 'Go back',
                                      showCancelBtn: true,
                                      cancelBtnTextStyle:
                                          const TextStyle(color: Colors.red),
                                      onCancelBtnTap: () {
                                        Navigator.of(context).pop;
                                      },
                                      onConfirmBtnTap: () {
                                        initializeWidget();
                                        final provider = context
                                            .read<TutorInformationProvider>();
                                        provider.updateBoolValue(false);
                                      },
                                    );
                                  } else {
                                    initializeWidget();
                                    final provider = context
                                        .read<TutorInformationProvider>();
                                    provider.updateBoolValue(false);
                                  }
                                },
                                icon: const Icon(
                                  Icons.update,
                                  color: Colors
                                      .greenAccent, // Set the icon color to white
                                ),
                                label: const Text(
                                  'Update',
                                  style: TextStyle(
                                    color: Colors
                                        .greenAccent, // Set the text color to white
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  if (0 == 0) {
                                    CoolAlert.show(
                                      context: context,
                                      barrierDismissible: false,
                                      width: 200,
                                      type: CoolAlertType.confirm,
                                      text: 'You want to cancel update?',
                                      confirmBtnText: 'Proceed',
                                      confirmBtnColor: Colors.greenAccent,
                                      cancelBtnText: 'Go back',
                                      showCancelBtn: true,
                                      cancelBtnTextStyle:
                                          const TextStyle(color: Colors.red),
                                      onCancelBtnTap: () {
                                        Navigator.of(context).pop;
                                      },
                                      onConfirmBtnTap: () {
                                        initializeWidget();
                                        final provider = context
                                            .read<TutorInformationProvider>();
                                        provider.updateBoolValue(false);
                                      },
                                    );
                                  } else {
                                    initializeWidget();
                                    final provider = context
                                        .read<TutorInformationProvider>();
                                    provider.updateBoolValue(false);
                                  }
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors
                                      .redAccent, // Set the icon color to white
                                ),
                                label: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors
                                        .redAccent, // Set the text color to white
                                  ),
                                ),
                              )
                            ],
                          )
                        : TextButton.icon(
                            onPressed: () {
                              final provider =
                                  context.read<TutorInformationProvider>();
                              provider.updateBoolValue(true);
                            },
                            icon: const Icon(
                              Icons.edit_document,
                              color:
                                  Colors.white, // Set the icon color to white
                            ),
                            label: const Text(
                              'Edit',
                              style: TextStyle(
                                color:
                                    Colors.white, // Set the text color to white
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
        model
            ? tutorInformationUpdate()
            : tutorInformationDisplay(tutorinfodata)
      ],
    );
  }

  Widget tutorInformationUpdate() {
    Size size = MediaQuery.of(context).size;
    return Card(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      elevation: 5,
      child: Container(
        alignment: Alignment.center,
        width: size.width - 320,
        height: size.height - 75,
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 50,
                          width: 500,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(55, 116, 135, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Valid ID',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                iconSize: 15,
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 600,
                          child: Row(
                            children: [
                              Container(
                                  width: 600,
                                  height: 120,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        iconSize: 15,
                                        padding: EdgeInsets.zero,
                                        splashRadius: 1,
                                        icon: const Icon(
                                          Icons
                                              .arrow_back_ios, // Left arrow icon
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          // Scroll to the left
                                          updatescrollController.animateTo(
                                            updatescrollController.offset -
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
                                              updatescrollController, // Assign the ScrollController to the ListView
                                          scrollDirection: Axis.horizontal,
                                          itemCount: validIds.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewFile(
                                                                imageURL:
                                                                    validIds[
                                                                        index]);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey
                                                            .shade200, // You can adjust the fit as needed.
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image.network(
                                                          validIds[index],
                                                          fit: BoxFit
                                                              .cover, // You can adjust the fit as needed.
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    iconSize: 15,
                                                    splashRadius: 2,
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        validIds
                                                            .removeAt(index);
                                                        validIDstype
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        iconSize: 15,
                                        padding: EdgeInsets.zero,
                                        splashRadius: 1,
                                        icon: const Icon(
                                          Icons
                                              .arrow_forward_ios, // Right arrow icon
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          // Scroll to the right
                                          updatescrollController.animateTo(
                                            updatescrollController.offset +
                                                100.0, // Adjust the value as needed
                                            duration: const Duration(
                                                milliseconds:
                                                    500), // Adjust the duration as needed
                                            curve: Curves.ease,
                                          );
                                        },
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: 500,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(55, 116, 135, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Certificates',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                iconSize: 15,
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 600,
                                height: 120,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      iconSize: 15,
                                      padding: EdgeInsets.zero,
                                      splashRadius: 1,
                                      icon: const Icon(
                                        Icons.arrow_back_ios, // Left arrow icon
                                        color: Colors.blue,
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
                                        controller:
                                            updatescrollController1, // Assign the ScrollController to the ListView
                                        scrollDirection: Axis.horizontal,
                                        itemCount: certificates.length,
                                        itemBuilder: (context, index) {
                                          if (certificatestype[index] ==
                                              'Image') {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewFile(
                                                                imageURL:
                                                                    certificates[
                                                                        index]);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey
                                                            .shade200, // You can adjust the fit as needed.
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image.network(
                                                          certificates[index],
                                                          fit: BoxFit
                                                              .cover, // You can adjust the fit as needed.
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    iconSize: 15,
                                                    splashRadius: 2,
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        certificates
                                                            .removeAt(index);
                                                        certificatestype
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else if (certificatestype[index] ==
                                              'pdf') {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewFile(
                                                                imageURL:
                                                                    certificates[
                                                                        index]);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey
                                                            .shade200, // You can adjust the fit as needed.
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: const Icon(
                                                          Icons.picture_as_pdf,
                                                          size: 48,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    iconSize: 15,
                                                    splashRadius: 2,
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        certificates
                                                            .removeAt(index);
                                                        certificatestype
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewFile(
                                                                imageURL:
                                                                    certificates[
                                                                        index]);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey
                                                            .shade200, // You can adjust the fit as needed.
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: const Icon(
                                                          Icons
                                                              .file_present_sharp,
                                                          size: 48,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    iconSize: 15,
                                                    splashRadius: 2,
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        certificates
                                                            .removeAt(index);
                                                        certificatestype
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      iconSize: 15,
                                      padding: EdgeInsets.zero,
                                      splashRadius: 1,
                                      icon: const Icon(
                                        Icons
                                            .arrow_forward_ios, // Right arrow icon
                                        color: Colors.blue,
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
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: 500,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(55, 116, 135, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Resume/CV',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                iconSize: 15,
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 600,
                                height: 120,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      iconSize: 15,
                                      icon: const Icon(
                                        Icons.arrow_back_ios, // Left arrow icon
                                        color: Colors.blue,
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
                                        controller:
                                            updatescrollController2, // Assign the ScrollController to the ListView
                                        scrollDirection: Axis.horizontal,
                                        itemCount: resume.length,
                                        itemBuilder: (context, index) {
                                          if (resumelinktype[index] ==
                                              'Image') {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewFile(
                                                                imageURL:
                                                                    resume[
                                                                        index]);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey
                                                            .shade200, // You can adjust the fit as needed.
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image.network(
                                                          resume[index],
                                                          fit: BoxFit
                                                              .cover, // You can adjust the fit as needed.
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    iconSize: 15,
                                                    splashRadius: 2,
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        resume.removeAt(index);
                                                        resumelinktype
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else if (resumelinktype[index] ==
                                              'pdf') {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewFile(
                                                                imageURL:
                                                                    resume[
                                                                        index]);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey
                                                            .shade200, // You can adjust the fit as needed.
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: const Icon(
                                                          Icons.picture_as_pdf,
                                                          size:
                                                              48, // Adjust the size as needed
                                                          color: Colors
                                                              .red, // Change the color as needed
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    iconSize: 15,
                                                    splashRadius: 2,
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        resume.removeAt(index);
                                                        resumelinktype
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewFile(
                                                                imageURL:
                                                                    resume[
                                                                        index]);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey
                                                            .shade200, // You can adjust the fit as needed.
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: const Icon(
                                                          Icons
                                                              .file_present_sharp,
                                                          size: 48,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    iconSize: 15,
                                                    splashRadius: 2,
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        resume.removeAt(index);
                                                        resumelinktype
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
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
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: 500,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(55, 116, 135, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'My Videos',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                iconSize: 15,
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 600,
                                height: 120,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      iconSize: 15,
                                      icon: const Icon(
                                        Icons.arrow_back_ios, // Left arrow icon
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        // Scroll to the left
                                        updatescrollController3.animateTo(
                                          updatescrollController3.offset -
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
                                            updatescrollController3, // Assign the ScrollController to the ListView
                                        scrollDirection: Axis.horizontal,
                                        itemCount: presentation.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return ViewFile(
                                                              imageURL:
                                                                  presentation[
                                                                      index]);
                                                        });
                                                  },
                                                  child: Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.grey
                                                          .shade200, // You can adjust the fit as needed.
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: const Icon(
                                                        Icons
                                                            .video_library_sharp,
                                                        size: 48,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  iconSize: 15,
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      presentation
                                                          .removeAt(index);
                                                    });
                                                  },
                                                ),
                                              ],
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
                                        updatescrollController3.animateTo(
                                          updatescrollController3.offset +
                                              100.0, // Adjust the value as needed
                                          duration: const Duration(
                                              milliseconds:
                                                  500), // Adjust the duration as needed
                                          curve: Curves.ease,
                                        );
                                      },
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          height: 50,
                          width: 500,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(55, 116, 135, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Services Provided',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 500,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    width: 250,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text('Recovery Lessons'),
                                          // subtitle: const Text(
                                          //     'A computer science portal for geeks.'),
                                          // secondary: const Icon(Icons.code),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: updateselection1,
                                          value: updateselection1,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              updateselection1 = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 250,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text(
                                              'Kids with Learning Difficulties'),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: updateselection2,
                                          value: updateselection2,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              updateselection2 = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 250,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text('Pre Exam Classes'),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: updateselection3,
                                          value: updateselection3,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              updateselection3 = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 250,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text('Deaf Language'),
                                          // subtitle: const Text(
                                          //     'A computer science portal for geeks.'),
                                          // secondary: const Icon(Icons.code),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: updateselection4,
                                          value: updateselection4,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              updateselection4 = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 250,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text('Own Program'),
                                          // subtitle: const Text(
                                          //     'A computer science portal for geeks.'),
                                          // secondary: const Icon(Icons.code),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: updateselection5,
                                          value: updateselection5,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            setState(() {
                                              updateselection5 = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: 500,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(55, 116, 135, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'About Me',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 500,
                          height: 350,
                          child: TextField(
                            controller: updateaboutmecontroller,
                            textAlignVertical: TextAlignVertical.top,
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText:
                                  'Describe your skills, your approach, your teaching method, and tell us why a student should you! (max 5000 characters)',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tutorInformationDisplay(List<TutorInformation> tutorinfodata) {
    Size size = MediaQuery.of(context).size;
    return Card(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      elevation: 5,
      child: Container(
        alignment: Alignment.center,
        width: size.width - 320,
        height: size.height - 75,
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 50,
                          width: 500,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(55, 116, 135, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.card_membership,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              const SizedBox(width: 10.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    'Valid ID/s',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 600,
                                height: 120,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      iconSize: 15,
                                      padding: EdgeInsets.zero,
                                      splashRadius: 1,
                                      icon: const Icon(
                                        Icons.arrow_back_ios, // Left arrow icon
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
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            tutorinfodata.first.validIds.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return ViewFile(
                                                              imageURL:
                                                                  tutorinfodata
                                                                          .first
                                                                          .validIds[
                                                                      index]);
                                                        });
                                                  },
                                                  child: Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.grey
                                                          .shade200, // You can adjust the fit as needed.
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: Image.network(
                                                        tutorinfodata.first
                                                            .validIds[index],
                                                        fit: BoxFit
                                                            .cover, // You can adjust the fit as needed.
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      iconSize: 15,
                                      padding: EdgeInsets.zero,
                                      splashRadius: 1,
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
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: 500,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(55, 116, 135, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.note_alt_outlined,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              const SizedBox(width: 10.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    'Certificates',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 600,
                                height: 120,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      iconSize: 15,
                                      padding: EdgeInsets.zero,
                                      splashRadius: 1,
                                      icon: const Icon(
                                        Icons.arrow_back_ios, // Left arrow icon
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        // Scroll to the left
                                        _scrollController1.animateTo(
                                          _scrollController1.offset -
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
                                            _scrollController1, // Assign the ScrollController to the ListView
                                        scrollDirection: Axis.horizontal,
                                        itemCount: tutorinfodata
                                            .first.certificates.length,
                                        itemBuilder: (context, index) {
                                          if (tutorinfodata.first
                                                  .certificatestype[index] ==
                                              'Image') {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewFile(
                                                                imageURL: tutorinfodata
                                                                        .first
                                                                        .certificates[
                                                                    index]);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey
                                                            .shade200, // You can adjust the fit as needed.
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image.network(
                                                          tutorinfodata.first
                                                                  .certificates[
                                                              index],
                                                          fit: BoxFit
                                                              .cover, // You can adjust the fit as needed.
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else if (tutorinfodata.first
                                                  .certificatestype[index] ==
                                              'pdf') {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewFile(
                                                                imageURL: tutorinfodata
                                                                        .first
                                                                        .certificates[
                                                                    index]);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey
                                                            .shade200, // You can adjust the fit as needed.
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: const Icon(
                                                          Icons.picture_as_pdf,
                                                          size: 48,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewFile(
                                                                imageURL: tutorinfodata
                                                                        .first
                                                                        .certificates[
                                                                    index]);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey
                                                            .shade200, // You can adjust the fit as needed.
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: const Icon(
                                                          Icons
                                                              .file_present_sharp,
                                                          size: 48,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      iconSize: 15,
                                      padding: EdgeInsets.zero,
                                      splashRadius: 1,
                                      icon: const Icon(
                                        Icons
                                            .arrow_forward_ios, // Right arrow icon
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        // Scroll to the right
                                        _scrollController1.animateTo(
                                          _scrollController1.offset +
                                              100.0, // Adjust the value as needed
                                          duration: const Duration(
                                              milliseconds:
                                                  500), // Adjust the duration as needed
                                          curve: Curves.ease,
                                        );
                                      },
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: 500,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(55, 116, 135, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.list_alt_outlined,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              const SizedBox(width: 10.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    'Resume/s',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 600,
                                height: 120,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      iconSize: 15,
                                      icon: const Icon(
                                        Icons.arrow_back_ios, // Left arrow icon
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        // Scroll to the left
                                        _scrollController2.animateTo(
                                          _scrollController2.offset -
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
                                            _scrollController2, // Assign the ScrollController to the ListView
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            tutorinfodata.first.resume.length,
                                        itemBuilder: (context, index) {
                                          if (tutorinfodata.first
                                                  .resumelinktype[index] ==
                                              'Image') {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewFile(
                                                                imageURL: tutorinfodata
                                                                        .first
                                                                        .resume[
                                                                    index]);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey
                                                            .shade200, // You can adjust the fit as needed.
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image.network(
                                                          tutorinfodata.first
                                                              .resume[index],
                                                          fit: BoxFit
                                                              .cover, // You can adjust the fit as needed.
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else if (tutorinfodata.first
                                                  .resumelinktype[index] ==
                                              'pdf') {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewFile(
                                                                imageURL: tutorinfodata
                                                                        .first
                                                                        .resume[
                                                                    index]);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey
                                                            .shade200, // You can adjust the fit as needed.
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: const Icon(
                                                          Icons.picture_as_pdf,
                                                          size:
                                                              48, // Adjust the size as needed
                                                          color: Colors
                                                              .red, // Change the color as needed
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewFile(
                                                                imageURL: tutorinfodata
                                                                        .first
                                                                        .resume[
                                                                    index]);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey
                                                            .shade200, // You can adjust the fit as needed.
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: const Icon(
                                                          Icons
                                                              .file_present_sharp,
                                                          size: 48,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
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
                                        _scrollController2.animateTo(
                                          _scrollController2.offset +
                                              100.0, // Adjust the value as needed
                                          duration: const Duration(
                                              milliseconds:
                                                  500), // Adjust the duration as needed
                                          curve: Curves.ease,
                                        );
                                      },
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: 500,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(55, 116, 135, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.video_collection_outlined,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              const SizedBox(width: 10.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    'My Videos',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 600,
                                height: 120,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      iconSize: 15,
                                      icon: const Icon(
                                        Icons.arrow_back_ios, // Left arrow icon
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        // Scroll to the left
                                        _scrollController3.animateTo(
                                          _scrollController3.offset -
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
                                            _scrollController3, // Assign the ScrollController to the ListView
                                        scrollDirection: Axis.horizontal,
                                        itemCount: tutorinfodata
                                            .first.presentation.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return ViewFile(
                                                              imageURL:
                                                                  tutorinfodata
                                                                          .first
                                                                          .presentation[
                                                                      index]);
                                                        });
                                                  },
                                                  child: Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.grey
                                                          .shade200, // You can adjust the fit as needed.
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: const Icon(
                                                        Icons
                                                            .video_library_sharp,
                                                        size: 48,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                        _scrollController3.animateTo(
                                          _scrollController3.offset +
                                              100.0, // Adjust the value as needed
                                          duration: const Duration(
                                              milliseconds:
                                                  500), // Adjust the duration as needed
                                          curve: Curves.ease,
                                        );
                                      },
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 500,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(55, 116, 135, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              const SizedBox(width: 10.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    'About Me',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 500,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          height: 450,
                          child: TextField(
                            enabled: false,
                            controller: _aboutmecontroller,
                            textAlignVertical: TextAlignVertical.top,
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        kColorPrimary), // Set your desired color here
                              ),
                              hintText:
                                  'Describe your skills, your approach, your teaching method, and tell us why a student should you! (max 5000 characters)',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: 500,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(55, 116, 135, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.task,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              const SizedBox(width: 10.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    'Services Provided',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 500,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: [
                                  Visibility(
                                    visible: selection1,
                                    child: Container(
                                      width: 250,
                                      height: 45,
                                      alignment: Alignment.centerLeft,
                                      child: Theme(
                                        data: ThemeData(
                                          checkboxTheme: CheckboxThemeData(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        child: ListTileTheme(
                                          child: CheckboxListTile(
                                            enabled: false,
                                            title:
                                                const Text('Recovery Lessons'),
                                            // subtitle: const Text(
                                            //     'A computer science portal for geeks.'),
                                            // secondary: const Icon(Icons.code),
                                            autofocus: false,
                                            activeColor: Colors.green,
                                            checkColor: Colors.white,
                                            selected: selection1,
                                            value: selection1,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                selection1 = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: selection2,
                                    child: Container(
                                      width: 250,
                                      height: 45,
                                      alignment: Alignment.centerLeft,
                                      child: Theme(
                                        data: ThemeData(
                                          checkboxTheme: CheckboxThemeData(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        child: ListTileTheme(
                                          child: CheckboxListTile(
                                            enabled: false,

                                            title: const Text(
                                              maxLines: 1,
                                              'Kids with Learning Difficulties',
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // subtitle: const Text(
                                            //     'A computer science portal for geeks.'),
                                            // secondary: const Icon(Icons.code),
                                            autofocus: false,
                                            activeColor: Colors.green,
                                            checkColor: Colors.white,
                                            selected: selection2,
                                            value: selection2,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                selection2 = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Visibility(
                                    visible: selection3,
                                    child: Container(
                                      width: 250,
                                      height: 45,
                                      alignment: Alignment.centerLeft,
                                      child: Theme(
                                        data: ThemeData(
                                          checkboxTheme: CheckboxThemeData(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        child: ListTileTheme(
                                          child: CheckboxListTile(
                                            enabled: false,
                                            title:
                                                const Text('Pre Exam Classes'),
                                            autofocus: false,
                                            activeColor: Colors.green,
                                            checkColor: Colors.white,
                                            selected: selection3,
                                            value: selection3,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                selection3 = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: selection4,
                                    child: Container(
                                      width: 250,
                                      height: 45,
                                      alignment: Alignment.centerLeft,
                                      child: Theme(
                                        data: ThemeData(
                                          checkboxTheme: CheckboxThemeData(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        child: ListTileTheme(
                                          child: CheckboxListTile(
                                            enabled: false,

                                            title: const Text('Deaf Language'),
                                            // subtitle: const Text(
                                            //     'A computer science portal for geeks.'),
                                            // secondary: const Icon(Icons.code),
                                            autofocus: false,
                                            activeColor: Colors.green,
                                            checkColor: Colors.white,
                                            selected: selection4,
                                            value: selection4,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                selection4 = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Visibility(
                                    visible: selection5,
                                    child: Container(
                                      width: 250,
                                      height: 45,
                                      alignment: Alignment.centerLeft,
                                      child: Theme(
                                        data: ThemeData(
                                          checkboxTheme: CheckboxThemeData(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        child: ListTileTheme(
                                          child: CheckboxListTile(
                                            enabled: false,

                                            title: const Text('Own Program'),
                                            // subtitle: const Text(
                                            //     'A computer science portal for geeks.'),
                                            // secondary: const Icon(Icons.code),
                                            autofocus: false,
                                            activeColor: Colors.green,
                                            checkColor: Colors.white,
                                            selected: selection5,
                                            value: selection5,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                selection5 = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
