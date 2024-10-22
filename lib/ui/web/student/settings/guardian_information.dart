import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../data_class/studentinfoclass.dart';
import '../../../../provider/update_tutor_provider.dart';
import '../../../../shared_components/responsive_builder.dart';
import '../../../../utils/themes.dart';
import '../../tutor/tutor_profile/view_file.dart';

class GuardianInfoSettings extends StatefulWidget {
  final String uID;
  final StudentGuardianClass guardianinfo;
  const GuardianInfoSettings(
      {super.key, required this.uID, required this.guardianinfo});

  @override
  State<GuardianInfoSettings> createState() => _GuardianInfoSettingsState();
}

//controllers
TextEditingController confirstname = TextEditingController();
TextEditingController conmiddlename = TextEditingController();
TextEditingController conlastname = TextEditingController();
TextEditingController conaddress = TextEditingController();
TextEditingController concountry = TextEditingController();
TextEditingController concontact = TextEditingController();
TextEditingController conemailadd = TextEditingController();

String uID = "Upload your ID";
bool selection1 = false;
bool selection2 = false;
bool selection3 = false;
bool selection4 = false;
bool selection5 = false;

class _GuardianInfoSettingsState extends State<GuardianInfoSettings> {
  ScrollController updatescrollController1 = ScrollController();
  String? downloadURL1;

  @override
  Widget build(BuildContext context) {
    final bool model = context.select((MyModel p) => p.updateDisplay);

    const Color background = Color.fromRGBO(55, 116, 135, 1);
    const Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    const double fillPercent = 30; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    const List<double> stops = [0.0, fillStop, fillStop, 1.0];

    Size size = MediaQuery.of(context).size;
    if (downloadURL1 == null) {
      setState(() {
        downloadURL1 = widget.guardianinfo.picture;
      });
    }
    return Card(
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
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                      child: Image.network(
                                        downloadURL1!,
                                        fit: BoxFit
                                            .cover, // You can adjust the fit as needed.
                                      ))),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: ResponsiveBuilder.isDesktop(context)
                      ? const EdgeInsets.only(left: 250, top: 20, right: 20)
                      : ResponsiveBuilder.isTablet(context)
                          ? const EdgeInsets.only(left: 100, top: 20, right: 20)
                          : const EdgeInsets.only(left: 10, top: 20, right: 10),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(),
                  ),
                ),
                viewinfo(widget.guardianinfo),
                Container(
                  alignment: Alignment.centerLeft,
                  width: ResponsiveBuilder.isDesktop(context)
                      ? size.width - 320
                      : size.width - 30,
                  padding: ResponsiveBuilder.isDesktop(context)
                      ? const EdgeInsets.only(left: 250, right: 20)
                      : ResponsiveBuilder.isTablet(context)
                          ? const EdgeInsets.only(left: 100, right: 20)
                          : const EdgeInsets.only(left: 10, right: 10),
                  child: SelectableText.rich(
                    const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Guardian ID:',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: kColorGrey),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    onTap: () {
                      // Add any onTap behavior if needed
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    width: ResponsiveBuilder.isDesktop(context)
                        ? size.width - 320
                        : size.width - 30,
                    height: 100,
                    padding: ResponsiveBuilder.isDesktop(context)
                        ? const EdgeInsets.only(left: 250, right: 20)
                        : ResponsiveBuilder.isTablet(context)
                            ? const EdgeInsets.only(left: 100, right: 20)
                            : const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 12,
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
                              shrinkWrap: true,
                              controller:
                                  updatescrollController1, // Assign the ScrollController to the ListView
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.guardianinfo.ids.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                var height =
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height;
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0), // Adjust the radius as needed
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  content: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0), // Same radius as above
                                                    child: Container(
                                                      color: Colors
                                                          .white, // Set the background color of the circular content

                                                      child: Stack(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: height,
                                                            width: 900,
                                                            child: ViewFile(
                                                                imageURL: widget
                                                                    .guardianinfo
                                                                    .ids[index]),
                                                          ),
                                                          Positioned(
                                                            top: 10.0,
                                                            right: 10.0,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(
                                                                        false); // Close the dialog
                                                              },
                                                              child: const Icon(
                                                                Icons.close,
                                                                color:
                                                                    Colors.red,
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
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey.shade200,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.network(
                                                  widget.guardianinfo.ids[index]
                                                      .toString(),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            //   Positioned(
                                            //     top: 0,
                                            //     right: 0,
                                            //     child: GestureDetector(
                                            //       onTap: () async {
                                            //         bool result = await deleteMaterial(materialsdata[index]['classno'], materialsdata[index]['reference']);
                                            //         if (result) {
                                            //           handleUpload('Deleted Successfully!', true);
                                            //         } else {
                                            //           handleUpload('Deleted Successfully!', false);
                                            //         }
                                            //       },
                                            //       child: Container(
                                            //         padding: const EdgeInsets.all(2),
                                            //         decoration: const BoxDecoration(
                                            //           shape: BoxShape.circle,
                                            //           color: Colors.red,
                                            //         ),
                                            //         child: const Icon(
                                            //           Icons.remove,
                                            //           color: Colors.white,
                                            //           size: 15,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        IconButton(
                          iconSize: 12,
                          padding: EdgeInsets.zero,
                          splashRadius: 1,
                          icon: const Icon(
                            Icons.arrow_forward_ios, // Right arrow icon
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
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget viewinfo(StudentGuardianClass data) {
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
                  text: data.guardianFullname,
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
                  text: data.guardianBday,
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
                      DateFormat('MMMM dd, yyyy').parse(data.guardianBday)),
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
            const TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Citizenship :',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kColorGrey),
                ),
                TextSpan(text: '     '),
                TextSpan(
                  text: 'Philippines',
                  style: TextStyle(
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
          // SelectableText.rich(
          //   TextSpan(
          //     children: <TextSpan>[
          //       const TextSpan(
          //         text: 'Languages:',
          //         style: TextStyle(
          //             fontSize: 15,
          //             fontWeight: FontWeight.bold,
          //             color: kColorGrey),
          //       ),
          //       const TextSpan(text: '     '),
          //       TextSpan(
          //         text: data.languages.join(', '),
          //         style: const TextStyle(
          //             fontSize: 15,
          //             fontWeight: FontWeight.w400,
          //             color: kColorGrey),
          //       ),
          //     ],
          //   ),
          //   textAlign: TextAlign.center,
          //   onTap: () {
          //     // Add any onTap behavior if needed
          //   },
          // ),
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
