import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/provider/chatmessagedisplay.dart';

import '../../../../data_class/chatmessageclass.dart';
import '../../../../data_class/inquirydetailclass.dart';
import '../../../../provider/inquirydisplay_provider.dart';
import '../../../../services/getmessages.dart';
import '../../../../utils/themes.dart';

class ViewMessage extends StatefulWidget {
  final String uID;
  final String chatID;
  const ViewMessage({Key? key, required this.uID, required this.chatID})
      : super(key: key);

  @override
  State<ViewMessage> createState() => _ViewMessageState();
}

class _ViewMessageState extends State<ViewMessage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamProvider<List<MessageContent>>.value(
      value: GetMessageConversation(chatID: widget.chatID, userID: widget.uID)
          .getmessage,
      catchError: (context, error) {
        print('Error occurred: $error');
        return [];
      },
      initialData: const [],
      child: ViewMessageBody(
        userID: widget.uID,
        chatID: widget.chatID,
      ),
    );
  }
}

class ViewMessageBody extends StatefulWidget {
  final String userID;
  final String chatID;
  const ViewMessageBody(
      {super.key, required this.userID, required this.chatID});

  @override
  State<ViewMessageBody> createState() => _ViewMessageBodyState();
}

ScrollController _scrollController = ScrollController();

class _ViewMessageBodyState extends State<ViewMessageBody> {
  TextEditingController messageContent = TextEditingController();

  bool select = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bool openChat =
        context.select((ChatDisplayProvider p) => p.openMessage);
    final messagedata = Provider.of<List<MessageContent>>(context);
    if (messagedata.isNotEmpty) {
      setState(() {
        messagedata.sort((a, b) => a.dateSent.compareTo(b.dateSent));
      });
    }
    return Column(
      children: [
        SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
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
                const CircleAvatar(
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
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
        Expanded(
          child: Stack(
            children: <Widget>[
              ListView.builder(
                controller: _scrollController,
                itemCount: messagedata.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 70),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                        alignment: (messagedata[index].userID == widget.userID
                            ? Alignment.topRight
                            : Alignment.topLeft),
                        child: messagedata[index].userID != widget.userID
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),
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
                                      color: (messagedata[index].userID ==
                                              widget.userID
                                          ? kColorLight
                                          : Colors.grey.shade200),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      messagedata[index].messageContent,
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
                                        color: (messagedata[index].userID ==
                                                widget.userID
                                            ? kColorLight
                                            : Colors.grey.shade200),
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        messagedata[index].messageContent,
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
                                          backgroundColor: Colors.black12,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
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
                            _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent);
                          },
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
