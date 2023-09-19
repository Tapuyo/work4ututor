import 'package:dotted_border/dotted_border.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:work4ututor/ui/web/admin/helpers/app_helpers.dart';

import '../../../../constant/constant.dart';

class ListTaskAssignedData {
  final String taskid;
  final String taskname;
  final String tasktype;
  final String taskstatus;
  final DateTime dateassigned;
  final DateTime timeline;
  final String assignTo;

  const ListTaskAssignedData({
    required this.timeline,
    required this.taskid,
    required this.taskname,
    required this.tasktype,
    required this.taskstatus,
    required this.dateassigned,
    required this.assignTo,
  });
}

class ListTaskAssigned extends StatelessWidget {
  const ListTaskAssigned({
    required this.data,
    required this.onPressed,
    required this.onPressedAssign,
    required this.onPressedMember,
    Key? key,
  }) : super(key: key);

  final ListTaskAssignedData data;
  final Function() onPressed;
  final Function()? onPressedAssign;
  final Function()? onPressedMember;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      hoverColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      tileColor: _buildbackground(data.taskstatus, data.timeline),
      leading: _buildIcon(),
      title: _buildTitle(),
      subtitle: _buildSubtitle(),
      trailing: _buildAssign(),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey.withOpacity(.1),
      ),
      child: _buildChildWidget(data.taskstatus),
    );
  }

  Widget _buildChildWidget(String assignmentStatus) {
    if (assignmentStatus == "Assigned") {
      return const Icon(EvaIcons
          .checkmarkCircle2Outline); // Replace with the appropriate EvaIcon
    } else if (assignmentStatus == "Not Assigned") {
      return const Icon(
          EvaIcons.alertCircleOutline); // Replace with the appropriate EvaIcon
    } else if (assignmentStatus == "Finished") {
      return const Icon(EvaIcons
          .checkmarkSquare2Outline); // Replace with the appropriate EvaIcon
    } else {
      return const Icon(EvaIcons
          .questionMarkCircleOutline); // Replace with the appropriate EvaIcon
    }
  }

  _buildbackground(String assignmentStatus, DateTime timeline) {
    if (assignmentStatus == "Assigned" && timeline.isBefore(DateTime.now())) {
      return Colors.red
          .withOpacity(0.2); // Replace with the appropriate EvaIcon
    } else if (assignmentStatus == "Not Assigned") {
      return Colors.transparent; // Replace with the appropriate EvaIcon
    } else if (assignmentStatus == "Finished") {
      return Colors.green
          .withOpacity(0.2); // Replace with the appropriate EvaIcon
    } else {
      return Colors.blue.withOpacity(0.2);
    }
  }

  Widget _buildTitle() {
    return Text(
      data.taskname,
      style: const TextStyle(fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle() {
    // String edit = "";

    // if (data.editDate != null) {
    //   edit = " \u2022 edited ${timeago.format(data.editDate!)}";
    // }

    return Text(
      '${timeago.format(data.timeline)} (${(data.taskstatus)})',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildAssign() {
    return (data.assignTo != null)
        ? InkWell(
            onTap: onPressedMember,
            borderRadius: BorderRadius.circular(22),
            child: Tooltip(
              message: data.assignTo,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.orange.withOpacity(.2),
                child: Text(
                  data.assignTo.getInitialName(2).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        : DottedBorder(
            color: kFontColorPallets[1],
            strokeWidth: .3,
            strokeCap: StrokeCap.round,
            borderType: BorderType.Circle,
            child: IconButton(
              onPressed: onPressedAssign,
              color: kFontColorPallets[1],
              iconSize: 15,
              icon: const Icon(EvaIcons.plus),
              splashRadius: 24,
              tooltip: "assign",
            ),
          );
  }
}
