// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../data_class/inquirydetailclass.dart';
import '../../../../provider/inquirydisplay_provider.dart';
import '../../../../utils/themes.dart';

class ViewInquiry extends StatefulWidget {
  const ViewInquiry({super.key});

  @override
  State<ViewInquiry> createState() => _ViewInquiryState();
}

class _ViewInquiryState extends State<ViewInquiry> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(
        messageContent:
            "Hey Kriss, I am doing fine dude. wbu? Hey Kriss, I am doing fine dude. wbu? Hey Kriss, I am doing fine dude. wbu? Hey Kriss, I am doing fine dude. wbu? Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(
        messageContent: "Is there any thing wrong?", messageType: "sender"),
  ];
  bool select = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    final provider = context.read<InquiryDisplayProvider>();
                    provider.setOpen(false);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color:  kColorPrimary,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                const CircleAvatar(
                  backgroundColor: kColorPrimary,
                  backgroundImage: NetworkImage(
                      "<https://randomuser.me/api/portraits/men/5.jpg>"),
                  maxRadius: 20,
                  child: Icon(FontAwesomeIcons.user),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Melvin Jhon Selma",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
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
        Container(
          width: size.width - 320,
          height: size.height - 175,
          child: Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: messages.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                        alignment: (messages[index].messageType == "receiver"
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: messages[index].messageType == "receiver"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: CircleAvatar(
                                        backgroundColor: kColorPrimary,
                                        backgroundImage: NetworkImage(
                                            "<https://randomuser.me/api/portraits/men/5.jpg>"),
                                        maxRadius: 20,
                                        child: Icon(FontAwesomeIcons.user),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 0, maxWidth: 450),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      color: (messages[index].messageType ==
                                              "receiver"
                                          ? Colors.grey.shade200
                                          : kColorLight),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      messages[index].messageContent,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                width: 500,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints: const BoxConstraints(
                                          minWidth: 0, maxWidth: 450),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                        color: (messages[index].messageType ==
                                                "receiver"
                                            ? Colors.grey.shade200
                                            : kColorLight),
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        messages[index].messageContent,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Positioned(
                                      top: 0,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: CircleAvatar(
                                          backgroundColor: kColorPrimary,
                                          backgroundImage: NetworkImage(
                                              "<https://randomuser.me/api/portraits/men/5.jpg>"),
                                          maxRadius: 20,
                                          child: Icon(FontAwesomeIcons.user),
                                        ),
                                      ),
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
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: kColorPrimary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () {},
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
