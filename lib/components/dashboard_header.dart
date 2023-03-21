import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/themes.dart';

class DashboardHeader extends StatelessWidget {
  final String uid;
  final String name; 
  const DashboardHeader({Key? key, required this.uid, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 60,
      padding: const EdgeInsets.fromLTRB(50, 0, 10, 0),
      decoration: const BoxDecoration(
        color: kColorPrimary,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 190,
            child: Image.asset(
              "assets/images/worklogo.png",
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0,10,3,10),
            child: Column(
              children: [
                Text(
                name.toString(),
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                          ),
                RatingBar(
                    initialRating: 4,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20,
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
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
            decoration: BoxDecoration(
              // color: const Color.fromRGBO(1, 118, 132, 1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/sample.jpg',
              ),
              radius: 30,
            ),
          ),
        ],
      ),
    );
  }
}
