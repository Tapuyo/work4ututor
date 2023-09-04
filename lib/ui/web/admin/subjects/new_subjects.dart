part of dashboard;

class _NewSubjects extends StatelessWidget {
  const _NewSubjects({
    required this.newdata,
    Key? key,
  }) : super(key: key);

  final List<SubjectData> newdata;

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    final filteredData =
        controller.subjectList.value.where((item) => item.subjectStatus == "New").toList();
    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius * 2),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          return NewSubjectList(
            data: filteredData[index],
            primary: Colors.greenAccent,
            onPrimary: Colors.white,
          );
        },
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
