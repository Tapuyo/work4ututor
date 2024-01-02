import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data_class/studentinfoclass.dart';
import '../../../../services/getstudentinfo.dart';
import 'userlist.dart';

class MessagePage extends StatefulWidget {
  final String uID;
  const MessagePage({super.key, required this.uID});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(
      color: Colors.black45,
      width: .1,
    ),
    borderRadius: const BorderRadius.only(
      topRight: Radius.circular(5.0),
      topLeft: Radius.circular(5.0),
    ),
        ),
        width: size.width - 320,
        child: Column(
    children: <Widget>[
      Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: size.width > 1350 ? 4 : 5,
                child: SizedBox(
                  height: size.height - 75,
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: MouseRegion(
                      onHover: (event) {},
                      cursor: SystemMouseCursors.click,
                      child:const UserList()
                    ),
                  ),
                ),
              ),
            ],
          ),
    ],
        ),
      ),
    );}
}
