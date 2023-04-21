import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/themes.dart';

class PerformancePage extends StatefulWidget {
  const PerformancePage({super.key});

  @override
  State<PerformancePage> createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black45,
            width: .1,
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(5.0),
            topLeft: Radius.circular(5.0),
          ),
        ),
        width: size.width - 320,
        height: size.height - 75,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: size.width - 310,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: kColorPrimary,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "PERFORMANCE",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Row(
              children: [
                RatingBar(
                    initialRating: 5,
                    minRating: 0,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.orange),
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
                  width: 5,
                ),
                Text(
                  "(15)",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                RatingBar(
                    initialRating: 4,
                    minRating: 0,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.orange),
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
                  width: 5,
                ),
                Text(
                  "(16)",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                RatingBar(
                    initialRating: 3,
                    minRating: 0,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.orange),
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
                  width: 5,
                ),
                Text(
                  "(17)",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                RatingBar(
                    initialRating: 2,
                    minRating: 0,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.orange),
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
                  width: 5,
                ),
                Text(
                  "(2)",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                RatingBar(
                    initialRating: 1,
                    minRating: 0,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.orange),
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
                  width: 5,
                ),
                Text(
                  "(0)",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Rating:",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  "4.5",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Reviews',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 25,
                          color: kColorPrimary,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            'assets/images/login.png',
                            width: 300.0,
                            height: 100.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Melvin Jhon",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Spacer(),
                        RatingBar(
                            initialRating: 4.5,
                            minRating: 0,
                            maxRating: 5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            ratingWidget: RatingWidget(
                                full:
                                    const Icon(Icons.star, color: Colors.orange),
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                   const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            'assets/images/login.png',
                            width: 300.0,
                            height: 100.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Melvin Jhon",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Spacer(),
                        RatingBar(
                            initialRating: 4.5,
                            minRating: 0,
                            maxRating: 5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            ratingWidget: RatingWidget(
                                full:
                                    const Icon(Icons.star, color: Colors.orange),
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),),
                     const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            'assets/images/login.png',
                            width: 300.0,
                            height: 100.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Melvin Jhon",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Spacer(),
                        RatingBar(
                            initialRating: 4.5,
                            minRating: 0,
                            maxRating: 5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            ratingWidget: RatingWidget(
                                full:
                                    const Icon(Icons.star, color: Colors.orange),
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
