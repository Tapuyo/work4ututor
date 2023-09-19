import 'dart:js';

import 'package:dotted_border/dotted_border.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work4ututor/ui/web/admin/admin_sharedcomponents/rejected.dart';

import '../../../../constant/constant.dart';
import 'assigned_task.dart';

class ListInterviewDateData {
  final DateTime date;
  final String name;
  final String address;

  const ListInterviewDateData({
    required this.date,
    required this.name,
    required this.address,
  });
}

// ignore: must_be_immutable
class ListTaskDate extends StatelessWidget {
  final BuildContext context;
  final Map<String, dynamic> onDataReceived;
  ListTaskDate({
    required this.data,
    required this.onPressed,
    this.dividerColor,
    Key? key,
    required this.context,
    required this.onDataReceived,
  }) : super(key: key);

  final ListInterviewDateData data;
  final Function() onPressed;
  final Color? dividerColor;
  String _selectedValue = 'Status';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(kSpacing / 2),
        child: Row(
          children: [
            _buildHours(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing),
              child: _buildDivider(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 5),
                  _buildSubtitle(),
                ],
              ),
            ),
            const Spacer(),
            _buildNewApplicantsbutton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHours() {
    return Text(
      DateFormat.Hm().format(data.date),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 3,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        gradient: LinearGradient(
          colors: [
            dividerColor ?? Colors.amber,
            dividerColor?.withOpacity(.6) ?? Colors.amber.withOpacity(.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      data.address,
      maxLines: 1,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w200,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      data.name,
      maxLines: 1,
      style: const TextStyle(fontWeight: FontWeight.w600),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildNewApplicantsbutton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            decoration: BoxDecoration(
              color: Colors.blue, // Set the background color
              borderRadius: BorderRadius.circular(15.0), // Make it circular
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 5), // Adjust padding as needed
            child: DropdownButton<String>(
              value: _selectedValue,
              onChanged: (newValue) {
                // Update the selected value here
                _selectedValue = newValue!;
                if (_selectedValue == "Approve") {
                } else if (_selectedValue == "Reject") {
                  showRejectionForm(context, onDataReceived);
                } else {}
              },
              alignment: Alignment.center,
              elevation: 2,
              items: <String>['Status', 'Approve', 'Reject']
                  .map<DropdownMenuItem<String>>((String value) {
                Color textColor = value == 'Reject'
                    ? Colors.red
                    : value == 'Approve'
                        ? Colors.green
                        : Colors.white;

                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: textColor), // Set the text color
                  ),
                );
              }).toList(),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ), // Provide an arrow icon
              iconEnabledColor: Colors.black, // Set icon color
              underline: const SizedBox.shrink(), // Hide the default underline
            )),
        const SizedBox(
          width: 2,
        ),
        DottedBorder(
          color: kFontColorPallets[1],
          strokeWidth: .3,
          strokeCap: StrokeCap.round,
          borderType: BorderType.Circle,
          child: IconButton(
            onPressed: () {
              showRejectionForm(context, onDataReceived);
            },
            color: kFontColorPallets[1],
            iconSize: 15,
            icon: const Icon(EvaIcons.plus),
            splashRadius: 24,
            tooltip: "Assign",
          ),
        ),
      ],
    );
  }

  void showRejectionForm(
      BuildContext context, Map<String, dynamic> tutorsinfo) {
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
                    child: RejectedInfo(
                      onDataReceived: tutorsinfo,
                    ),
                  );
                },
              ),
            ));
  }

  void showTaskForm(BuildContext context, Map<String, dynamic> tutorsinfo) {
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
                    child: const AssignTask(
                      // onDataReceived: tutorsinfo,
                    ),
                  );
                },
              ),
            ));
  }
}
