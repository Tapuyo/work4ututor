// ignore_for_file: avoid_web_libraries_in_flutter, avoid_print, sized_box_for_whitespace

import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:html' as html;

import '../../../../data_class/tutor_info_class.dart';
import '../../../../utils/themes.dart';
// import '../../../../routes/routes.dart';

class TutorListLogin extends StatefulWidget {
  final List<TutorInformation> tutorslist;
  final String keyword;
  final int displayRange;
  final bool isLoading;
  const TutorListLogin(
      {super.key,
      required this.tutorslist,
      required this.keyword,
      required this.displayRange,
      required this.isLoading,
      });

  @override
  State<TutorListLogin> createState() => _TutorListLoginState();
}

class _TutorListLoginState extends State<TutorListLogin> {
  int displayCount = 0;
  List<TutorInformation> _foundUsers = [];
  Reference firebaseStorage = FirebaseStorage.instance.ref();
  Random random = Random();

  void main() {
    initState();
    _foundUsers = widget.tutorslist;
  }

  _runFilter(String enteredKeyword) {
  
    print(enteredKeyword);
    List<TutorInformation> results = [];
    results = widget.tutorslist
        .where((user) =>
            user.firstName.toLowerCase().contains(enteredKeyword.toLowerCase()))
        .toList();
   
    return results;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.keyword.isEmpty) {
      _foundUsers = widget.tutorslist;
      if (widget.displayRange > _foundUsers.length) {
        displayCount = _foundUsers.length;
      } else {
        displayCount = widget.displayRange;
      }
    } else {
      _foundUsers = _runFilter(widget.keyword);
      if (widget.displayRange > _foundUsers.length) {
        displayCount = _foundUsers.length;
      } else {
        displayCount = widget.displayRange;
      }
    }

    return widget.isLoading? const Center(child: CircularProgressIndicator(),): _foundUsers.isNotEmpty
        ? Material(
          color: Colors.white,
            child: SizedBox(
              width: size.width - 400,
              height: size.height,
              child: GridView.count(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 3,
                children: List.generate(displayCount, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const TutorProfile()),
                          // );
                          // html.window.open(Routes.tutorInfo,"");
                        },
                        child: Container(
                          width: (size.width - 400) / 3 - 20,
                          height: 650,
                          child: Column(
                            children: [
                              Container(
                                height: 250.0,
                                width:
                                    MediaQuery.of(context).size.width - 100.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.transparent,
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/sample.jpg'),
                                        fit: BoxFit.cover)),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                                onTap: () {},
                                                child: const Text(
                                                  "PT",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Center(
                                          heightFactor:
                                              BorderSide.strokeAlignCenter,
                                          child: Container(
                                            color:
                                                Colors.white.withOpacity(.50),
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 10, 5, 2),
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0.0, 0, 0, 2),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${_foundUsers[index].firstName}, (27)",
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const Spacer(),
                                                      RatingBar(
                                                          initialRating: random
                                                                  .nextInt(4) +
                                                              1,
                                                          minRating: 0,
                                                          maxRating: 5,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          itemSize: 20,
                                                          ratingWidget:
                                                              RatingWidget(
                                                                  full: const Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                          .orange),
                                                                  half:
                                                                      const Icon(
                                                                    Icons
                                                                        .star_half,
                                                                    color: Colors
                                                                        .orange,
                                                                  ),
                                                                  empty:
                                                                      const Icon(
                                                                    Icons
                                                                        .star_outline,
                                                                    color: Colors
                                                                        .orange,
                                                                  )),
                                                          onRatingUpdate:
                                                              (value) {
                                                            // _ratingValue = value;
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0.0, 0, 0, 2),
                                                  child: Text(_foundUsers[index]
                                                          .country
                                                          .isEmpty
                                                      ? 'Add Country'
                                                      : _foundUsers[index]
                                                          .country),
                                                ),
                                                Text(_foundUsers[index]
                                                        .language
                                                        .isEmpty
                                                    ? 'Add Language'
                                                    : _foundUsers[index]
                                                        .language
                                                        .join(', ')),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5.0, 2, 5, 0),
                                child: Container(
                                  height: 55,
                                  child: Text(
                                    // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat',
                                    _foundUsers[index]
                                            .promotionalMessage
                                            .isEmpty
                                        ? 'Add Message'
                                        : _foundUsers[index].promotionalMessage,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5.0, 0, 5, 2),
                                child: Row(
                                  children: const [
                                    Text(
                                      "Starting from \$25 per classes ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: kColorPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          )
        : SizedBox(
            width: size.width - 400,
            height: size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/nodata.jpg',
                    width: 500.0,
                    height: 300.0,
                    fit: BoxFit.fill,
                  ),
                  const Text(
                    "NO DATA FOUND",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ));
  }
}
