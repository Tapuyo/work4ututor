import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ViewFile extends StatefulWidget {
  const ViewFile({super.key});

  @override
  State<ViewFile> createState() => _ViewFileState();
}

class _ViewFileState extends State<ViewFile> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Container(
        height: 500,
        width: 700,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0, right: 10,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 500,
                      width: 680,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                          image: const DecorationImage(
                              image: AssetImage('assets/images/5815489.jpg'),
                              fit: BoxFit.cover)),
                    )),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
