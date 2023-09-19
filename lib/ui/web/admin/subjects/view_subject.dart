import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work4ututor/ui/web/admin/helpers/app_helpers.dart';

class SubjectData {
  final String dataID;
  final String subjectName;
  final DateTime dateAccepted;
  final String subjectId;
  final String subjectStatus;
  final String totaltutors;

  const SubjectData({
    required this.dataID,
    required this.subjectName,
    required this.dateAccepted,
    required this.subjectId,
    required this.subjectStatus,
    required this.totaltutors,
  });
}

class SubjectList extends StatelessWidget {
  const SubjectList({
    required this.data,
    required this.primary,
    required this.onPrimary,
    Key? key,
  }) : super(key: key);

  final SubjectData data;
  final Color primary;
  final Color onPrimary;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 100,
        height: 250,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, primary.withOpacity(.7)],
            begin: AlignmentDirectional.topCenter,
            end: AlignmentDirectional.bottomCenter,
          ),
        ),
        child: _BackgroundDecoration(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel(),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                _buildJobdesk(),
                const Spacer(flex: 1),
                _buildDate(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return Text(
      data.subjectName,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: onPrimary,
        letterSpacing: 1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildJobdesk() {
    return Container(
      decoration: BoxDecoration(
        color: onPrimary.withOpacity(.3),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        "Total Tutors: ${data.totaltutors}",
        style: TextStyle(
          color: onPrimary,
          fontSize: 12,
          letterSpacing: 1,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDate() {
    return _IconLabel(
      color: onPrimary,
      iconData: EvaIcons.calendarOutline,
      label: DateFormat('MMMM d, yyyy').format(data.dateAccepted),
    );
  }

  Widget _buildHours() {
    return _IconLabel(
      color: onPrimary,
      iconData: EvaIcons.clockOutline,
      label: data.dateAccepted.dueDate(),
    );
  }

  Widget _acceptButton() {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor: onPrimary,
          ),
          icon: const Center(child: Icon(EvaIcons.lockOutline)),
          label: const Text("Block"),
        ),
        // const Spacer(),
        // ElevatedButton.icon(
        //   onPressed: () {},
        //   style: ElevatedButton.styleFrom(
        //     foregroundColor: Colors.red,
        //     backgroundColor: onPrimary,
        //   ),
        //   icon: const Center(child: Icon(EvaIcons.closeCircleOutline)),
        //   label: const Text("Reject"),
        // ),
      ],
    );
  }
}

class _IconLabel extends StatelessWidget {
  const _IconLabel({
    required this.color,
    required this.iconData,
    required this.label,
    Key? key,
  }) : super(key: key);

  final Color color;
  final IconData iconData;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(.8),
          ),
        )
      ],
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Transform.translate(
            offset: const Offset(25, -25),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Transform.translate(
            offset: const Offset(-70, 70),
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
