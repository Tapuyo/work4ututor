part of dashboard;

class _Subjects extends StatelessWidget {
  const _Subjects({
    required this.data,
    Key? key,
  }) : super(key: key);

  final List<SubjectData> data;

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    final filteredData =
        controller.subjectList.value.where((item) => item.subjectStatus == "Active").toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius * 2),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: kSpacing / 2,
          mainAxisSpacing: kSpacing, // Horizontal spacing between columns
        ),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          return SubjectList(
            data: filteredData[index],
            primary: _getSequenceColor(index),
            onPrimary: Colors.white,
          );
        },
      ),
    );
  }

  Widget _buildNewSubject() {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(kSpacing / 2), // Adjust padding as needed
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kBorderRadius * 2),
          child: SubjectList(
            data: data[index],
            primary: _getSequenceColor(index),
            onPrimary: Colors.white,
          ),
        ),
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
  void showAddsubjects(BuildContext context, Map<String, dynamic> tutorsinfo) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return SizedBox(
                    height: height - 200,
                    width: 500,
                    child: AddSchedule(
                      onDataReceived: tutorsinfo,
                    ),
                  );
                },
              ),
            ));
  }
}
