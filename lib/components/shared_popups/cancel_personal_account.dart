import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

Future showCancelAccount(BuildContext context, String title) {
  return CoolAlert.show(
    context: context,
    type: CoolAlertType.custom,
    barrierDismissible: true,
    confirmBtnText: 'Yes',
    cancelBtnText: 'No',
    confirmBtnColor: Colors.green,
    showCancelBtn: true,
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
      await CoolAlert.show(
        context: context,
        type: CoolAlertType.custom,
        barrierDismissible: true,
        confirmBtnText: 'Yes',
        cancelBtnText: 'No',
        confirmBtnColor: Colors.green,
        showCancelBtn: true,
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
          CoolAlert.show(
            context: context,
            type: CoolAlertType.custom,
            barrierDismissible: true,
            confirmBtnColor: Colors.green,
            showCancelBtn: false,
            autoCloseDuration: const Duration(seconds: 10),
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
