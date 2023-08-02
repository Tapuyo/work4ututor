import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/data_class/reviewclass.dart';
import 'package:wokr4ututor/provider/tutor_reviews_provider.dart';

import '../../../../utils/themes.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PerformancePage extends HookWidget {
  final String uID;
  PerformancePage({super.key, required this.uID});

//  List<charts.Series<OrdinalSales, String>> seriesList = [
//   charts.Series<OrdinalSales, String>(
//     id: 'sales',
//     domainFn: (OrdinalSales sales, _) => sales.year,
//     measureFn: (OrdinalSales sales, _) => sales.sales,
//     data: [
//       OrdinalSales('2016', 500),
//       OrdinalSales('2017', 1500),
//       OrdinalSales('2018', 2000),
//       OrdinalSales('2019', 1000),
//     ],
//   ),
// ];

  DateTime? _fromselectedDate;
  DateTime? _toselectedDate;
  // void _pickDateDialog() {
  //   showDatePicker(
  //           context: context,
  //           initialDate: DateTime.now(),
  //           //which date will display when user open the picker
  //           firstDate: DateTime(1950),
  //           //what will be the previous supported year in picker
  //           lastDate: DateTime
  //               .now()) //what will be the up to supported date in picker
  //       .then((pickedDate) {
  //     //then usually do the future job
  //     if (pickedDate == null) {
  //       //if user tap cancel then this function will stop
  //       return;
  //     }
  //     setState(() {
  //       //for rebuilding the ui
  //       _fromselectedDate = pickedDate;
  //     });
  //   });
  // }

  // void _topickDateDialog() {
  //   showDatePicker(
  //           context: context,
  //           initialDate: DateTime.now(),
  //           //which date will display when user open the picker
  //           firstDate: DateTime(1950),
  //           //what will be the previous supported year in picker
  //           lastDate: DateTime
  //               .now()) //what will be the up to supported date in picker
  //       .then((pickedDate) {
  //     //then usually do the future job
  //     if (pickedDate == null) {
  //       //if user tap cancel then this function will stop
  //       return;
  //     }
  //     setState(() {
  //       //for rebuilding the ui
  //       _toselectedDate = pickedDate;
  //     });
  //   });
  // }

  bool select = false;

  String dropdownValue = 'English';
  Color buttonColor = kCalendarColorAB;
  @override
  Widget build(BuildContext context) {
    final provider = context.read<IndividualReviewProvider>();

    final List<ReviewModel> reviewdata =
        context.select((IndividualReviewProvider p) => p.reviews);

    final bool isLoading =
        context.select((IndividualReviewProvider p) => p.onLoading);

    final bool isRefresh =
        context.select((IndividualReviewProvider p) => p.isrefresh);

    useEffect(() {
      Future.microtask(() async {
        provider.getReviews(context, uID);
      });
      return;
    }, [isRefresh]);
    Size size = MediaQuery.of(context).size;
    final data = generateChartData();

    final seriesList = [
      charts.Series<ChartData, String>(
        id: 'Sample',
        domainFn: (ChartData data, _) => data.month,
        measureFn: (ChartData data, _) => data.value,
        data: data,
        labelAccessorFn: (ChartData data, _) => '${data.value}',
      )
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5.0),
            topLeft: Radius.circular(5.0),
          ),
        ),
        width: size.width - 320,
        height: size.height - 75,
        child: Card(
          elevation: 4,
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
                  children: const [
                    Text(
                      "PERFORMANCE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                              width: 5,
                            ),
                            const Text(
                              "(15)",
                              style: TextStyle(
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
                              width: 5,
                            ),
                            const Text(
                              "(16)",
                              style: TextStyle(
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
                              width: 5,
                            ),
                            const Text(
                              "(17)",
                              style: TextStyle(
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
                              width: 5,
                            ),
                            const Text(
                              "(2)",
                              style: TextStyle(
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
                              width: 5,
                            ),
                            const Text(
                              "(0)",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: const [
                            Text(
                              "Rating:",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "4.5",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: charts.PieChart(
                      seriesList,
                      animate: true,
                      defaultRenderer: charts.ArcRendererConfig(
                        arcRendererDecorators: <
                            charts.ArcLabelDecorator<String>>[
                          charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.auto,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 600,
                    height: 300,
                    child: charts.BarChart(
                      seriesList,
                      animate: true,
                      domainAxis: const charts.OrdinalAxisSpec(
                        renderSpec: charts.SmallTickRendererSpec(
                          labelRotation:
                              60, // Rotate labels for better visibility
                        ),
                      ),
                      primaryMeasureAxis: const charts.NumericAxisSpec(
                        tickProviderSpec: charts.BasicNumericTickProviderSpec(
                          zeroBound: false, // Exclude zero from the axis
                        ),
                        renderSpec: charts.GridlineRendererSpec(
                          labelAnchor: charts.TickLabelAnchor
                              .before, // Position the labels to the right of the axis
                          labelJustification:
                              charts.TickLabelJustification.outside,
                          labelOffsetFromAxisPx: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      flex: 12,
                      child: Container(
                        width: size.width - 320,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Card(
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  "Date Inquire:",
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
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
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
                                            : DateFormat.yMMMMd()
                                                .format(_toselectedDate!),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
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
                                  "Subject:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
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
                                  value: dropdownValue,
                                  onChanged: (newValue) {
                                    dropdownValue = newValue!;
                                  },
                                  underline: Container(),
                                  items: <String>[
                                    'English',
                                    'Math',
                                    'Filipino',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        width: 110,
                                        child: Text(
                                          value,
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                  onPressed: () {},
                                  child: const Text('Search'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
              const Divider(
                color: Colors.black45,
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
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: (size.height / 2) - 192,
                      width: size.width - 320,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: reviewdata.length,
                          itemBuilder: (context, index) {
                            final reviews = reviewdata[index];
                            return SizedBox(
                              child: Column(
                                children: [
                                  Row(
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
                                      Text(
                                        reviewdata[index].studentID,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const Spacer(),
                                      RatingBar(
                                          initialRating: double.parse(
                                              reviewdata[index].rating),
                                          minRating: 0,
                                          maxRating: 5,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 20,
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
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      reviewdata[index].comment,
                                      textAlign: TextAlign.justify,
                                      // maxLines: 2,
                                      // overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<ChartData> generateChartData() {
  return [
    ChartData('Jan', 5),
    ChartData('Feb', 10),
    ChartData('Mar', 15),
    ChartData('Apr', 20),
    ChartData('May', 25),
    ChartData('Jun', 30),
  ];
}

class ChartData {
  final String month;
  final int value;

  ChartData(this.month, this.value);
}
