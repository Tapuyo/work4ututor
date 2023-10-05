import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

showConfirmationDialog(
    BuildContext context, String actiontype, String adminID) {
  final successAlert = buildButton(
    onTap: () {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: 'Transaction Completed Successfully!',
        autoCloseDuration: const Duration(seconds: 2),
      );
    },
    title: 'Success',
    text: 'Transaction Completed Successfully!',
    leadingImage: 'assets/success.gif',
  );

  final errorAlert = buildButton(
    onTap: () {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong',
        backgroundColor: Colors.black,
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
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong',
        backgroundColor: Colors.black,
      );
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Continue"),
    onPressed: () {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: 'Transaction Completed Successfully!',
        autoCloseDuration: const Duration(seconds: 2),
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
