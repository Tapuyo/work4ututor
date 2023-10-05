import 'package:flutter/material.dart';

class ViewFile extends StatefulWidget {
  final String? imageURL;
  const ViewFile({super.key, required this.imageURL});

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
                left: 10.0,
                right: 10,
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
                          image: DecorationImage(
                              image: NetworkImage(
                                widget.imageURL.toString(),
                              ),
                              fit: BoxFit.fill)),
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
          child: const Text('Close'),
        ),
      ],
    );
  }
}
