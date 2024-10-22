import 'package:flutter/material.dart';
import '../../../../shared_components/responsive_builder.dart';
import '../../../../utils/themes.dart';
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
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: ResponsiveBuilder.isDesktop(context)
                  ? size.width - 270 : size.width,
      child: Column(
        children: <Widget>[
          Card(
                      color: Colors.white,

            margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
            elevation: 4,
            child: Container(
              height: 50,
              width: ResponsiveBuilder.isDesktop(context)
                  ? size.width - 300
                  : size.width - 30,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient:const LinearGradient(
                  begin:  Alignment(-0.1, 0),
                  end: Alignment.centerRight,
                  colors: secondaryHeadercolors,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Messages",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                flex: size.width > 1350 ? 4 : 5,
                child: SizedBox(
                  height: size.height - 138,
                  child: Card(
                              color: Colors.white,

                    margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: MouseRegion(
                        onHover: (event) {},
                        cursor: SystemMouseCursors.click,
                        child: const UserList()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
