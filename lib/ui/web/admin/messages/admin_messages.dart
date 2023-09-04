import 'package:flutter/material.dart';
import 'package:wokr4ututor/ui/web/admin/messages/admin_user_list.dart';
import 'package:wokr4ututor/ui/web/tutor/mesages/userlist.dart';

class AdminMessagePage extends StatefulWidget {
  const AdminMessagePage({super.key});

  @override
  State<AdminMessagePage> createState() => _AdminMessagePageState();
}

class _AdminMessagePageState extends State<AdminMessagePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
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
                        child: AdminUserList()),
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
