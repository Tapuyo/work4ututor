import 'package:flutter/material.dart';

import '../../../../utils/themes.dart';
import '../../admin/admin_sharedcomponents/header_text.dart';

class ViewFile extends StatefulWidget {
  final String? imageURL;
  const ViewFile({super.key, required this.imageURL});

  @override
  State<ViewFile> createState() => _ViewFileState();
}

class _ViewFileState extends State<ViewFile> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.1, 0),
              end: Alignment.centerRight,
              colors: secondaryHeadercolors, // Define this list of colors
            ),
          ),
        ),
        title: const HeaderText('Tutor Certificate'),
      ),
      body: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            image: DecorationImage(
                image: NetworkImage(
                  widget.imageURL.toString(),
                ),
                fit: BoxFit.fill)),
      ),
    );
  }
}
