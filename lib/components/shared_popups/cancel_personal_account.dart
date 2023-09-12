import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

Future showCancelAccount(BuildContext context, String title) {
  return QuickAlert.show(
    context: context,
    type: QuickAlertType.custom,
    barrierDismissible: true,
    textAlignment: TextAlign.justify,
    confirmBtnText: 'Yes',
    cancelBtnText: 'No',
    confirmBtnColor: Colors.green,
    showCancelBtn: true,
    customAsset: 'assets/images/warning.gif',
    widget: Center(
      child: Text(title),
    ),
    onConfirmBtnTap: () async {
      // if (message.length < 5) {
      //   await
      // QuickAlert.show(
      //   context: context,
      //   type: QuickAlertType.error,
      //   text: 'Please input something',
      // );
      // return;
      // }
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 1000));
      // ignore: use_build_context_synchronously
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        barrierDismissible: true,
        textAlignment: TextAlign.justify,
        confirmBtnText: 'Yes',
        cancelBtnText: 'No',
        confirmBtnColor: Colors.green,
        showCancelBtn: true,
        customAsset: 'assets/images/warning.gif',
        widget: const Center(
          child: Text(
              'By cancelling, you will permanently close this Student Profile. Are you sure?'),
        ),
        onConfirmBtnTap: () async {
          // if (message.length < 5) {
          //   await
          // QuickAlert.show(
          //   context: context,
          //   type: QuickAlertType.error,
          //   text: 'Please input something',
          // );
          // return;
          // }
          Navigator.pop(context);
          await Future.delayed(const Duration(milliseconds: 1000));
          // ignore: use_build_context_synchronously
          QuickAlert.show(
            context: context,
            type: QuickAlertType.custom,
            barrierDismissible: true,
            textAlignment: TextAlign.justify,
            confirmBtnColor: Colors.green,
            showCancelBtn: false,
            showConfirmBtn: false,
            customAsset: 'assets/images/mail-download.gif',
            autoCloseDuration:  const Duration(seconds: 10),
            widget: const Center(
              child: Text(
                  'To completely close your account open your email and click the link.'),
            ),
          );
        },
        onCancelBtnTap: () {
          Navigator.pop(context);
        },
      );
    },
    onCancelBtnTap: () {
      Navigator.pop(context);
    },
  );
}
