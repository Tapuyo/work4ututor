import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/provider/displaystarred.dart';
import 'package:work4ututor/ui/web/tutor/mesages/viewmessage.dart';

import '../../../../data_class/chatmessageclass.dart';
import '../../../../data_class/studentinfoclass.dart';
import '../../../../data_class/tutor_info_class.dart';
import '../../../../provider/chatmessagedisplay.dart';
import '../../../../services/addgetstarmessages.dart';
import '../../../../services/getmessages.dart';
import '../../../../utils/themes.dart';
import '../calendar/tutor_schedule.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final FocusNode _searchFocusNode = FocusNode();

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
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshItems();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messageNotifier =
          Provider.of<StarMessagesNotifier>(context, listen: false);
      messageNotifier.fetchPreferredTutors(_items.first['userID']);
    });
  }

  String chatID = '';
  TutorInformation getTutorInformation(
      String enteredID, List<TutorInformation> data) {
    TutorInformation selectedTutor = data.firstWhere(
      (tutor) => tutor.userId == enteredID,
    );

    return selectedTutor;
  }

  List<String> selectedTutor = [];
  List<String> getfilterTutorInformation(
    String enteredID,
    List<TutorInformation> data,
  ) {
    selectedTutor = data
        .where(
          (tutor) =>
              tutor.firstName
                  .toString()
                  .toLowerCase()
                  .contains(enteredID.toLowerCase()) ||
              tutor.middleName
                  .toString()
                  .toLowerCase()
                  .contains(enteredID.toLowerCase()) ||
              tutor.lastname
                  .toString()
                  .toLowerCase()
                  .contains(enteredID.toLowerCase()),
        )
        .map((tutor) => tutor.userId)
        .toList();

    return selectedTutor;
  }

  List<String> selectedStudent = [];
  List<String> getfilterStudentInformation(
    String enteredID,
    List<StudentInfoClass> studentdata,
  ) {
    selectedStudent = studentdata
        .where(
          (student) =>
              student.studentFirstname
                  .toString()
                  .toLowerCase()
                  .contains(enteredID.toLowerCase()) ||
              student.studentMiddlename
                  .toString()
                  .toLowerCase()
                  .contains(enteredID.toLowerCase()) ||
              student.studentLastname
                  .toString()
                  .toLowerCase()
                  .contains(enteredID.toLowerCase()),
        )
        .map((student) => student.userID)
        .toList();

    return selectedStudent;
  }

  ChatMessage? currentconvo;
  bool isSearchVisible = false;
  List<ChatMessage> messagelist = [];
  List<ChatMessage> tempmessage = [];
  List<String> starred = [];
  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TutorInformation> tutorsList =
        Provider.of<List<TutorInformation>>(context);
    final studentinfodata = Provider.of<List<StudentInfoClass>>(context);

    Size size = MediaQuery.of(context).size;
    final bool openChat =
        context.select((ChatDisplayProvider p) => p.openMessage);
    final bool openStarred =
        context.select((StarDisplayProvider p) => p.openstarred);
    tempmessage = Provider.of<List<ChatMessage>>(context);
    if (tempmessage.isNotEmpty) {
      if (openStarred) {
        setState(() {
          messagelist = tempmessage
              .where((message) =>
                  starred.contains(message.tutorID) ||
                  starred.contains(message.studentID))
              .toList();
        });
      } else if (selectedTutor.isNotEmpty) {
        setState(() {
          messagelist = tempmessage
              .where((message) => selectedTutor.contains(message.tutorID))
              .toList();
        });
      } else if (selectedStudent.isNotEmpty) {
        setState(() {
          messagelist = tempmessage.where((message) {
            bool matches = selectedStudent.contains(message.studentID);
            if (matches) {
              print(
                  "Matching message: ${message.studentID}"); // Print the matching message
            }
            return matches;
          }).toList();
        });
      } else {
        messagelist = tempmessage;
      }
      setState(() {
        messagelist.sort((a, b) => b.messageDate.compareTo(a.messageDate));
      });
    }
    if (isSearchVisible) {
      // Request focus after the widget is fully built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_searchFocusNode);
      });
    }
    return Consumer<StarMessagesNotifier>(
        builder: (context, messagenotifierdata, _) {
      starred = messagenotifierdata.starMessages;
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            padding: const EdgeInsets.all(5),
            hoverColor: kCalendarColorFB,
            onPressed: () {
              setState(() {
                isSearchVisible = !isSearchVisible;
              });
            },
            icon: const Icon(EvaIcons.searchOutline),
            iconSize: 25,
            color: Colors.orange,
          ),
          title: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isSearchVisible
                  ? Padding(
                      key: const Key(
                          'search-bar-key'), // Add a key to differentiate between widgets

                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        alignment: Alignment.center,
                        width: 250,
                        child: TextField(
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintText: 'Search users',
                          ),
                          focusNode: _searchFocusNode, // Assign the focus node

                          onChanged: (value) {
                            if (_items.first['role'] == 'tutor') {
                              setState(() {
                                getfilterStudentInformation(
                                    value, studentinfodata);
                              });
                            } else {
                              setState(() {
                                getfilterTutorInformation(value, tutorsList);
                              });
                            }
                          },
                        ),
                      ),
                    )
                  : Container(
                      key: const Key(
                          'search-bar-key'), // Add a key to differentiate between widgets
                    ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                openStarred ? Icons.star : Icons.star_border,
                color: openStarred ? Colors.orange : Colors.orange,
              ),
              onPressed: () {
                final provider = context.read<StarDisplayProvider>();
                provider.setOpenstarred(!openStarred);
              },
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
                    child: messagelist.isEmpty
                        ? const Text('No users found..')
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: messagelist.length,
                            itemBuilder: (BuildContext context, int index) {
                              TutorInformation data = getTutorInformation(
                                  messagelist[index].tutorID, tutorsList);
                              StudentInfoClass studentdata =
                                  studentinfodata.firstWhere((student) =>
                                      student.userID ==
                                      messagelist[index].studentID);
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5, top: 5),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(width: .05))),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.black12,
                                      backgroundImage:
                                          data.userId == _items.first['userID']
                                              ? NetworkImage(
                                                  studentdata.profilelink)
                                              : NetworkImage(data.imageID),
                                    ),
                                    title: Text(
                                      data.userId == _items.first['userID']
                                          ? '${studentdata.studentFirstname} ${studentdata.studentLastname}'
                                          : '${data.firstName} ${data.lastname}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // subtitle: Text(messagelist[index].lastmessage,
                                    //     style: TextStyle(
                                    //         color: Colors.black,
                                    //         fontWeight: messagelist[index]
                                    //                     .messageStatus
                                    //                     .toString() ==
                                    //                 'unread'
                                    //             ? FontWeight.bold
                                    //             : FontWeight.normal)),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              iconSize: 20,
                                              icon: Icon(
                                                starred.contains(data.userId) ||
                                                        starred.contains(
                                                            studentdata.userID)
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: Colors.orange,
                                              ),
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              mouseCursor:
                                                  MaterialStateMouseCursor
                                                      .clickable,
                                              onPressed: () {
                                                if (_items.first['role'] ==
                                                    'student') {
                                                  if (starred
                                                      .contains(data.userId)) {
                                                    starred.remove(data.userId);
                                                  } else {
                                                    starred.add(data.userId);
                                                  }
                                                } else {
                                                  if (starred.contains(
                                                      studentdata.userID)) {
                                                    starred.remove(
                                                        studentdata.userID);
                                                  } else {
                                                    starred.add(
                                                        studentdata.userID);
                                                  }
                                                }

                                                updateStarredMessagesInFirestore(
                                                    starred,
                                                    _items.first['userID']);
                                              },
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                    onTap: () {
                                      final provider =
                                          context.read<ChatDisplayProvider>();
                                      provider.setOpenMessage(true);
                                      setState(() {
                                        currentconvo = messagelist[index];
                                        updatemessagestatusInfo(
                                            messagelist[index].chatID);
                                        chatID = messagelist[index].chatID;
                                      });
                                    },
                                  ),
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
                                color: Colors.orange,
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
                                  onTap: () {},
                                  child: const Text(
                                    'Start a new conversation',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.orange),
                                  ))
                            ],
                          ),
                        )
                      : ViewMessage(
                          uID: _items.first['userID'].toString(),
                          chatID: chatID,
                          convo: currentconvo),
                )),
          ],
        ),
      );
    });
  }

  void _requestFocus() {
    if (_searchFocusNode != null && !_searchFocusNode.hasFocus) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    }
  }
}
