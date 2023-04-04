import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../components/nav_bar.dart';
import '../../../../utils/themes.dart';

class TutorProfile extends StatefulWidget {
  const TutorProfile({super.key});

  @override
  State<TutorProfile> createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile> {
  @override
  Widget build(BuildContext context) {
    const Color background = Color.fromRGBO(55, 116, 135, 1);
    const Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    const double fillPercent = 70; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    const List<double> stops = [0.0, fillStop, fillStop, 1.0];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(55, 116, 135, 1),
        elevation: 0,
        toolbarHeight: 100,
        title: const FindTutorNavbar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      stops: stops,
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 100, right: 100, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          flex: 10,
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: 300,
                                            width: 300,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.transparent,
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/sample.jpg'),
                                                    fit: BoxFit.cover)),
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 10, 0, 10),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: () {},
                                                child: const Icon(
                                                  Icons.arrow_left,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 0.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color:
                                                            Colors.transparent,
                                                        image: const DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/5815489.jpg'),
                                                            fit: BoxFit.cover)),
                                                  )),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color:
                                                            Colors.transparent,
                                                        image: const DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/5815489.jpg'),
                                                            fit: BoxFit.cover)),
                                                  )),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color:
                                                            Colors.transparent,
                                                        image: const DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/5815489.jpg'),
                                                            fit: BoxFit.cover)),
                                                  )),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.black12,
                                                    ),
                                                    child: const Icon(
                                                      Icons.play_circle,
                                                      color: Colors.black87,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: const Icon(
                                              Icons.arrow_right,
                                              size: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Service Provided',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                          //     Container(
                                          // width: 500,
                                          // height: 100,
                                          //       child: GridView.count(
                                          //           mainAxisSpacing: 5,
                                          //           crossAxisSpacing: 5,
                                          //           crossAxisCount: 2,
                                          //           children: List.generate(2,
                                          //               (index) {
                                          //           })),
                                          //     )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: const [
                                        Text(
                                          'Students Enrolled:',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        Icon(Icons.person),
                                        Text(
                                          '20',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color:
                                                Color.fromRGBO(1, 118, 132, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(10),
                                              alignment: Alignment.centerLeft,
                                              foregroundColor: Colors.white,
                                              disabledBackgroundColor:
                                                  Colors.white,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      1,
                                                      118,
                                                      132,
                                                      1), // your color here
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              // ignore: prefer_const_constructors
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontStyle: FontStyle.normal,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            onPressed: () {
                                              // final provider = context.read<InitProvider>();
                                              // provider.setMenuIndex(5);
                                            },
                                            child: const Text(
                                              '2 Classes',
                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color:
                                                Color.fromRGBO(1, 118, 132, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(10),
                                              alignment: Alignment.centerLeft,
                                              foregroundColor: Colors.white,
                                              disabledBackgroundColor:
                                                  Colors.white,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      1,
                                                      118,
                                                      132,
                                                      1), // your color here
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              // ignore: prefer_const_constructors
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontStyle: FontStyle.normal,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            onPressed: () {
                                              // final provider = context.read<InitProvider>();
                                              // provider.setMenuIndex(5);
                                            },
                                            child: const Text(
                                              '3 Classes',
                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color:
                                                Color.fromRGBO(1, 118, 132, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(10),
                                              alignment: Alignment.centerLeft,
                                              foregroundColor: Colors.white,
                                              disabledBackgroundColor:
                                                  Colors.white,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      1,
                                                      118,
                                                      132,
                                                      1), // your color here
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              // ignore: prefer_const_constructors
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontStyle: FontStyle.normal,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            onPressed: () {
                                              // final provider = context.read<InitProvider>();
                                              // provider.setMenuIndex(5);
                                            },
                                            child: const Text(
                                              '5 classes',
                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.black45,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(10),
                                              alignment: Alignment.centerLeft,
                                              foregroundColor: Colors.white,
                                              disabledBackgroundColor:
                                                  Colors.white,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Colors
                                                      .black45, // your color here
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              // final provider = context.read<InitProvider>();
                                              // provider.setMenuIndex(5);
                                            },
                                            child: const Text(
                                              'Customize',
                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      width: 400,
                                      height: 40,
                                      color: Colors.blue,
                                      child: GridView.count(
                                         shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5,
                                          crossAxisCount: 3,
                                          children: List.generate(3, (index) {
                                            bool selection5 = false;
                                            return Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: 120,
                                                  height: 20,
                                                  color: Colors.yellow,
                                                  child: CheckboxListTile(
                                                    title: const Text(
                                                      'Math',
                                                      style:
                                                          TextStyle(fontSize: 15),
                                                    ),
                                                    // subtitle: const Text(
                                                    //     'A computer science portal for geeks.'),
                                                    // secondary: const Icon(Icons.code),
                                                    autofocus: false,
                                                    activeColor: Colors.green,
                                                    checkColor: Colors.white,
                                                    selected: selection5,
                                                    value: selection5,
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selection5 = value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          })),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          height: MediaQuery.of(context).size.height,
                          child: const VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        Flexible(
                          flex: 20,
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RatingBar(
                                          initialRating: 4.5,
                                          minRating: 0,
                                          maxRating: 5,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 25,
                                          ratingWidget: RatingWidget(
                                              full: const Icon(Icons.star,
                                                  color: Colors.orange),
                                              half: const Icon(
                                                Icons.star_half,
                                                color: Colors.orange,
                                              ),
                                              empty: const Icon(
                                                Icons.star_outline,
                                                color: Colors.orange,
                                              )),
                                          onRatingUpdate: (value) {
                                            // _ratingValue = value;
                                          }),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Marian, 28',
                                        style: TextStyle(
                                            fontSize: 35,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'USA, Manchester',
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'English, Filipino, Russian, European',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Chemistry, Science, Math, Language(Filipino, English)',
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat vLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat ',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Align(
//                               alignment: Alignment.topLeft,
//                               child: Material(
//                                 color: Colors.transparent,
//                                 child: InkWell(
//                                     onTap: () {},
//                                     child: Container(
//                                       height: 250.0,
//                                       width: 250,
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           color: Colors.blue,
//                                           image: const DecorationImage(
//                                               image: AssetImage(
//                                                   'assets/images/sample.jpg'),
//                                               fit: BoxFit.cover)),
//                                     )),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           Align(
//                             alignment: Alignment.bottomLeft,
//                             child: Center(
//                               heightFactor: BorderSide.strokeAlignCenter,
//                               child: Container(
//                                 color: Colors.white.withOpacity(.50),
//                                 padding: const EdgeInsets.fromLTRB(5, 10, 5, 2),
//                                 height: 100,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.fromLTRB(
//                                           0.0, 0, 0, 2),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           const Text("'Name', (27)"),
//                                           const Spacer(),
//                                           RatingBar(
//                                               initialRating: 5,
//                                               minRating: 0,
//                                               maxRating: 5,
//                                               direction: Axis.horizontal,
//                                               allowHalfRating: true,
//                                               itemCount: 5,
//                                               itemSize: 20,
//                                               ratingWidget: RatingWidget(
//                                                   full: const Icon(Icons.star,
//                                                       color: Colors.orange),
//                                                   half: const Icon(
//                                                     Icons.star_half,
//                                                     color: Colors.orange,
//                                                   ),
//                                                   empty: const Icon(
//                                                     Icons.star_outline,
//                                                     color: Colors.orange,
//                                                   )),
//                                               onRatingUpdate: (value) {
//                                                 // _ratingValue = value;
//                                               }),
//                                         ],
//                                       ),
//                                     ),
//                                     const Padding(
//                                       padding:
//                                           EdgeInsets.fromLTRB(0.0, 0, 0, 2),
//                                       child: Text('Country'),
//                                     ),
//                                     const Text('language'),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
