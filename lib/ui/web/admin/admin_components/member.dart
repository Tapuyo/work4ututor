part of dashboard;

class _Member extends StatelessWidget {
  const _Member({
    required this.member,
    Key? key,
  }) : super(key: key);

  final List<AdminsInformation> member;
  final int maxDisplayPeople = 2;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          (member.length > maxDisplayPeople) ? member.length : member.length,
          (index) => SimpleUserProfile(
            name: member[index],
            onPressed: () {},
          ),
        ).toList(),
      ),
    );
  }
}
