// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/ui/web/tutor/mesages/declineoffer.dart';
import 'package:work4ututor/ui/web/tutor/mesages/offerinquiry.dart';
import 'package:work4ututor/ui/web/tutor/mesages/refusedinquiry.dart';

import '../../../../data_class/chatmessageclass.dart';
import '../../../../data_class/studentinfoclass.dart';
import '../../../../data_class/subject_class.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../provider/chatmessagedisplay.dart';
import '../../../../services/addtocart.dart';
import '../../../../services/getmessages.dart';
import '../../../../services/getstudentinfo.dart';
import '../../../../shared_components/responsive_builder.dart';
import '../../../../utils/themes.dart';

class ViewMessage extends StatefulWidget {
  final String uID;
  final String chatID;
  final ChatMessage? convo;
  const ViewMessage(
      {Key? key, required this.uID, required this.chatID, required this.convo})
      : super(key: key);

  @override
  State<ViewMessage> createState() => _ViewMessageState();
}

class _ViewMessageState extends State<ViewMessage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<StudentInfoClass>>.value(
          value: StudentInfoData(uid: widget.convo!.studentID).getstudentinfo,
          catchError: (context, error) {
            return [];
          },
          initialData: const [],
        ),
        StreamProvider<List<MessageContent>>.value(
          value:
              GetMessageConversation(chatID: widget.chatID, userID: widget.uID)
                  .getmessage,
          catchError: (context, error) {
            return [];
          },
          initialData: const [],
        )
      ],
      child: ViewMessageBody(
        userID: widget.uID,
        chatID: widget.chatID,
        convo: widget.convo,
      ),
    );
  }
}

class ViewMessageBody extends StatefulWidget {
  final String userID;
  final String chatID;
  final ChatMessage? convo;
  const ViewMessageBody(
      {super.key,
      required this.userID,
      required this.chatID,
      required this.convo});

  @override
  State<ViewMessageBody> createState() => _ViewMessageBodyState();
}

class _ViewMessageBodyState extends State<ViewMessageBody> {
  TextEditingController messageContent = TextEditingController();
  ScrollController scrollController = ScrollController();

  bool select = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final subjectlist = Provider.of<List<Subjects>>(context);

    TutorInformation tutorsList =
        Provider.of<List<TutorInformation>>(context).firstWhere(
      (tutor) => tutor.userId == widget.convo!.tutorID,
    );
    final studentinfodata = Provider.of<List<StudentInfoClass>>(context);
    final messagedata = Provider.of<List<MessageContent>>(context);
    if (messagedata.isNotEmpty) {
      setState(() {
        messagedata.sort((a, b) => a.dateSent.compareTo(b.dateSent));
      });
    }
    if (studentinfodata.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
      WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll to the bottom after the ListView is built
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });

    return Column(
      children: [
        SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16, top: 5, bottom: 5),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    final provider = context.read<ChatDisplayProvider>();
                    provider.setOpenMessage(false);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: kColorPrimary,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black12,
                  backgroundImage: tutorsList.userId == widget.userID
                      ? NetworkImage(studentinfodata.first.profilelink)
                      : NetworkImage(tutorsList.imageID),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        tutorsList.userId == widget.userID
                            ? '${studentinfodata.first.studentFirstname} ${studentinfodata.first.studentLastname}'
                            : '${tutorsList.firstName} ${tutorsList.lastname}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        tutorsList.userId == widget.userID
                            ? studentinfodata.first.studentID
                            : tutorsList.tutorID,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // const Icon(
                //   Icons.settings,
                //   color: Colors.black54,
                // ),
              ],
            ),
          ),
        ),
        const SizedBox(
          child: Divider(
            height: 1,
            thickness: 2,
          ),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              ListView.builder(
                controller: scrollController,
                itemCount: messagedata.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 70),
                itemBuilder: (context, index) {
                  Subjects? subjectid;
                  if (messagedata[index].subjectID != '') {
                    subjectid = subjectlist.firstWhere(
                      (element) =>
                          element.subjectId == messagedata[index].subjectID,
                    );
                    // Use subjectid here
                  }

                  return Container(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                        alignment: (messagedata[index].userID == widget.userID
                            ? Alignment.topRight
                            : Alignment.topLeft),
                        child: messagedata[index].userID != widget.userID
                            ? messagedata[index].userID == widget.convo!.tutorID
                                ? messagedata[index].type == 'offer'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: CircleAvatar(
                                                radius: 10,
                                                backgroundColor: Colors.black12,
                                                backgroundImage:
                                                    tutorsList.userId ==
                                                            widget.userID
                                                        ? NetworkImage(
                                                            studentinfodata
                                                                .first
                                                                .profilelink)
                                                        : NetworkImage(
                                                            tutorsList.imageID),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                    minWidth: 0,
                                                    maxWidth: ResponsiveBuilder
                                                                .isDesktop(
                                                                    context) ||
                                                            size.width > 800
                                                        ? 450
                                                        : size.width <= 800 &&
                                                                size.width >=
                                                                    450
                                                            ? 250
                                                            : size.width <
                                                                        450 &&
                                                                    size.width >=
                                                                        300
                                                                ? 150
                                                                : 75),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight: Radius
                                                              .circular(20),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20)),
                                                  color: (messagedata[index]
                                                              .userID ==
                                                          widget.userID
                                                      ? kColorLight
                                                      : Colors.grey.shade200),
                                                ),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        2, 2, 2, 10),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          2, 2, 2, 10),
                                                      decoration: const BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Color.fromRGBO(
                                                              181,
                                                              226,
                                                              250,
                                                              1)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: TextSpan(
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headlineSmall
                                                                ?.copyWith(
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      59,
                                                                      59,
                                                                      59),
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text:
                                                                      '${tutorsList.firstName} ${tutorsList.lastname} offer',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                  )),
                                                              TextSpan(
                                                                  text:
                                                                      ' \$${messagedata[index].classPrice} for ${subjectid!.subjectName}',
                                                                  style: Theme
                                                                          .of(
                                                                              context)
                                                                      .textTheme
                                                                      .headlineSmall
                                                                      ?.copyWith(
                                                                          color:
                                                                              kColorLight,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontStyle: FontStyle
                                                                              .italic),
                                                                  recognizer:
                                                                      TapGestureRecognizer()
                                                                        ..onTap =
                                                                            () {}),
                                                              const TextSpan(
                                                                  text:
                                                                      ' subject with'),
                                                              TextSpan(
                                                                text:
                                                                    ' ${messagedata[index].noofclasses} ',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headlineSmall
                                                                    ?.copyWith(
                                                                        color:
                                                                            kColorLight,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontStyle:
                                                                            FontStyle.italic),
                                                              ),
                                                              const TextSpan(
                                                                  text:
                                                                      'classes.'),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      messagedata[index]
                                                          .messageContent,
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: widget.userID ==
                                                    widget.convo!.studentID,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        showDialog<DateTime>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return DeclineInquiry(
                                                              messageinfo:
                                                                  messagedata[
                                                                      index],
                                                              currentID:
                                                                  widget.userID,
                                                            );
                                                          },
                                                        ).then((selectedDate) {
                                                          if (selectedDate !=
                                                              null) {
                                                            // Do something with the selected date
                                                          }
                                                        });
                                                      },
                                                      child: const Text(
                                                        'Decline',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width:
                                                            16.0), // Add some spacing between the buttons
                                                    TextButton(
                                                      onPressed: () async {
                                                        bool result =
                                                            await addtoCart(
                                                                widget.convo!
                                                                    .studentID,
                                                                messagedata[
                                                                        index]
                                                                    .noofclasses,
                                                                widget.convo!
                                                                    .tutorID,
                                                                messagedata[
                                                                        index]
                                                                    .subjectID,
                                                                messagedata[
                                                                        index]
                                                                    .classPrice);
                                                        if (result == true) {
                                                          setState(() {
                                                            CoolAlert.show(
                                                              context: context,
                                                              width: 200,
                                                              type:
                                                                  CoolAlertType
                                                                      .success,
                                                              title: 'Success!',
                                                              text:
                                                                  'Class added to cart successfully.',
                                                              autoCloseDuration:
                                                                  const Duration(
                                                                      seconds:
                                                                          3),
                                                            );
                                                          });
                                                        } else {
                                                          CoolAlert.show(
                                                            context: context,
                                                            width: 200,
                                                            type: CoolAlertType
                                                                .warning,
                                                            title: 'Oops...',
                                                            text:
                                                                'Error adding, try again.',
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        'Add Cart',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[600]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : messagedata[index].type == 'inquiry'
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Colors.black12,
                                                    backgroundImage: tutorsList
                                                                .userId ==
                                                            widget.userID
                                                        ? NetworkImage(
                                                            studentinfodata
                                                                .first
                                                                .profilelink)
                                                        : NetworkImage(
                                                            tutorsList.imageID),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        minWidth: 0,
                                                        maxWidth: ResponsiveBuilder
                                                                    .isDesktop(
                                                                        context) ||
                                                                size.width > 800
                                                            ? 450
                                                            : size.width <=
                                                                        800 &&
                                                                    size.width >=
                                                                        450
                                                                ? 250
                                                                : size.width <
                                                                            450 &&
                                                                        size.width >=
                                                                            300
                                                                    ? 150
                                                                    : 75),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                      color: (messagedata[index]
                                                                  .userID ==
                                                              widget.userID
                                                          ? kColorLight
                                                          : Colors
                                                              .grey.shade200),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .fromLTRB(2, 2, 2, 10),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  2, 2, 2, 10),
                                                          decoration: const BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10)),
                                                              color: Color
                                                                  .fromRGBO(
                                                                      181,
                                                                      226,
                                                                      250,
                                                                      1)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              text: TextSpan(
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headlineSmall
                                                                    ?.copyWith(
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          59,
                                                                          59,
                                                                          59),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                      text:
                                                                          '${tutorsList.firstName} ${tutorsList.lastname}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                      )),
                                                                  TextSpan(
                                                                      text:
                                                                          ' \$${messagedata[index].classPrice} for ${subjectid!.subjectName}',
                                                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                          color:
                                                                              kColorLight,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontStyle: FontStyle
                                                                              .italic),
                                                                      recognizer: TapGestureRecognizer()
                                                                        ..onTap =
                                                                            () {}),
                                                                  const TextSpan(
                                                                      text:
                                                                          ' subject with'),
                                                                  TextSpan(
                                                                    text:
                                                                        ' ${messagedata[index].noofclasses} ',
                                                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                        color:
                                                                            kColorLight,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontStyle:
                                                                            FontStyle.italic),
                                                                  ),
                                                                  const TextSpan(
                                                                      text:
                                                                          'classes.'),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          messagedata[index]
                                                              .messageContent,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: widget.userID ==
                                                        widget.convo!.tutorID,
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              showDialog<
                                                                  DateTime>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return RefusedInquiry(
                                                                    messageinfo:
                                                                        messagedata[
                                                                            index],
                                                                    currentID:
                                                                        widget
                                                                            .userID,
                                                                  );
                                                                },
                                                              ).then(
                                                                  (selectedDate) {
                                                                if (selectedDate !=
                                                                    null) {
                                                                  // Do something with the selected date
                                                                }
                                                              });
                                                            },
                                                            child: const Text(
                                                              'REFUSE',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width:
                                                                  16.0), // Add some spacing between the buttons
                                                          TextButton(
                                                            onPressed: () {
                                                              showDialog<
                                                                  DateTime>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return OfferInquiry(
                                                                    messageinfo:
                                                                        messagedata[
                                                                            index],
                                                                    currentID:
                                                                        widget
                                                                            .userID,
                                                                  );
                                                                },
                                                              ).then(
                                                                  (selectedDate) {
                                                                if (selectedDate !=
                                                                    null) {
                                                                  // Do something with the selected date
                                                                }
                                                              });
                                                            },
                                                            child: Text(
                                                              'OFFER',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600]),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : messagedata[index].type ==
                                                'declinedoffer'
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: CircleAvatar(
                                                        radius: 10,
                                                        backgroundColor:
                                                            Colors.black12,
                                                        backgroundImage: tutorsList
                                                                    .userId ==
                                                                widget.userID
                                                            ? NetworkImage(
                                                                studentinfodata
                                                                    .first
                                                                    .profilelink)
                                                            : NetworkImage(
                                                                tutorsList
                                                                    .imageID),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                minWidth: 0,
                                                                maxWidth: ResponsiveBuilder.isDesktop(
                                                                            context) ||
                                                                        size.width >
                                                                            800
                                                                    ? 450
                                                                    : size.width <=
                                                                                800 &&
                                                                            size.width >=
                                                                                450
                                                                        ? 250
                                                                        : size.width < 450 &&
                                                                                size.width >= 300
                                                                            ? 150
                                                                            : 75),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius: const BorderRadius
                                                                  .only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          color: (messagedata[
                                                                          index]
                                                                      .userID !=
                                                                  widget.userID
                                                              ? Colors
                                                                  .red.shade200
                                                              : Colors.grey
                                                                  .shade200),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                2, 2, 2, 10),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      2,
                                                                      2,
                                                                      2,
                                                                      10),
                                                              decoration: const BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              10)),
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          181,
                                                                          226,
                                                                          250,
                                                                          1)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child: RichText(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  text:
                                                                      TextSpan(
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headlineSmall
                                                                        ?.copyWith(
                                                                          color: const Color.fromARGB(
                                                                              255,
                                                                              59,
                                                                              59,
                                                                              59),
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                          text:
                                                                              '${tutorsList.firstName} ${tutorsList.lastname}',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                          )),
                                                                      TextSpan(
                                                                          text:
                                                                              ' \$${messagedata[index].classPrice} for ${subjectid!.subjectName}',
                                                                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                              color: kColorLight,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FontStyle.italic),
                                                                          recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                      const TextSpan(
                                                                          text:
                                                                              ' subject with'),
                                                                      TextSpan(
                                                                        text:
                                                                            ' ${messagedata[index].noofclasses} ',
                                                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                            color:
                                                                                kColorLight,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontStyle: FontStyle.italic),
                                                                      ),
                                                                      const TextSpan(
                                                                          text:
                                                                              'classes.'),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              messagedata[index]
                                                                  .messageContent,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            widget.userID ==
                                                                widget.convo!
                                                                    .tutorID,
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  showDialog<
                                                                      DateTime>(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return RefusedInquiry(
                                                                        messageinfo:
                                                                            messagedata[index],
                                                                        currentID:
                                                                            widget.userID,
                                                                      );
                                                                    },
                                                                  ).then(
                                                                      (selectedDate) {
                                                                    if (selectedDate !=
                                                                        null) {
                                                                      // Do something with the selected date
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'REFUSE',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width:
                                                                      16.0), // Add some spacing between the buttons
                                                              TextButton(
                                                                onPressed: () {
                                                                  showDialog<
                                                                      DateTime>(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return OfferInquiry(
                                                                        messageinfo:
                                                                            messagedata[index],
                                                                        currentID:
                                                                            widget.userID,
                                                                      );
                                                                    },
                                                                  ).then(
                                                                      (selectedDate) {
                                                                    if (selectedDate !=
                                                                        null) {
                                                                      // Do something with the selected date
                                                                    }
                                                                  });
                                                                },
                                                                child: Text(
                                                                  'OFFER',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600]),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : messagedata[index].type ==
                                                    'declinedinquiry'
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                Colors.black12,
                                                            backgroundImage: tutorsList
                                                                        .userId ==
                                                                    widget
                                                                        .userID
                                                                ? NetworkImage(
                                                                    studentinfodata
                                                                        .first
                                                                        .profilelink)
                                                                : NetworkImage(
                                                                    tutorsList
                                                                        .imageID),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            constraints: BoxConstraints(
                                                                minWidth: 0,
                                                                maxWidth: ResponsiveBuilder.isDesktop(context) || size.width > 800
                                                                    ? 450
                                                                    : size.width <= 800 && size.width >= 450
                                                                        ? 250
                                                                        : size.width < 450 && size.width >= 300
                                                                            ? 150
                                                                            : 75),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: const BorderRadius
                                                                      .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          20)),
                                                              color: (messagedata[
                                                                              index]
                                                                          .userID !=
                                                                      widget
                                                                          .userID
                                                                  ? Colors.red
                                                                      .shade200
                                                                  : Colors.grey
                                                                      .shade200),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    2,
                                                                    2,
                                                                    2,
                                                                    10),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          2,
                                                                          2,
                                                                          2,
                                                                          10),
                                                                  decoration: const BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              10),
                                                                          topRight: Radius.circular(
                                                                              20),
                                                                          bottomLeft: Radius.circular(
                                                                              10),
                                                                          bottomRight: Radius.circular(
                                                                              10)),
                                                                      color: Color.fromRGBO(
                                                                          181,
                                                                          226,
                                                                          250,
                                                                          1)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    child:
                                                                        RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      text:
                                                                          TextSpan(
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineSmall
                                                                            ?.copyWith(
                                                                              color: const Color.fromARGB(255, 59, 59, 59),
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                        children: <
                                                                            TextSpan>[
                                                                          TextSpan(
                                                                              text: '${tutorsList.firstName} ${tutorsList.lastname} refuse ',
                                                                              style: const TextStyle(
                                                                                fontSize: 15,
                                                                              )),
                                                                          TextSpan(
                                                                              text: ' inquiry for ${subjectid!.subjectName}',
                                                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kColorLight, fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                                                              recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                          const TextSpan(
                                                                              text: ' subject with'),
                                                                          TextSpan(
                                                                            text:
                                                                                ' ${messagedata[index].noofclasses} ',
                                                                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                                color: kColorLight,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FontStyle.italic),
                                                                          ),
                                                                          const TextSpan(
                                                                              text: 'classes.'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  messagedata[
                                                                          index]
                                                                      .messageContent,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                Colors.black12,
                                                            backgroundImage: tutorsList
                                                                        .userId ==
                                                                    widget
                                                                        .userID
                                                                ? NetworkImage(
                                                                    studentinfodata
                                                                        .first
                                                                        .profilelink)
                                                                : NetworkImage(
                                                                    tutorsList
                                                                        .imageID),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                minWidth: 0,
                                                                maxWidth: ResponsiveBuilder.isDesktop(
                                                                            context) ||
                                                                        size.width >
                                                                            800
                                                                    ? 450
                                                                    : size.width <=
                                                                                800 &&
                                                                            size.width >=
                                                                                450
                                                                        ? 250
                                                                        : size.width < 450 &&
                                                                                size.width >= 300
                                                                            ? 150
                                                                            : 75),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius: const BorderRadius
                                                                  .only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          color: (messagedata[
                                                                          index]
                                                                      .userID ==
                                                                  widget.userID
                                                              ? kColorLight
                                                              : Colors.grey
                                                                  .shade200),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Text(
                                                          messagedata[index]
                                                              .messageContent,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                : messagedata[index].type == 'offer'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: CircleAvatar(
                                                radius: 10,
                                                backgroundColor: Colors.black12,
                                                backgroundImage:
                                                    tutorsList.userId ==
                                                            widget.userID
                                                        ? NetworkImage(
                                                            studentinfodata
                                                                .first
                                                                .profilelink)
                                                        : NetworkImage(
                                                            tutorsList.imageID),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                    minWidth: 0,
                                                    maxWidth: ResponsiveBuilder
                                                                .isDesktop(
                                                                    context) ||
                                                            size.width > 800
                                                        ? 450
                                                        : size.width <= 800 &&
                                                                size.width >=
                                                                    450
                                                            ? 250
                                                            : size.width <
                                                                        450 &&
                                                                    size.width >=
                                                                        300
                                                                ? 150
                                                                : 75),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight: Radius
                                                              .circular(20),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20)),
                                                  color: (messagedata[index]
                                                              .userID ==
                                                          widget.userID
                                                      ? kColorLight
                                                      : Colors.grey.shade200),
                                                ),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        2, 2, 2, 10),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          2, 2, 2, 10),
                                                      decoration: const BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10)),
                                                          color: Color.fromRGBO(
                                                              181,
                                                              226,
                                                              250,
                                                              1)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: TextSpan(
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headlineSmall
                                                                ?.copyWith(
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      59,
                                                                      59,
                                                                      59),
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text:
                                                                      '${tutorsList.firstName} ${tutorsList.lastname}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                  )),
                                                              TextSpan(
                                                                  text:
                                                                      ' \$${messagedata[index].classPrice} for ${subjectid!.subjectName}',
                                                                  style: Theme
                                                                          .of(
                                                                              context)
                                                                      .textTheme
                                                                      .headlineSmall
                                                                      ?.copyWith(
                                                                          color:
                                                                              kColorLight,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontStyle: FontStyle
                                                                              .italic),
                                                                  recognizer:
                                                                      TapGestureRecognizer()
                                                                        ..onTap =
                                                                            () {}),
                                                              const TextSpan(
                                                                  text:
                                                                      ' subject with'),
                                                              TextSpan(
                                                                text:
                                                                    ' ${messagedata[index].noofclasses} ',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headlineSmall
                                                                    ?.copyWith(
                                                                        color:
                                                                            kColorLight,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontStyle:
                                                                            FontStyle.italic),
                                                              ),
                                                              const TextSpan(
                                                                  text:
                                                                      'classes.'),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      messagedata[index]
                                                          .messageContent,
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: widget.userID ==
                                                    widget.convo!.studentID,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        showDialog<DateTime>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return DeclineInquiry(
                                                              messageinfo:
                                                                  messagedata[
                                                                      index],
                                                              currentID:
                                                                  widget.userID,
                                                            );
                                                          },
                                                        ).then((selectedDate) {
                                                          if (selectedDate !=
                                                              null) {
                                                            // Do something with the selected date
                                                          }
                                                        });
                                                      },
                                                      child: const Text(
                                                        'Decline',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width:
                                                            16.0), // Add some spacing between the buttons
                                                    TextButton(
                                                      onPressed: () {
                                                        showDialog<DateTime>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return OfferInquiry(
                                                              messageinfo:
                                                                  messagedata[
                                                                      index],
                                                              currentID:
                                                                  widget.userID,
                                                            );
                                                          },
                                                        ).then((selectedDate) {
                                                          if (selectedDate !=
                                                              null) {
                                                            // Do something with the selected date
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        'Add Cart',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[600]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : messagedata[index].type == 'inquiry'
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Colors.black12,
                                                    backgroundImage: tutorsList
                                                                .userId ==
                                                            widget.userID
                                                        ? NetworkImage(
                                                            studentinfodata
                                                                .first
                                                                .profilelink)
                                                        : NetworkImage(
                                                            tutorsList.imageID),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        minWidth: 0,
                                                        maxWidth: ResponsiveBuilder
                                                                    .isDesktop(
                                                                        context) ||
                                                                size.width > 800
                                                            ? 450
                                                            : size.width <=
                                                                        800 &&
                                                                    size.width >=
                                                                        450
                                                                ? 250
                                                                : size.width <
                                                                            450 &&
                                                                        size.width >=
                                                                            300
                                                                    ? 150
                                                                    : 75),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                      color: (messagedata[index]
                                                                  .userID ==
                                                              widget.userID
                                                          ? kColorLight
                                                          : Colors
                                                              .grey.shade200),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .fromLTRB(2, 2, 2, 10),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  2, 2, 2, 10),
                                                          decoration: const BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10)),
                                                              color: Color
                                                                  .fromRGBO(
                                                                      181,
                                                                      226,
                                                                      250,
                                                                      1)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              text: TextSpan(
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headlineSmall
                                                                    ?.copyWith(
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          59,
                                                                          59,
                                                                          59),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                      text:
                                                                          '${studentinfodata.first.studentFirstname} ${studentinfodata.first.studentLastname}',
                                                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                          color:
                                                                              kColorLight,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontStyle: FontStyle
                                                                              .italic),
                                                                      recognizer: TapGestureRecognizer()
                                                                        ..onTap =
                                                                            () {}),
                                                                  const TextSpan(
                                                                      text:
                                                                          ' is inquiring for ',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                      )),
                                                                  TextSpan(
                                                                      text: subjectid!
                                                                          .subjectName,
                                                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                          color:
                                                                              kColorLight,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontStyle: FontStyle
                                                                              .italic),
                                                                      recognizer: TapGestureRecognizer()
                                                                        ..onTap =
                                                                            () {}),
                                                                  const TextSpan(
                                                                      text:
                                                                          ' subject with'),
                                                                  TextSpan(
                                                                    text:
                                                                        ' ${messagedata[index].noofclasses} ',
                                                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                        color:
                                                                            kColorLight,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontStyle:
                                                                            FontStyle.italic),
                                                                  ),
                                                                  const TextSpan(
                                                                      text:
                                                                          'classes.'),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          messagedata[index]
                                                              .messageContent,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: widget.userID ==
                                                        widget.convo!.tutorID,
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              showDialog<
                                                                  DateTime>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return RefusedInquiry(
                                                                    messageinfo:
                                                                        messagedata[
                                                                            index],
                                                                    currentID:
                                                                        widget
                                                                            .userID,
                                                                  );
                                                                },
                                                              ).then(
                                                                  (selectedDate) {
                                                                if (selectedDate !=
                                                                    null) {
                                                                  // Do something with the selected date
                                                                }
                                                              });
                                                            },
                                                            child: const Text(
                                                              'Refuse',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width:
                                                                  16.0), // Add some spacing between the buttons
                                                          TextButton(
                                                            onPressed: () {
                                                              showDialog<
                                                                  DateTime>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return OfferInquiry(
                                                                    messageinfo:
                                                                        messagedata[
                                                                            index],
                                                                    currentID:
                                                                        widget
                                                                            .userID,
                                                                  );
                                                                },
                                                              ).then(
                                                                  (selectedDate) {
                                                                if (selectedDate !=
                                                                    null) {
                                                                  // Do something with the selected date
                                                                }
                                                              });
                                                            },
                                                            child: Text(
                                                              'Offer',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600]),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : messagedata[index].type ==
                                                'declinedoffer'
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: CircleAvatar(
                                                        radius: 10,
                                                        backgroundColor:
                                                            Colors.black12,
                                                        backgroundImage: tutorsList
                                                                    .userId ==
                                                                widget.userID
                                                            ? NetworkImage(
                                                                studentinfodata
                                                                    .first
                                                                    .profilelink)
                                                            : NetworkImage(
                                                                tutorsList
                                                                    .imageID),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                minWidth: 0,
                                                                maxWidth: ResponsiveBuilder.isDesktop(
                                                                            context) ||
                                                                        size.width >
                                                                            800
                                                                    ? 450
                                                                    : size.width <=
                                                                                800 &&
                                                                            size.width >=
                                                                                450
                                                                        ? 250
                                                                        : size.width < 450 &&
                                                                                size.width >= 300
                                                                            ? 150
                                                                            : 75),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius: const BorderRadius
                                                                  .only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          color: (messagedata[
                                                                          index]
                                                                      .userID !=
                                                                  widget.userID
                                                              ? Colors
                                                                  .red.shade200
                                                              : Colors.grey
                                                                  .shade200),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                2, 2, 2, 10),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      2,
                                                                      2,
                                                                      2,
                                                                      10),
                                                              decoration: const BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              10)),
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          181,
                                                                          226,
                                                                          250,
                                                                          1)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child: RichText(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  text:
                                                                      TextSpan(
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headlineSmall
                                                                        ?.copyWith(
                                                                          color: const Color.fromARGB(
                                                                              255,
                                                                              59,
                                                                              59,
                                                                              59),
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                          text:
                                                                              '${studentinfodata.first.studentFirstname} ${studentinfodata.first.studentLastname}',
                                                                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                              color: kColorLight,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FontStyle.italic),
                                                                          recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                      const TextSpan(
                                                                          text:
                                                                              ' declined offer for ',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                          )),
                                                                      TextSpan(
                                                                          text: subjectid!
                                                                              .subjectName,
                                                                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                              color: kColorLight,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FontStyle.italic),
                                                                          recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                      const TextSpan(
                                                                          text:
                                                                              ' subject with'),
                                                                      TextSpan(
                                                                        text:
                                                                            ' ${messagedata[index].noofclasses} ',
                                                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                            color:
                                                                                kColorLight,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontStyle: FontStyle.italic),
                                                                      ),
                                                                      const TextSpan(
                                                                          text:
                                                                              'classes.'),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              messagedata[index]
                                                                  .messageContent,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : messagedata[index].type ==
                                                    'declinedinquiry'
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                Colors.black12,
                                                            backgroundImage: tutorsList
                                                                        .userId ==
                                                                    widget
                                                                        .userID
                                                                ? NetworkImage(
                                                                    studentinfodata
                                                                        .first
                                                                        .profilelink)
                                                                : NetworkImage(
                                                                    tutorsList
                                                                        .imageID),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            constraints: BoxConstraints(
                                                                minWidth: 0,
                                                                maxWidth: ResponsiveBuilder.isDesktop(context) || size.width > 800
                                                                    ? 450
                                                                    : size.width <= 800 && size.width >= 450
                                                                        ? 250
                                                                        : size.width < 450 && size.width >= 300
                                                                            ? 150
                                                                            : 75),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: const BorderRadius
                                                                      .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          20)),
                                                              color: (messagedata[
                                                                              index]
                                                                          .userID !=
                                                                      widget
                                                                          .userID
                                                                  ? Colors.red
                                                                      .shade200
                                                                  : Colors.grey
                                                                      .shade200),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    2,
                                                                    2,
                                                                    2,
                                                                    10),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          2,
                                                                          2,
                                                                          2,
                                                                          10),
                                                                  decoration: const BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              10),
                                                                          topRight: Radius.circular(
                                                                              20),
                                                                          bottomLeft: Radius.circular(
                                                                              10),
                                                                          bottomRight: Radius.circular(
                                                                              10)),
                                                                      color: Color.fromRGBO(
                                                                          181,
                                                                          226,
                                                                          250,
                                                                          1)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    child:
                                                                        RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      text:
                                                                          TextSpan(
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineSmall
                                                                            ?.copyWith(
                                                                              color: const Color.fromARGB(255, 59, 59, 59),
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                        children: <
                                                                            TextSpan>[
                                                                          TextSpan(
                                                                              text: '${studentinfodata.first.studentFirstname} ${studentinfodata.first.studentLastname}',
                                                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kColorLight, fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                                                              recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                          const TextSpan(
                                                                              text: ' is inquiring for ',
                                                                              style: TextStyle(
                                                                                fontSize: 15,
                                                                              )),
                                                                          TextSpan(
                                                                              text: subjectid!.subjectName,
                                                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kColorLight, fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                                                              recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                          const TextSpan(
                                                                              text: ' subject with'),
                                                                          TextSpan(
                                                                            text:
                                                                                ' ${messagedata[index].noofclasses} ',
                                                                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                                color: kColorLight,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FontStyle.italic),
                                                                          ),
                                                                          const TextSpan(
                                                                              text: 'classes.'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  messagedata[
                                                                          index]
                                                                      .messageContent,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible: widget
                                                                    .userID ==
                                                                widget.convo!
                                                                    .tutorID,
                                                            child: Center(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      showDialog<
                                                                          DateTime>(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return RefusedInquiry(
                                                                            messageinfo:
                                                                                messagedata[index],
                                                                            currentID:
                                                                                widget.userID,
                                                                          );
                                                                        },
                                                                      ).then(
                                                                          (selectedDate) {
                                                                        if (selectedDate !=
                                                                            null) {
                                                                          // Do something with the selected date
                                                                        }
                                                                      });
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      'Refuse',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          16.0), // Add some spacing between the buttons
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      showDialog<
                                                                          DateTime>(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return OfferInquiry(
                                                                            messageinfo:
                                                                                messagedata[index],
                                                                            currentID:
                                                                                widget.userID,
                                                                          );
                                                                        },
                                                                      ).then(
                                                                          (selectedDate) {
                                                                        if (selectedDate !=
                                                                            null) {
                                                                          // Do something with the selected date
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                      'Offer',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey[600]),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                Colors.black12,
                                                            backgroundImage: tutorsList
                                                                        .userId ==
                                                                    widget
                                                                        .userID
                                                                ? NetworkImage(
                                                                    studentinfodata
                                                                        .first
                                                                        .profilelink)
                                                                : NetworkImage(
                                                                    tutorsList
                                                                        .imageID),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                minWidth: 0,
                                                                maxWidth: ResponsiveBuilder.isDesktop(
                                                                            context) ||
                                                                        size.width >
                                                                            800
                                                                    ? 450
                                                                    : size.width <=
                                                                                800 &&
                                                                            size.width >=
                                                                                450
                                                                        ? 250
                                                                        : size.width < 450 &&
                                                                                size.width >= 300
                                                                            ? 150
                                                                            : 75),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius: const BorderRadius
                                                                  .only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          color: (messagedata[
                                                                          index]
                                                                      .userID ==
                                                                  widget.userID
                                                              ? kColorLight
                                                              : Colors.grey
                                                                  .shade200),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Text(
                                                          messagedata[index]
                                                              .messageContent,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                            : messagedata[index].userID == widget.convo!.tutorID
                                ? messagedata[index].type == 'inquiry'
                                    ? SizedBox(
                                        width: 500,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  constraints: BoxConstraints(
                                                      minWidth: 0,
                                                      maxWidth: ResponsiveBuilder
                                                                  .isDesktop(
                                                                      context) ||
                                                              size.width > 800
                                                          ? 450
                                                          : size.width <= 800 &&
                                                                  size.width >=
                                                                      450
                                                              ? 250
                                                              : size.width <
                                                                          450 &&
                                                                      size.width >=
                                                                          300
                                                                  ? 150
                                                                  : 75),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20)),
                                                    color: (messagedata[index]
                                                                .userID ==
                                                            widget.userID
                                                        ? kColorLight
                                                        : Colors.grey.shade200),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          2, 2, 2, 10),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                2, 2, 2, 10),
                                                        decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
                                                            color:
                                                                Color.fromRGBO(
                                                                    181,
                                                                    226,
                                                                    250,
                                                                    1)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineSmall
                                                                  ?.copyWith(
                                                                    color: const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        59,
                                                                        59,
                                                                        59),
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                              children: <
                                                                  TextSpan>[
                                                                const TextSpan(
                                                                    text:
                                                                        'You are inquiring for ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                    )),
                                                                TextSpan(
                                                                    text: subjectid!
                                                                        .subjectName,
                                                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                        color:
                                                                            kColorLight,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .italic),
                                                                    recognizer:
                                                                        TapGestureRecognizer()
                                                                          ..onTap =
                                                                              () {}),
                                                                const TextSpan(
                                                                    text:
                                                                        ' subject with'),
                                                                TextSpan(
                                                                  text:
                                                                      ' ${messagedata[index].noofclasses} ',
                                                                  style: Theme
                                                                          .of(
                                                                              context)
                                                                      .textTheme
                                                                      .headlineSmall
                                                                      ?.copyWith(
                                                                          color:
                                                                              kColorLight,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontStyle:
                                                                              FontStyle.italic),
                                                                ),
                                                                const TextSpan(
                                                                    text:
                                                                        'classes.'),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        messagedata[index]
                                                            .messageContent,
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible: widget.userID ==
                                                  widget.convo!.tutorID,
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        showDialog<DateTime>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return RefusedInquiry(
                                                              messageinfo:
                                                                  messagedata[
                                                                      index],
                                                              currentID:
                                                                  widget.userID,
                                                            );
                                                          },
                                                        ).then((selectedDate) {
                                                          if (selectedDate !=
                                                              null) {
                                                            // Do something with the selected date
                                                          }
                                                        });
                                                      },
                                                      child: const Text(
                                                        'Refuse',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width:
                                                            16.0), // Add some spacing between the buttons
                                                    TextButton(
                                                      onPressed: () {
                                                        showDialog<DateTime>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return OfferInquiry(
                                                              messageinfo:
                                                                  messagedata[
                                                                      index],
                                                              currentID:
                                                                  widget.userID,
                                                            );
                                                          },
                                                        ).then((selectedDate) {
                                                          if (selectedDate !=
                                                              null) {
                                                            // Do something with the selected date
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        'Offer',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[600]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : messagedata[index].type == 'offer'
                                        ? SizedBox(
                                            width: 500,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              minWidth: 0,
                                                              maxWidth: ResponsiveBuilder
                                                                          .isDesktop(
                                                                              context) ||
                                                                      size.width >
                                                                          800
                                                                  ? 450
                                                                  : size.width <=
                                                                              800 &&
                                                                          size.width >=
                                                                              450
                                                                      ? 250
                                                                      : size.width < 450 &&
                                                                              size.width >= 300
                                                                          ? 150
                                                                          : 75),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                topLeft:
                                                                    Radius
                                                                        .circular(
                                                                            20),
                                                                bottomLeft:
                                                                    Radius
                                                                        .circular(
                                                                            20),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        20)),
                                                        color: (messagedata[
                                                                        index]
                                                                    .userID ==
                                                                widget.userID
                                                            ? kColorLight
                                                            : Colors
                                                                .grey.shade200),
                                                      ),
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          2, 2, 2, 10),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    5, 2, 5, 5),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  decoration: const BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                      color: Color.fromRGBO(
                                                                          181,
                                                                          226,
                                                                          250,
                                                                          1)),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    child:
                                                                        RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      text:
                                                                          TextSpan(
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineSmall
                                                                            ?.copyWith(
                                                                              color: const Color.fromARGB(255, 59, 59, 59),
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                        children: <
                                                                            TextSpan>[
                                                                          const TextSpan(
                                                                              text: 'You offer',
                                                                              style: TextStyle(
                                                                                fontSize: 15,
                                                                              )),
                                                                          TextSpan(
                                                                              text: ' \$${messagedata[index].classPrice}',
                                                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kColorLight, fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                                                              recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                          TextSpan(
                                                                              text: ' for',
                                                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                              recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                          TextSpan(
                                                                              text: ' ${subjectid!.subjectName}',
                                                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kColorLight, fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                                                              recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                          const TextSpan(
                                                                              text: ' subject with'),
                                                                          TextSpan(
                                                                            text:
                                                                                ' ${messagedata[index].noofclasses} ',
                                                                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                                color: kColorLight,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FontStyle.italic),
                                                                          ),
                                                                          const TextSpan(
                                                                              text: 'classes.'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Text(
                                                            messagedata[index]
                                                                .messageContent,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: widget.userID ==
                                                      widget.convo!.studentID,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          showDialog<DateTime>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return DeclineInquiry(
                                                                messageinfo:
                                                                    messagedata[
                                                                        index],
                                                                currentID:
                                                                    widget
                                                                        .userID,
                                                              );
                                                            },
                                                          ).then(
                                                              (selectedDate) {
                                                            if (selectedDate !=
                                                                null) {
                                                              // Do something with the selected date
                                                            }
                                                          });
                                                        },
                                                        child: const Text(
                                                          'Decline',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              16.0), // Add some spacing between the buttons
                                                      TextButton(
                                                        onPressed: () {
                                                          showDialog<DateTime>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return OfferInquiry(
                                                                messageinfo:
                                                                    messagedata[
                                                                        index],
                                                                currentID:
                                                                    widget
                                                                        .userID,
                                                              );
                                                            },
                                                          ).then(
                                                              (selectedDate) {
                                                            if (selectedDate !=
                                                                null) {
                                                              // Do something with the selected date
                                                            }
                                                          });
                                                        },
                                                        child: Text(
                                                          'Add Cart',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[600]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : messagedata[index].type ==
                                                'declinedoffer'
                                            ? SizedBox(
                                                width: 500,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          constraints:
                                                              BoxConstraints(
                                                                  minWidth: 0,
                                                                  maxWidth: ResponsiveBuilder.isDesktop(
                                                                              context) ||
                                                                          size.width >
                                                                              800
                                                                      ? 450
                                                                      : size.width <= 800 &&
                                                                              size.width >= 450
                                                                          ? 250
                                                                          : size.width < 450 && size.width >= 300
                                                                              ? 150
                                                                              : 75),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius: const BorderRadius
                                                                    .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        20)),
                                                            color: (messagedata[
                                                                            index]
                                                                        .userID ==
                                                                    widget
                                                                        .userID
                                                                ? Colors.red
                                                                    .shade200
                                                                : Colors.grey
                                                                    .shade200),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  2, 2, 2, 10),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        2,
                                                                        2,
                                                                        2,
                                                                        10),
                                                                decoration: const BoxDecoration(
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                20),
                                                                        bottomLeft:
                                                                            Radius.circular(
                                                                                10),
                                                                        bottomRight:
                                                                            Radius.circular(
                                                                                10),
                                                                        topRight:
                                                                            Radius.circular(
                                                                                10)),
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            181,
                                                                            226,
                                                                            250,
                                                                            1)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  child:
                                                                      RichText(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    text:
                                                                        TextSpan(
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headlineSmall
                                                                          ?.copyWith(
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                59,
                                                                                59,
                                                                                59),
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                          ),
                                                                      children: <
                                                                          TextSpan>[
                                                                        const TextSpan(
                                                                            text:
                                                                                'You declined  offer for ',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15,
                                                                            )),
                                                                        TextSpan(
                                                                            text: subjectid!
                                                                                .subjectName,
                                                                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                                color: kColorLight,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FontStyle.italic),
                                                                            recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                        const TextSpan(
                                                                            text:
                                                                                ' subject with'),
                                                                        TextSpan(
                                                                          text:
                                                                              ' ${messagedata[index].noofclasses} ',
                                                                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                              color: kColorLight,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FontStyle.italic),
                                                                        ),
                                                                        const TextSpan(
                                                                            text:
                                                                                'classes.'),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                messagedata[
                                                                        index]
                                                                    .messageContent,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Visibility(
                                                      visible: widget.userID ==
                                                          widget.convo!.tutorID,
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                showDialog<
                                                                    DateTime>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return RefusedInquiry(
                                                                      messageinfo:
                                                                          messagedata[
                                                                              index],
                                                                      currentID:
                                                                          widget
                                                                              .userID,
                                                                    );
                                                                  },
                                                                ).then(
                                                                    (selectedDate) {
                                                                  if (selectedDate !=
                                                                      null) {
                                                                    // Do something with the selected date
                                                                  }
                                                                });
                                                              },
                                                              child: const Text(
                                                                'Refuse',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width:
                                                                    16.0), // Add some spacing between the buttons
                                                            TextButton(
                                                              onPressed: () {
                                                                showDialog<
                                                                    DateTime>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return OfferInquiry(
                                                                      messageinfo:
                                                                          messagedata[
                                                                              index],
                                                                      currentID:
                                                                          widget
                                                                              .userID,
                                                                    );
                                                                  },
                                                                ).then(
                                                                    (selectedDate) {
                                                                  if (selectedDate !=
                                                                      null) {
                                                                    // Do something with the selected date
                                                                  }
                                                                });
                                                              },
                                                              child: Text(
                                                                'Offer',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600]),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : messagedata[index].type ==
                                                    'declinedinquiry'
                                                ? SizedBox(
                                                    width: 500,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              constraints: BoxConstraints(
                                                                  minWidth: 0,
                                                                  maxWidth: ResponsiveBuilder.isDesktop(context) || size.width > 800
                                                                      ? 450
                                                                      : size.width <= 800 && size.width >= 450
                                                                          ? 250
                                                                          : size.width < 450 && size.width >= 300
                                                                              ? 150
                                                                              : 75),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: const BorderRadius
                                                                        .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            20),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20)),
                                                                color: (messagedata[
                                                                                index]
                                                                            .userID ==
                                                                        widget
                                                                            .userID
                                                                    ? Colors.red
                                                                        .shade200
                                                                    : Colors
                                                                        .grey
                                                                        .shade200),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      2,
                                                                      2,
                                                                      2,
                                                                      10),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            2,
                                                                            2,
                                                                            2,
                                                                            10),
                                                                    decoration: const BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft: Radius.circular(
                                                                                20),
                                                                            bottomLeft: Radius.circular(
                                                                                10),
                                                                            bottomRight: Radius.circular(
                                                                                10),
                                                                            topRight: Radius.circular(
                                                                                10)),
                                                                        color: Color.fromRGBO(
                                                                            181,
                                                                            226,
                                                                            250,
                                                                            1)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                      child:
                                                                          RichText(
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        text:
                                                                            TextSpan(
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headlineSmall
                                                                              ?.copyWith(
                                                                                color: const Color.fromARGB(255, 59, 59, 59),
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                          children: <
                                                                              TextSpan>[
                                                                            const TextSpan(
                                                                                text: 'You refuse inquiry for ',
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                )),
                                                                            TextSpan(
                                                                                text: subjectid!.subjectName,
                                                                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kColorLight, fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                                                                recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                            const TextSpan(text: ' subject with'),
                                                                            TextSpan(
                                                                              text: ' ${messagedata[index].noofclasses} ',
                                                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kColorLight, fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                                                            ),
                                                                            const TextSpan(text: 'classes.'),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    messagedata[
                                                                            index]
                                                                        .messageContent,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(
                                                    width: 500,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              constraints: BoxConstraints(
                                                                  minWidth: 0,
                                                                  maxWidth: ResponsiveBuilder.isDesktop(context) || size.width > 800
                                                                      ? 450
                                                                      : size.width <= 800 && size.width >= 450
                                                                          ? 250
                                                                          : size.width < 450 && size.width >= 300
                                                                              ? 150
                                                                              : 75),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: const BorderRadius
                                                                        .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            20),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20)),
                                                                color: (messagedata[index]
                                                                            .userID ==
                                                                        widget
                                                                            .userID
                                                                    ? kColorLight
                                                                    : Colors
                                                                        .grey
                                                                        .shade200),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(16),
                                                              child: Text(
                                                                messagedata[
                                                                        index]
                                                                    .messageContent,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                : messagedata[index].type == 'inquiry'
                                    ? SizedBox(
                                        width: 500,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  constraints: BoxConstraints(
                                                      minWidth: 0,
                                                      maxWidth: ResponsiveBuilder
                                                                  .isDesktop(
                                                                      context) ||
                                                              size.width > 800
                                                          ? 450
                                                          : size.width <= 800 &&
                                                                  size.width >=
                                                                      450
                                                              ? 250
                                                              : size.width <
                                                                          450 &&
                                                                      size.width >=
                                                                          300
                                                                  ? 150
                                                                  : 75),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20)),
                                                    color: (messagedata[index]
                                                                .userID ==
                                                            widget.userID
                                                        ? kColorLight
                                                        : Colors.grey.shade200),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          2, 2, 2, 10),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                2, 2, 2, 10),
                                                        decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
                                                            color:
                                                                Color.fromRGBO(
                                                                    181,
                                                                    226,
                                                                    250,
                                                                    1)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineSmall
                                                                  ?.copyWith(
                                                                    color: const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        59,
                                                                        59,
                                                                        59),
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                              children: <
                                                                  TextSpan>[
                                                                const TextSpan(
                                                                    text:
                                                                        'You are inquiring for ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                    )),
                                                                TextSpan(
                                                                    text: subjectid!
                                                                        .subjectName,
                                                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                        color:
                                                                            kColorLight,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .italic),
                                                                    recognizer:
                                                                        TapGestureRecognizer()
                                                                          ..onTap =
                                                                              () {}),
                                                                const TextSpan(
                                                                    text:
                                                                        ' subject with'),
                                                                TextSpan(
                                                                  text:
                                                                      ' ${messagedata[index].noofclasses} ',
                                                                  style: Theme
                                                                          .of(
                                                                              context)
                                                                      .textTheme
                                                                      .headlineSmall
                                                                      ?.copyWith(
                                                                          color:
                                                                              kColorLight,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontStyle:
                                                                              FontStyle.italic),
                                                                ),
                                                                const TextSpan(
                                                                    text:
                                                                        'classes.'),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        messagedata[index]
                                                            .messageContent,
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible: widget.userID ==
                                                  widget.convo!.tutorID,
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        showDialog<DateTime>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return RefusedInquiry(
                                                              messageinfo:
                                                                  messagedata[
                                                                      index],
                                                              currentID:
                                                                  widget.userID,
                                                            );
                                                          },
                                                        ).then((selectedDate) {
                                                          if (selectedDate !=
                                                              null) {
                                                            // Do something with the selected date
                                                          }
                                                        });
                                                      },
                                                      child: const Text(
                                                        'Refuse',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width:
                                                            16.0), // Add some spacing between the buttons
                                                    TextButton(
                                                      onPressed: () {
                                                        showDialog<DateTime>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return OfferInquiry(
                                                              messageinfo:
                                                                  messagedata[
                                                                      index],
                                                              currentID:
                                                                  widget.userID,
                                                            );
                                                          },
                                                        ).then((selectedDate) {
                                                          if (selectedDate !=
                                                              null) {
                                                            // Do something with the selected date
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        'Offer',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[600]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : messagedata[index].type == 'offer'
                                        ? SizedBox(
                                            width: 500,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              minWidth: 0,
                                                              maxWidth: ResponsiveBuilder
                                                                          .isDesktop(
                                                                              context) ||
                                                                      size.width >
                                                                          800
                                                                  ? 450
                                                                  : size.width <=
                                                                              800 &&
                                                                          size.width >=
                                                                              450
                                                                      ? 250
                                                                      : size.width < 450 &&
                                                                              size.width >= 300
                                                                          ? 150
                                                                          : 75),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                topLeft:
                                                                    Radius
                                                                        .circular(
                                                                            20),
                                                                bottomLeft:
                                                                    Radius
                                                                        .circular(
                                                                            20),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        20)),
                                                        color: (messagedata[
                                                                        index]
                                                                    .userID ==
                                                                widget.userID
                                                            ? kColorLight
                                                            : Colors
                                                                .grey.shade200),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    5,
                                                                    2,
                                                                    5,
                                                                    10),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  decoration: const BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                      color: Color.fromRGBO(
                                                                          181,
                                                                          226,
                                                                          250,
                                                                          1)),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    child:
                                                                        RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      text:
                                                                          TextSpan(
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineSmall
                                                                            ?.copyWith(
                                                                              color: const Color.fromARGB(255, 59, 59, 59),
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                        children: <
                                                                            TextSpan>[
                                                                          const TextSpan(
                                                                              text: 'You are inquiring for ',
                                                                              style: TextStyle(
                                                                                fontSize: 15,
                                                                              )),
                                                                          TextSpan(
                                                                              text: subjectid!.subjectName,
                                                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kColorLight, fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                                                              recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                          const TextSpan(
                                                                              text: ' subject with'),
                                                                          TextSpan(
                                                                            text:
                                                                                ' ${messagedata[index].noofclasses} ',
                                                                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                                color: kColorLight,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FontStyle.italic),
                                                                          ),
                                                                          const TextSpan(
                                                                              text: 'classes.'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Text(
                                                            messagedata[index]
                                                                .messageContent,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: widget.userID ==
                                                      widget.convo!.studentID,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          showDialog<DateTime>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return RefusedInquiry(
                                                                messageinfo:
                                                                    messagedata[
                                                                        index],
                                                                currentID:
                                                                    widget
                                                                        .userID,
                                                              );
                                                            },
                                                          ).then(
                                                              (selectedDate) {
                                                            if (selectedDate !=
                                                                null) {
                                                              // Do something with the selected date
                                                            }
                                                          });
                                                        },
                                                        child: const Text(
                                                          'Decline',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              16.0), // Add some spacing between the buttons
                                                      TextButton(
                                                        onPressed: () {
                                                          showDialog<DateTime>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return OfferInquiry(
                                                                messageinfo:
                                                                    messagedata[
                                                                        index],
                                                                currentID:
                                                                    widget
                                                                        .userID,
                                                              );
                                                            },
                                                          ).then(
                                                              (selectedDate) {
                                                            if (selectedDate !=
                                                                null) {
                                                              // Do something with the selected date
                                                            }
                                                          });
                                                        },
                                                        child: Text(
                                                          'Add Cart',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[600]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : messagedata[index].type ==
                                                'declinedoffer'
                                            ? SizedBox(
                                                width: 500,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          constraints:
                                                              BoxConstraints(
                                                                  minWidth: 0,
                                                                  maxWidth: ResponsiveBuilder.isDesktop(
                                                                              context) ||
                                                                          size.width >
                                                                              800
                                                                      ? 450
                                                                      : size.width <= 800 &&
                                                                              size.width >= 450
                                                                          ? 250
                                                                          : size.width < 450 && size.width >= 300
                                                                              ? 150
                                                                              : 75),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius: const BorderRadius
                                                                    .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        20)),
                                                            color: (messagedata[
                                                                            index]
                                                                        .userID ==
                                                                    widget
                                                                        .userID
                                                                ? Colors.red
                                                                    .shade200
                                                                : Colors.grey
                                                                    .shade200),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  2, 2, 2, 10),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        2,
                                                                        2,
                                                                        2,
                                                                        10),
                                                                decoration: const BoxDecoration(
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                20),
                                                                        bottomLeft:
                                                                            Radius.circular(
                                                                                10),
                                                                        bottomRight:
                                                                            Radius.circular(
                                                                                10),
                                                                        topRight:
                                                                            Radius.circular(
                                                                                10)),
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            181,
                                                                            226,
                                                                            250,
                                                                            1)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  child:
                                                                      RichText(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    text:
                                                                        TextSpan(
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headlineSmall
                                                                          ?.copyWith(
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                59,
                                                                                59,
                                                                                59),
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                          ),
                                                                      children: <
                                                                          TextSpan>[
                                                                        const TextSpan(
                                                                            text:
                                                                                'You declined  offer for ',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15,
                                                                            )),
                                                                        TextSpan(
                                                                            text: subjectid!
                                                                                .subjectName,
                                                                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                                color: kColorLight,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FontStyle.italic),
                                                                            recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                        const TextSpan(
                                                                            text:
                                                                                ' subject with'),
                                                                        TextSpan(
                                                                          text:
                                                                              ' ${messagedata[index].noofclasses} ',
                                                                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                              color: kColorLight,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FontStyle.italic),
                                                                        ),
                                                                        const TextSpan(
                                                                            text:
                                                                                'classes.'),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                messagedata[
                                                                        index]
                                                                    .messageContent,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Visibility(
                                                      visible: widget.userID ==
                                                          widget.convo!.tutorID,
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                showDialog<
                                                                    DateTime>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return RefusedInquiry(
                                                                      messageinfo:
                                                                          messagedata[
                                                                              index],
                                                                      currentID:
                                                                          widget
                                                                              .userID,
                                                                    );
                                                                  },
                                                                ).then(
                                                                    (selectedDate) {
                                                                  if (selectedDate !=
                                                                      null) {
                                                                    // Do something with the selected date
                                                                  }
                                                                });
                                                              },
                                                              child: const Text(
                                                                'Refuse',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width:
                                                                    16.0), // Add some spacing between the buttons
                                                            TextButton(
                                                              onPressed: () {
                                                                showDialog<
                                                                    DateTime>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return OfferInquiry(
                                                                      messageinfo:
                                                                          messagedata[
                                                                              index],
                                                                      currentID:
                                                                          widget
                                                                              .userID,
                                                                    );
                                                                  },
                                                                ).then(
                                                                    (selectedDate) {
                                                                  if (selectedDate !=
                                                                      null) {
                                                                    // Do something with the selected date
                                                                  }
                                                                });
                                                              },
                                                              child: Text(
                                                                'Offer',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600]),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : messagedata[index].type ==
                                                    'declinedinquiry'
                                                ? SizedBox(
                                                    width: 500,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              constraints: BoxConstraints(
                                                                  minWidth: 0,
                                                                  maxWidth: ResponsiveBuilder.isDesktop(context) || size.width > 800
                                                                      ? 450
                                                                      : size.width <= 800 && size.width >= 450
                                                                          ? 250
                                                                          : size.width < 450 && size.width >= 300
                                                                              ? 150
                                                                              : 75),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: const BorderRadius
                                                                        .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            20),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20)),
                                                                color: (messagedata[
                                                                                index]
                                                                            .userID ==
                                                                        widget
                                                                            .userID
                                                                    ? Colors.red
                                                                        .shade200
                                                                    : Colors
                                                                        .grey
                                                                        .shade200),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      2,
                                                                      2,
                                                                      2,
                                                                      10),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            2,
                                                                            2,
                                                                            2,
                                                                            10),
                                                                    decoration: const BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft: Radius.circular(
                                                                                20),
                                                                            bottomLeft: Radius.circular(
                                                                                10),
                                                                            bottomRight: Radius.circular(
                                                                                10),
                                                                            topRight: Radius.circular(
                                                                                10)),
                                                                        color: Color.fromRGBO(
                                                                            181,
                                                                            226,
                                                                            250,
                                                                            1)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                      child:
                                                                          RichText(
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        text:
                                                                            TextSpan(
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headlineSmall
                                                                              ?.copyWith(
                                                                                color: const Color.fromARGB(255, 59, 59, 59),
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                          children: <
                                                                              TextSpan>[
                                                                            const TextSpan(
                                                                                text: 'You refuse inquiry for ',
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                )),
                                                                            TextSpan(
                                                                                text: subjectid!.subjectName,
                                                                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kColorLight, fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                                                                recognizer: TapGestureRecognizer()..onTap = () {}),
                                                                            const TextSpan(text: ' subject with'),
                                                                            TextSpan(
                                                                              text: ' ${messagedata[index].noofclasses} ',
                                                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: kColorLight, fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                                                            ),
                                                                            const TextSpan(text: 'classes.'),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    messagedata[
                                                                            index]
                                                                        .messageContent,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(
                                                    width: 500,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              constraints: BoxConstraints(
                                                                  minWidth: 0,
                                                                  maxWidth: ResponsiveBuilder.isDesktop(context) || size.width > 800
                                                                      ? 450
                                                                      : size.width <= 800 && size.width >= 450
                                                                          ? 250
                                                                          : size.width < 450 && size.width >= 300
                                                                              ? 150
                                                                              : 75),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: const BorderRadius
                                                                        .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            20),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20)),
                                                                color: (messagedata[index]
                                                                            .userID ==
                                                                        widget
                                                                            .userID
                                                                    ? kColorLight
                                                                    : Colors
                                                                        .grey
                                                                        .shade200),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(16),
                                                              child: Text(
                                                                messagedata[
                                                                        index]
                                                                    .messageContent,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                   
                      Expanded(
                        child: TextField(
                          controller: messageContent,
                          decoration: const InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                          onSubmitted: (value) {
                            sendmessage(messageContent.text, widget.chatID,
                                widget.userID);
                            scrollController.jumpTo(
                                scrollController.position.maxScrollExtent);
                            messageContent.clear();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          sendmessage(messageContent.text, widget.chatID,
                              widget.userID);
                          scrollController.jumpTo(
                              scrollController.position.maxScrollExtent);
                          messageContent.clear();
                        },
                        backgroundColor: kColorPrimary,
                        elevation: 0,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
