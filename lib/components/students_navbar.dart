// ignore_for_file: avoid_print, avoid_web_libraries_in_flutter, unnecessary_null_comparison

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../provider/chatmessagedisplay.dart';
import '../provider/classinfo_provider.dart';
import '../provider/init_provider.dart';
import '../services/getunreadmessages.dart';
import '../ui/auth/auth.dart';
import '../ui/web/terms/termpage.dart';
import '../utils/themes.dart';

class StudentsMenu extends HookWidget {
  final String uid;
  StudentsMenu(this.uid, {Key? key}) : super(key: key);
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    Provider.of<MessageNotifier>(context, listen: false)
        .getHistory(uid, 'student');
    final int menuIndex = context.select((InitProvider p) => p.menuIndex);
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            final provider = context.read<InitProvider>();
            provider.setMenuIndex(0);
          },
          child: Card(
            margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
            elevation: 4,
            child: Container(
              height: 50,
              width: 260,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: kSecondarycolor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
              ),
              child: SizedBox(
                height: 170,
                width: 200,
                child: Image.asset(
                  "assets/images/STUDENT_DIARY_NO_BG.png",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
          elevation: 4,
          child: SizedBox(
            width: 260,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 220,
                    decoration: menuIndex != 0
                        ? BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          )
                        : BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                  blurRadius: 5.0)
                            ],
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 1.0],
                              colors: buttonFocuscolors,
                            ),
                            color: Colors.deepPurple.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        minimumSize:
                            MaterialStateProperty.all(const Size(220, 50)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        // elevation: MaterialStateProperty.all(3),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        final provider = context.read<InitProvider>();
                        provider.setMenuIndex(0);
                        final provider1 =
                            context.read<ViewClassDisplayProvider>();
                        provider1.setViewClassinfo(false);
                        final provider2 = context.read<ChatDisplayProvider>();
                        provider2.setOpenMessage(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 35,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.home_outlined,
                              size: 30,
                              color: menuIndex == 0 ? Colors.white : kColorGrey,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Dashboard',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: menuIndex == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color:
                                    menuIndex == 0 ? Colors.white : kColorGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 220,
                  decoration: menuIndex != 1
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        )
                      : BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: buttonFocuscolors,
                          ),
                          color: Colors.deepPurple.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all(const Size(220, 50)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      // elevation: MaterialStateProperty.all(3),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      final provider = context.read<InitProvider>();
                      provider.setMenuIndex(1);
                      final provider1 =
                          context.read<ViewClassDisplayProvider>();
                      provider1.setViewClassinfo(false);
                      final provider2 = context.read<ChatDisplayProvider>();
                      provider2.setOpenMessage(false);
                    },
                    // icon: const Icon(
                    //   Icons.calendar_month,
                    //   size: 30,
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 35,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 30,
                            color: menuIndex == 1 ? Colors.white : kColorGrey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Calendar',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: menuIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: menuIndex == 1 ? Colors.white : kColorGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 220,
                  decoration: menuIndex != 3
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        )
                      : BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: buttonFocuscolors,
                          ),
                          color: Colors.deepPurple.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all(const Size(220, 50)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      // elevation: MaterialStateProperty.all(3),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      final provider = context.read<InitProvider>();
                      provider.setMenuIndex(3);
                      final provider2 = context.read<ChatDisplayProvider>();
                      provider2.setOpenMessage(false);
                    },
                    // icon: const Icon(
                    //   Icons.person_add,
                    //   size: 30,
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 35,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.person_add,
                            size: 30,
                            color: menuIndex == 3 ? Colors.white : kColorGrey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Classes',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: menuIndex == 3
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: menuIndex == 3 ? Colors.white : kColorGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 220,
                  decoration: menuIndex != 4
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        )
                      : BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: buttonFocuscolors,
                          ),
                          color: Colors.deepPurple.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all(const Size(220, 50)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      // elevation: MaterialStateProperty.all(3),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      final provider = context.read<InitProvider>();
                      provider.setMenuIndex(4);
                      final provider1 =
                          context.read<ViewClassDisplayProvider>();
                      provider1.setViewClassinfo(false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 35,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.email,
                            size: 30,
                            color: menuIndex == 4 ? Colors.white : kColorGrey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Messages',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: menuIndex == 4
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: menuIndex == 4 ? Colors.white : kColorGrey,
                            ),
                          ),
                          const Spacer(),
                          Consumer<MessageNotifier>(
                              builder: (context, messagedetails, child) {
                            return _buildNotif(messagedetails.messages.length);
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 220,
                  decoration: menuIndex != 9
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        )
                      : BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: buttonFocuscolors,
                          ),
                          color: Colors.deepPurple.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all(const Size(220, 50)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      // elevation: MaterialStateProperty.all(3),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      final provider = context.read<InitProvider>();
                      provider.setMenuIndex(9);
                      final provider1 =
                          context.read<ViewClassDisplayProvider>();
                      provider1.setViewClassinfo(false);
                      final provider2 = context.read<ChatDisplayProvider>();
                      provider2.setOpenMessage(false);
                    },
                    // icon: const Icon(
                    //   EvaIcons.shoppingCart,
                    //   size: 30,
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 35,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            size: 30,
                            color: menuIndex == 9 ? Colors.white : kColorGrey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'My Cart',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: menuIndex == 9
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: menuIndex == 9 ? Colors.white : kColorGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 220,
                  decoration: menuIndex != 6
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        )
                      : BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: buttonFocuscolors,
                          ),
                          color: Colors.deepPurple.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all(const Size(220, 50)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      // elevation: MaterialStateProperty.all(3),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      final provider = context.read<InitProvider>();
                      provider.setMenuIndex(6);
                      final provider1 =
                          context.read<ViewClassDisplayProvider>();
                      provider1.setViewClassinfo(false);
                      final provider2 = context.read<ChatDisplayProvider>();
                      provider2.setOpenMessage(false);
                    },
                    // icon: const Icon(
                    //   Icons.settings,
                    //   size: 30,
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 35,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.settings,
                            size: 30,
                            color: menuIndex == 6 ? Colors.white : kColorGrey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: menuIndex == 6
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: menuIndex == 6 ? Colors.white : kColorGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 220,
                  decoration: menuIndex != 7
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        )
                      : BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: buttonFocuscolors,
                          ),
                          color: Colors.deepPurple.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all(const Size(220, 50)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      // elevation: MaterialStateProperty.all(3),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      final provider = context.read<InitProvider>();
                      provider.setMenuIndex(7);
                      final provider1 =
                          context.read<ViewClassDisplayProvider>();
                      provider1.setViewClassinfo(false);
                      final provider2 = context.read<ChatDisplayProvider>();
                      provider2.setOpenMessage(false);
                    },
                    // icon: const Icon(
                    //   Icons.help_outline_rounded,
                    //   size: 30,
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 35,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.help_outline_rounded,
                            size: 30,
                            color: menuIndex == 7 ? Colors.white : kColorGrey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Help',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: menuIndex == 7
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: menuIndex == 7 ? Colors.white : kColorGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 50,
                  width: 220,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(left: 50),
                      alignment: Alignment.centerLeft,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      GoRouter.of(context)
                          .go('/studentdiary/${uid.toString()}/tutors');
                      // Construct the URL for the desired route
                      // html.window.open(
                      //     '/#/studentdiary/${uid.toString()}/tutors',
                      //     '_blank');
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                      color: kColorPrimary,
                    ),
                    label: const Text(
                      'Search Tutor',
                      style: TextStyle(
                        fontSize: 15,
                        color: kColorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                SizedBox(
                  height: 50,
                  width: 220,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(left: 50),
                      alignment: Alignment.centerLeft,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      CoolAlert.show(
                        context: context,
                        barrierDismissible: false,
                        width: 200,
                        type: CoolAlertType.confirm,
                        text: 'You want to Log Out?',
                        confirmBtnText: 'Proceed',
                        confirmBtnColor: Colors.greenAccent,
                        cancelBtnText: 'Go back',
                        showCancelBtn: true,
                        cancelBtnTextStyle: const TextStyle(color: Colors.red),
                        onCancelBtnTap: () {
                          Navigator.of(context).pop;
                        },
                        onConfirmBtnTap: () async {
                          final provider = context.read<ChatDisplayProvider>();
                          provider.setOpenMessage(false);
                          final provider1 = context.read<InitProvider>();
                          provider1.setMenuIndex(0);
                          await _auth.signOutAnon();
                          deleteAllData();
                          // ignore: use_build_context_synchronously
                          GoRouter.of(context).go('/');
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.logout_outlined,
                      size: 30,
                      color: kColorPrimary,
                    ),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 15,
                        color: kColorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: const Color.fromARGB(255, 59, 59, 59),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Terms of Service',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: kColorSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (_) => const TermPage(
                                          pdfurl: '',
                                        ));
                              }),
                        const TextSpan(text: ' / '),
                        TextSpan(
                            text: 'Privacy Policy',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: kColorSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (_) => const TermPage(
                                          pdfurl: '',
                                        ));
                              }),
                        const TextSpan(text: '\nCopyrights @ 2023 Work4uTutor'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void deleteAllData() async {
    final box = await Hive.openBox('userID');
    await box.clear();
  }

  _buildNotif(int data) {
    return (data == null || data <= 0)
        ? Container()
        : Container(
            width: 30,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: kSecondarybuttonblue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              (data >= 100) ? "99+" : "$data",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          );
  }
}
