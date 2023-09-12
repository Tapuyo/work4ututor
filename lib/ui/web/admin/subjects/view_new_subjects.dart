import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wokr4ututor/ui/web/admin/helpers/app_helpers.dart';
import 'package:wokr4ututor/ui/web/admin/subjects/view_subject.dart';

class NewSubjectList extends StatelessWidget {
  const NewSubjectList({
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildLabel(),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                _buildJobdesk(),
                const Spacer(flex: 1),
                _buildDate(),
                const Spacer(flex: 1),
                _acceptButton(),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        "Total Tutors: ${"0"}",
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
      label: data.dateAccepted.toString(),
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
          onPressed: () {
             updateAdminPosition(data.dataID, 'Active');
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.green,
            backgroundColor: onPrimary,
          ),
          icon: const Center(child: Icon(EvaIcons.checkmarkCircle2Outline)),
          label: const Text("Accept"),
        ),
        const Spacer(
          flex: 1,
        ),
        ElevatedButton.icon(
          onPressed: () {
            updateAdminPosition(data.dataID, 'Reject');
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor: onPrimary,
          ),
          icon: const Center(child: Icon(EvaIcons.closeCircleOutline)),
          label: const Text("Reject"),
        ),
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

class FirebaseServiceSubjects {
  static Future<void> updateAdminField({
    required String dataID,
    required String status,
  }) async {
    CollectionReference adminsCollection =
        FirebaseFirestore.instance.collection('subjects');

    DocumentReference adminDocRef = adminsCollection.doc(dataID);

    await adminDocRef.update({
      'subjectStatus': status,
    });
  }
}

// Example usage inside a function
void updateAdminPosition(String adminId, String newStatus) async {
  try {
    await FirebaseServiceSubjects.updateAdminField(
      status: newStatus, dataID: adminId,
    );
    print('Admin position updated successfully');
  } catch (error) {
    print('Error updating admin position: $error');
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
