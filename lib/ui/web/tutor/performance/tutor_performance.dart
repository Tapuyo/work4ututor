import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/provider/performacefilter.dart';

import '../../../../data_class/reviewclass.dart';
import '../../../../provider/tutor_reviews_provider.dart';
import '../../../../services/getmyrating.dart';
import '../../../../shared_components/responsive_builder.dart';
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
  void _pickDateDialog(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      final provider = context.read<FilterPerformanceProvider>();
      provider.setFromDate(pickedDate);
    });
  }

  void _topickDateDialog(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      final provider = context.read<FilterPerformanceProvider>();
      provider.setToDate(pickedDate);
    });
  }

  bool select = false;

  String dropdownValue = 'English';
  Color buttonColor = kCalendarColorAB;
  List<ChartData> chartdata = [];
  DateTime? _tempfromselectedDate;
  DateTime? _temptoselectedDate;
  @override
  Widget build(BuildContext context) {
    final RatingNotifier ratingNotifier = RatingNotifier();
    // final provider = context.read<IndividualReviewProvider>();

    // final bool isLoading =
    //     context.select((IndividualReviewProvider p) => p.onLoading);

    // final bool isRefresh =
    //     context.select((IndividualReviewProvider p) => p.isrefresh);

    // useEffect(() {
    //   Future.microtask(() async {
    //     provider.getReviews(context, uID);
    //   });
    //   return;
    // }, [isRefresh]);
    Size size = MediaQuery.of(context).size;

    // final seriesList = [
    //   charts.Series<ChartData, String>(
    //     id: 'Sample',
    //     domainFn: (ChartData data, _) => data.month,
    //     measureFn: (ChartData data, _) => data.value,
    //     data: chartdata,
    //     labelAccessorFn: (ChartData data, _) => '${data.value}',
    //   )
    // ];

    return FutureBuilder<List<Map<String, dynamic>>?>(
        future: ratingNotifier.getRating(uID),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                height: size.height - 180,
                width: ResponsiveBuilder.isDesktop(context)
                    ? size.width - 320
                    : size.width - 10,
                child: const Center(
                  child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator()),
                ));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          DateTime? fromdate = context.select(
              (FilterPerformanceProvider fromdate) => fromdate.fromdate);
          DateTime? todate = context
              .select((FilterPerformanceProvider fromdate) => fromdate.todate);
          final List<Map<String, dynamic>>? reviewdata = snapshot.data;
          double averageRating = 0;
          List<Map<String, dynamic>>? reviewdatafinal;
          if (reviewdata!.isNotEmpty) {
            double totalRating = 0;

            reviewdata.forEach((review) {
              totalRating += review['totalRating'] ?? 0;
            });

            averageRating = totalRating / reviewdata.length;
            if (fromdate != null && todate != null) {
              reviewdatafinal = reviewdata.where((item) {
                DateTime itemDate = item['datereview'].toDate();
                print(item['datereview'].toDate());
                print(fromdate);
                print(todate);
                return itemDate
                        .isAfter(fromdate.subtract(const Duration(days: 1))) &&
                    itemDate.isBefore(todate.add(const Duration(days: 1)));
              }).toList();
            } else {
              reviewdatafinal = reviewdata;
            }
          }
          return reviewdatafinal != null
              ? Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  width: ResponsiveBuilder.isDesktop(context)
                      ? size.width - 270
                      : size.width,
                  child: Column(
                    children: <Widget>[
                      Card(
                        margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                        elevation: 4,
                        child: Container(
                          height: 50,
                          width: ResponsiveBuilder.isDesktop(context)
                              ? size.width - 300
                              : size.width - 30,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment(-0.1, 0),
                              end: Alignment.centerRight,
                              colors: secondaryHeadercolors,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                "Performance",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     SizedBox(
                      //       width: 200,
                      //       height: 300,
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           Row(
                      //             children: [
                      //               RatingBar(
                      //                   initialRating: 5,
                      //                   minRating: 0,
                      //                   maxRating: 5,
                      //                   direction: Axis.horizontal,
                      //                   allowHalfRating: true,
                      //                   itemCount: 5,
                      //                   itemSize: 30,
                      //                   ratingWidget: RatingWidget(
                      //                       full: const Icon(Icons.star,
                      //                           color: Colors.orange),
                      //                       half: const Icon(
                      //                         Icons.star_half,
                      //                         color: Colors.orange,
                      //                       ),
                      //                       empty: const Icon(
                      //                         Icons.star_outline,
                      //                         color: Colors.orange,
                      //                       )),
                      //                   onRatingUpdate: (value) {
                      //                     // _ratingValue = value;
                      //                   }),
                      //               const SizedBox(
                      //                 width: 5,
                      //               ),
                      //               const Text(
                      //                 "(15)",
                      //                 style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.normal,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           Row(
                      //             children: [
                      //               RatingBar(
                      //                   initialRating: 4,
                      //                   minRating: 0,
                      //                   maxRating: 5,
                      //                   direction: Axis.horizontal,
                      //                   allowHalfRating: true,
                      //                   itemCount: 5,
                      //                   itemSize: 30,
                      //                   ratingWidget: RatingWidget(
                      //                       full: const Icon(Icons.star,
                      //                           color: Colors.orange),
                      //                       half: const Icon(
                      //                         Icons.star_half,
                      //                         color: Colors.orange,
                      //                       ),
                      //                       empty: const Icon(
                      //                         Icons.star_outline,
                      //                         color: Colors.orange,
                      //                       )),
                      //                   onRatingUpdate: (value) {
                      //                     // _ratingValue = value;
                      //                   }),
                      //               const SizedBox(
                      //                 width: 5,
                      //               ),
                      //               const Text(
                      //                 "(16)",
                      //                 style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.normal,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           Row(
                      //             children: [
                      //               RatingBar(
                      //                   initialRating: 3,
                      //                   minRating: 0,
                      //                   maxRating: 5,
                      //                   direction: Axis.horizontal,
                      //                   allowHalfRating: true,
                      //                   itemCount: 5,
                      //                   itemSize: 30,
                      //                   ratingWidget: RatingWidget(
                      //                       full: const Icon(Icons.star,
                      //                           color: Colors.orange),
                      //                       half: const Icon(
                      //                         Icons.star_half,
                      //                         color: Colors.orange,
                      //                       ),
                      //                       empty: const Icon(
                      //                         Icons.star_outline,
                      //                         color: Colors.orange,
                      //                       )),
                      //                   onRatingUpdate: (value) {
                      //                     // _ratingValue = value;
                      //                   }),
                      //               const SizedBox(
                      //                 width: 5,
                      //               ),
                      //               const Text(
                      //                 "(17)",
                      //                 style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.normal,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           Row(
                      //             children: [
                      //               RatingBar(
                      //                   initialRating: 2,
                      //                   minRating: 0,
                      //                   maxRating: 5,
                      //                   direction: Axis.horizontal,
                      //                   allowHalfRating: true,
                      //                   itemCount: 5,
                      //                   itemSize: 30,
                      //                   ratingWidget: RatingWidget(
                      //                       full: const Icon(Icons.star,
                      //                           color: Colors.orange),
                      //                       half: const Icon(
                      //                         Icons.star_half,
                      //                         color: Colors.orange,
                      //                       ),
                      //                       empty: const Icon(
                      //                         Icons.star_outline,
                      //                         color: Colors.orange,
                      //                       )),
                      //                   onRatingUpdate: (value) {
                      //                     // _ratingValue = value;
                      //                   }),
                      //               const SizedBox(
                      //                 width: 5,
                      //               ),
                      //               const Text(
                      //                 "(2)",
                      //                 style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.normal,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           Row(
                      //             children: [
                      //               RatingBar(
                      //                   initialRating: 1,
                      //                   minRating: 0,
                      //                   maxRating: 5,
                      //                   direction: Axis.horizontal,
                      //                   allowHalfRating: true,
                      //                   itemCount: 5,
                      //                   itemSize: 30,
                      //                   ratingWidget: RatingWidget(
                      //                       full: const Icon(Icons.star,
                      //                           color: Colors.orange),
                      //                       half: const Icon(
                      //                         Icons.star_half,
                      //                         color: Colors.orange,
                      //                       ),
                      //                       empty: const Icon(
                      //                         Icons.star_outline,
                      //                         color: Colors.orange,
                      //                       )),
                      //                   onRatingUpdate: (value) {
                      //                     // _ratingValue = value;
                      //                   }),
                      //               const SizedBox(
                      //                 width: 5,
                      //               ),
                      //               const Text(
                      //                 "(0)",
                      //                 style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.normal,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           Row(
                      //             children: const [
                      //               Text(
                      //                 "Rating:",
                      //                 style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontSize: 18,
                      //                   fontWeight: FontWeight.w600,
                      //                 ),
                      //               ),
                      //               Text(
                      //                 "4.5",
                      //                 style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontSize: 18,
                      //                   fontWeight: FontWeight.w600,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     const Spacer(),
                      //     // SizedBox(
                      //     //   width: 300,
                      //     //   height: 300,
                      //     //   child: charts.PieChart(
                      //     //     seriesList,
                      //     //     animate: true,
                      //     //     defaultRenderer: charts.ArcRendererConfig(
                      //     //       arcRendererDecorators: <
                      //     //           charts.ArcLabelDecorator<String>>[
                      //     //         charts.ArcLabelDecorator(
                      //     //           labelPosition:
                      //     //               charts.ArcLabelPosition.auto,
                      //     //         ),
                      //     //       ],
                      //     //     ),
                      //     //   ),
                      //     // ),
                      //     // const Spacer(),
                      //     // SizedBox(
                      //     //   width: 600,
                      //     //   height: 300,
                      //     //   child: charts.BarChart(
                      //     //     seriesList,
                      //     //     animate: true,
                      //     //     domainAxis: const charts.OrdinalAxisSpec(
                      //     //       renderSpec: charts.SmallTickRendererSpec(
                      //     //         labelRotation:
                      //     //             60, // Rotate labels for better visibility
                      //     //       ),
                      //     //     ),
                      //     //     primaryMeasureAxis:
                      //     //         const charts.NumericAxisSpec(
                      //     //       tickProviderSpec:
                      //     //           charts.BasicNumericTickProviderSpec(
                      //     //         zeroBound:
                      //     //             false, // Exclude zero from the axis
                      //     //       ),
                      //     //       renderSpec: charts.GridlineRendererSpec(
                      //     //         labelAnchor: charts.TickLabelAnchor
                      //     //             .before, // Position the labels to the right of the axis
                      //     //         labelJustification:
                      //     //             charts.TickLabelJustification.outside,
                      //     //         labelOffsetFromAxisPx: 12,
                      //     //       ),
                      //     //     ),
                      //     //   ),
                      //     // ),

                      //   ],
                      // ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              flex: 60,
                              child: Card(
                                margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                                elevation: 4,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Consumer<FilterPerformanceProvider>(
                                      builder: (context, filterdata, _) {
                                    _tempfromselectedDate = filterdata.fromdate;
                                    _temptoselectedDate = filterdata.todate;
                                    return Container(
                                      // width: size.width - 300,
                                      height:
                                          ResponsiveBuilder.isMobile(context)
                                              ? 100
                                              : 50,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: ResponsiveBuilder.isMobile(context)
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  width: 185,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: kColorGrey,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          _tempfromselectedDate ==
                                                                  null
                                                              ? 'From'
                                                              : DateFormat
                                                                      .yMMMMd()
                                                                  .format(
                                                                      _tempfromselectedDate!),
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: kColorGrey,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          _pickDateDialog(
                                                              context);
                                                        },
                                                        child: const Icon(
                                                          Icons.calendar_month,
                                                          size: 20,
                                                          color: kColorPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  width: 185,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: kColorGrey,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          _temptoselectedDate ==
                                                                  null
                                                              ? 'To'
                                                              : DateFormat
                                                                      .yMMMMd()
                                                                  .format(
                                                                      _temptoselectedDate!),
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: kColorGrey,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          _topickDateDialog(
                                                              context);
                                                        },
                                                        child: const Icon(
                                                          Icons.calendar_month,
                                                          size: 20,
                                                          color: kColorPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Text(
                                                        "Review %:",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: kColorGrey,
                                                        ),
                                                      ),
                                                    ),
                                                    RatingBar(
                                                        ignoreGestures: true,
                                                        initialRating:
                                                            averageRating,
                                                        minRating: 0,
                                                        maxRating: 5,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount:
                                                            size.width < 700
                                                                ? 1
                                                                : 5,
                                                        itemSize: 20,
                                                        ratingWidget:
                                                            RatingWidget(
                                                                full: const Icon(
                                                                    Icons.star,
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
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        averageRating
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: kColorGrey),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                // const Padding(
                                                //   padding: EdgeInsets.all(5.0),
                                                //   child: Text(
                                                //     "Date Reviewed:",
                                                //     style: TextStyle(
                                                //       fontWeight:
                                                //           FontWeight.w600,
                                                //       color: kColorGrey,
                                                //     ),
                                                //   ),
                                                // ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  width: 185,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: kColorGrey,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          _tempfromselectedDate ==
                                                                  null
                                                              ? 'From'
                                                              : DateFormat
                                                                      .yMMMMd()
                                                                  .format(
                                                                      _tempfromselectedDate!),
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: kColorGrey,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          _pickDateDialog(
                                                              context);
                                                        },
                                                        child: const Icon(
                                                          Icons.calendar_month,
                                                          size: 20,
                                                          color: kColorPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "to",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: kColorGrey,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  width: 185,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: kColorGrey,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          _temptoselectedDate ==
                                                                  null
                                                              ? 'To'
                                                              : DateFormat
                                                                      .yMMMMd()
                                                                  .format(
                                                                      _temptoselectedDate!),
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: kColorGrey,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          _topickDateDialog(
                                                              context);
                                                        },
                                                        child: const Icon(
                                                          Icons.calendar_month,
                                                          size: 20,
                                                          color: kColorPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // const SizedBox(
                                                //   width: 10,
                                                // ),
                                                // SizedBox(
                                                //   width: 100,
                                                //   child: ElevatedButton(
                                                //     style: ElevatedButton.styleFrom(
                                                //       backgroundColor: kColorPrimary,
                                                //       shape:
                                                //           const RoundedRectangleBorder(
                                                //               borderRadius:
                                                //                   BorderRadius.all(
                                                //                       Radius.circular(
                                                //                           5))),
                                                //     ),
                                                //     onPressed: () {},
                                                //     child: const Text('Search'),
                                                //   ),
                                                // ),

                                                const Spacer(),
                                                RatingBar(
                                                    ignoreGestures: true,
                                                    initialRating:
                                                        averageRating,
                                                    minRating: 0,
                                                    maxRating: 5,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: size.width < 700
                                                        ? 1
                                                        : 5,
                                                    itemSize: 20,
                                                    ratingWidget: RatingWidget(
                                                        full: const Icon(
                                                            Icons.star,
                                                            color:
                                                                Colors.orange),
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
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    averageRating.toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: kColorGrey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    );
                                  }),
                                ),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Card(
                        margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                        elevation: 4,
                        child: SizedBox(
                          height: size.height - 115,
                          child: Padding(
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
                                  height: 8,
                                ),
                                SizedBox(
                                  height: size.height - 180,

                                  // width: size.width - 320,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: reviewdatafinal.length,
                                      itemBuilder: (context, index) {
                                        final reviews = reviewdata[index];
                                        // chartdata.add(ChartData(reviewdata[index]
                                        //                 ['datereview'].toString(), reviewdata[index]
                                        //                 ['totalRating']));
                                        return SizedBox(
                                          width: ResponsiveBuilder.isDesktop(
                                                  context)
                                              ? size.width - 300
                                              : size.width - 30,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundColor:
                                                        Colors.transparent,
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
                                                    reviewdata[index]
                                                        ['studentName'],
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: kColorGrey),
                                                  ),
                                                  const Spacer(),
                                                  RatingBar(
                                                      ignoreGestures: true,
                                                      initialRating:
                                                          reviewdata[index]
                                                              ['totalRating'],
                                                      minRating: 0,
                                                      maxRating: 5,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount:
                                                          size.width < 320
                                                              ? 1
                                                              : 5,
                                                      itemSize: 20,
                                                      ratingWidget:
                                                          RatingWidget(
                                                              full: const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .orange),
                                                              half: const Icon(
                                                                Icons.star_half,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                              empty: const Icon(
                                                                Icons
                                                                    .star_outline,
                                                                color: Colors
                                                                    .orange,
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
                                                  reviewdata[index]['review'],
                                                  textAlign: TextAlign.start,
                                                  // maxLines: 2,
                                                  // overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: kColorGrey),
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
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  width: size.width - 320,
                  height: size.height - 75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.list,
                        size: 50,
                        color: kColorPrimary,
                      ),
                      Text(
                        'No Review found!',
                        style: TextStyle(color: kCalendarColorB, fontSize: 18),
                      ),
                    ],
                  ));
        });
  }
}

class ChartData {
  final String month;
  final int value;

  ChartData(this.month, this.value);
}
