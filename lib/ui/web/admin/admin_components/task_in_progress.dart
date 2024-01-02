part of dashboard;

class _TaskInProgress extends StatelessWidget {
  const _TaskInProgress({
    required this.data,
    Key? key,
  }) : super(key: key);

  final List<CardTaskData> data;

  @override
  Widget build(BuildContext context) {
    final chartdata = generateChartData();
    final seriesList = [
      charts.Series<ChartData, String>(
        id: 'Sample',
        domainFn: (ChartData data, _) => data.month,
        measureFn: (ChartData data, _) => data.value,
        data: chartdata,
        labelAccessorFn: (ChartData data, _) => '${data.value}',
      )
    ];
    return ClipRRect(
       borderRadius: BorderRadius.circular(kBorderRadius * 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getSequenceColor(1),
                    _getSequenceColor(1).withOpacity(.7)
                  ],
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                ),
              ),
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            EvaIcons.personOutline,
                            color: Colors.white,
                            size: 60,
                          ),
                          const SizedBox(width: 5),
                          Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                '2000',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(.8),
                                ),
                              ),
                              Text(
                                'Tutors',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(.8),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getSequenceColor(2),
                    _getSequenceColor(2).withOpacity(.7)
                  ],
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                ),
              ),
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            EvaIcons.peopleOutline,
                            color: Colors.white,
                            size: 60,
                          ),
                          const SizedBox(width: 5),
                          Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                '20',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(.8),
                                ),
                              ),
                              Text(
                                'Students',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(.8),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getSequenceColor(3),
                    _getSequenceColor(3).withOpacity(.7)
                  ],
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                ),
              ),
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            EvaIcons.personAddOutline,
                            color: Colors.white,
                            size: 60,
                          ),
                          const SizedBox(width: 5),
                          Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(.8),
                                ),
                              ),
                              Text(
                                'New Tutors',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(.8),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getSequenceColor(4),
                    _getSequenceColor(4).withOpacity(.7)
                  ],
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                ),
              ),
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            EvaIcons.personDeleteOutline,
                            color: Colors.white,
                            size: 60,
                          ),
                          const SizedBox(width: 5),
                          Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1000',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(.8),
                                ),
                              ),
                              Text(
                                'Cancelled',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(.8),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSequenceColor(int index) {
    int val = index % 4;
    if (val == 3) {
      return Colors.indigo;
    } else if (val == 2) {
      return Colors.grey;
    } else if (val == 1) {
      return Colors.redAccent;
    } else {
      return Colors.lightBlue;
    }
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
