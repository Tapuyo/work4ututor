import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/data_class/chatmessageclass.dart';
import 'package:wokr4ututor/provider/chatmessagedisplay.dart';
import 'package:wokr4ututor/services/getmessages.dart';
import 'package:wokr4ututor/ui/web/tutor/mesages/viewmessage.dart';
import 'package:wokr4ututor/utils/themes.dart';

import '../calendar/tutor_schedule.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final List<Map<String, String>> users = [
    {
      'name': 'John',
      'description': 'Software Developer',
      'avatar': 'https://via.placeholder.com/150',
      'isFavorite': 'false'
    },
    {
      'name': 'Jane',
      'description': 'Graphic Designer',
      'avatar': 'https://via.placeholder.com/150',
      'isFavorite': 'false'
    },
    {
      'name': 'Alex',
      'description': 'Product Manager',
      'avatar': 'https://via.placeholder.com/150',
      'isFavorite': 'false'
    },
    {
      'name': 'Mary',
      'description': 'Data Analyst',
      'avatar': 'https://via.placeholder.com/150',
      'isFavorite': 'false'
    },
    {
      'name': 'Tom',
      'description': 'Marketing Specialist',
      'avatar': 'https://via.placeholder.com/150',
      'isFavorite': 'false'
    },
  ];

  void toggleFavorite(int index) {
    setState(() {
      users[index]['isFavorite'] =
          users[index]['isFavorite'] == 'true' ? 'false' : 'true';
    });
  }

  void deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  List<Map<String, dynamic>> filteredUsers = [];

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users
          .where((user) =>
              user['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  final _userinfo = Hive.box('userID');
  List<Map<String, dynamic>> _items = [];
  _refreshItems() {
    final data = _userinfo.keys.map((key) {
      final item = _userinfo.get(key);
      return {
        "key": key,
        "userID": item["userID"],
        "role": item["role"],
        "userStatus": item["userStatus"]
      };
    }).toList();
    setState(() {
      _items = data.toList();
      debugPrint(_items.length.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  String chatID = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bool openChat =
        context.select((ChatDisplayProvider p) => p.openMessage);
    final messagelist = Provider.of<List<ChatMessage>>(context);
    if (messagelist.isNotEmpty) {
      setState(() {
        messagelist.sort((a, b) => b.messageDate.compareTo(a.messageDate));
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          padding: EdgeInsets.zero,
          hoverColor: kCalendarColorFB,
          onPressed: () {
            print('Write a new message');
          },
          icon: const Icon(Icons.create_outlined),
          iconSize: 25,
          color: Colors.blue,
        ),
        title: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              alignment: Alignment.center,
              width: 250,
              child: TextField(
                decoration: const InputDecoration(
                  // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black45)),
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: 'Search users',
                ),
                onChanged: (value) {
                  setState(() {
                    filterUsers(value);
                  });
                },
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            hoverColor: kCalendarColorFB,
            color: Colors.blue,
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: size.width > 1350 ? 4 : 5,
            child: SizedBox(
              height: size.height - 130,
              child: Card(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                elevation: 2,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: MouseRegion(
                  onHover: (event) {},
                  cursor: SystemMouseCursors.click,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: messagelist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(width: .05))),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.black12,
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                          ),
                          title: Text(
                            messagelist[index].tutorID,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(messagelist[index].lastmessage,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: messagelist[index]
                                              .messageStatus
                                              .toString() ==
                                          'unread'
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    iconSize: 15,
                                    icon: Icon(
                                      messagelist[index]
                                                  .studentFav
                                                  .toString() ==
                                              'yes'
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: messagelist[index]
                                                  .studentFav
                                                  .toString() ==
                                              'yes'
                                          ? Colors.orange
                                          : null,
                                    ),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    mouseCursor:
                                        MaterialStateMouseCursor.clickable,
                                    onPressed: () {
                                      toggleFavorite(index);
                                    },
                                  ),
                                  IconButton(
                                    iconSize: 15,
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.grey,
                                    ),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    mouseCursor:
                                        MaterialStateMouseCursor.clickable,
                                    onPressed: () {
                                      deleteUser(index);
                                    },
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                          onTap: () {
                            // Navigate to user profile page
                            // Navigator.pushNamed(context, '/profile',
                            //     arguments: {'username': users[index]['name']});

                            final provider =
                                context.read<ChatDisplayProvider>();
                            provider.setOpenMessage(true);
                            setState(() {
                              updatemessagestatusInfo(
                                  messagelist[index].chatID);
                              chatID = messagelist[index].chatID;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            // height: MediaQuery.of(context).size.height,
            // child: const VerticalDivider(),
            width: 5,
          ),
          Flexible(
              flex: 10,
              child: SizedBox(
                child: openChat != true
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.wechat_rounded,
                              color: Colors.blue,
                              size: 75,
                            ),
                            const Text(
                              'Select a conversation to display messages',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const Text(
                              'or',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  print('New message');
                                },
                                child: const Text(
                                  'Start a new conversation',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blue),
                                ))
                          ],
                        ),
                      )
                    : ViewMessage(
                        uID: _items.first['userID'].toString(),
                        chatID: chatID,
                      ),
              )),
        ],
      ),
    );
  }
}
