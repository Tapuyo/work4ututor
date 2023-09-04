part of dashboard;

class _MainMenu extends StatelessWidget {
  const _MainMenu({
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final Function(int index, SelectionButtonData value) onSelected;

  @override
  Widget build(BuildContext context) {
    return SelectionButton(
      data: [
        SelectionButtonData(
          activeIcon: EvaIcons.home,
          icon: EvaIcons.homeOutline,
          label: "Home",
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.messageCircle,
          icon: EvaIcons.messageCircleOutline,
          label: "Messages",
          totalNotif: 1,
        ),
         SelectionButtonData(
          activeIcon: EvaIcons.email,
          icon: EvaIcons.emailOutline,
          label: "Internal Mails",
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.bookOpen,
          icon: EvaIcons.bookOpenOutline,
          label: "Subjects",
          totalNotif: 1,
        ),
         SelectionButtonData(
          activeIcon: EvaIcons.person,
          icon: EvaIcons.personOutline,
          label: "Tutor Profiles",
          totalNotif: 1,
        ),
         SelectionButtonData(
          activeIcon: EvaIcons.people,
          icon: EvaIcons.peopleOutline,
          label: "Student Profile",
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.lock,
          icon: EvaIcons.lockOutline,
          label: "My Admins",
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.listOutline,
          icon: EvaIcons.list,
          label: "Reports",
          // totalNotif: 20,
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.settings,
          icon: EvaIcons.settingsOutline,
          label: "Settings",
        ),
      ],
      onSelected: onSelected,
    );
  }
}
