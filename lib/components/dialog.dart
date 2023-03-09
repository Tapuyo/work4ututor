import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wokr4ututor/ui/web/signup/tutor_information_signup.dart';

class DialogShow extends StatelessWidget {
   String response;
   DialogShow(this.response, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
          title: const Text('Work4utuTor Alert'),
          content: Text(response.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TutorInfo()),
                      ), 
              child: const Text('OK'),
            ),
          ],
        );
  }
}
void showCustomDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 240,
          child: SizedBox.expand(child: FlutterLogo()),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: Offset(1, 0), end: Offset.zero);
      }
  
      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}