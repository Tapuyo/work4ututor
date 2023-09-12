import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

showConfirmationDialog(
    BuildContext context, String actiontype, String adminID) {
  final successAlert = buildButton(
    onTap: () {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Transaction Completed Successfully!',
        autoCloseDuration: const Duration(seconds: 2),
        showConfirmBtn: false,
      );
    },
    title: 'Success',
    text: 'Transaction Completed Successfully!',
    leadingImage: 'assets/success.gif',
  );

  final errorAlert = buildButton(
    onTap: () {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong',
        backgroundColor: Colors.black,
        titleColor: Colors.white,
        textColor: Colors.white,
      );
    },
    title: 'Error',
    text: 'Sorry, something went wrong',
    leadingImage: 'assets/error.gif',
  );
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong',
        backgroundColor: Colors.black,
        titleColor: Colors.white,
        textColor: Colors.white,
      );
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Continue"),
    onPressed: () {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Transaction Completed Successfully!',
        autoCloseDuration: const Duration(seconds: 2),
        showConfirmBtn: false,
      );
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("AlertDialog"),
    content: const Text(
        "Would you like to continue learning how to use Flutter alerts?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Card buildButton({
  required onTap,
  required title,
  required text,
  required leadingImage,
}) {
  return Card(
    shape: const StadiumBorder(),
    margin: const EdgeInsets.symmetric(
      horizontal: 20,
    ),
    clipBehavior: Clip.antiAlias,
    elevation: 1,
    child: ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: AssetImage(
          leadingImage,
        ),
      ),
      title: Text(title ?? ""),
      subtitle: Text(text ?? ""),
      trailing: const Icon(
        Icons.keyboard_arrow_right_rounded,
      ),
    ),
  );
}
