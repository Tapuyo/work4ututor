// import 'dart:typed_data';
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:dio/dio.dart';
// import 'package:printing/printing.dart';

// class TermPage extends StatefulWidget {
//   const TermPage({super.key});

//   @override
//   State<TermPage> createState() => _TermPageState();
// }

// class _TermPageState extends State<TermPage> {
//   String murl =
//       'https://drinklink.ae/oathygow/2020/12/Terms-of-Service-DrinkLink.pdf';
//   @override
//   Widget build(BuildContext context) {
//    return Scaffold(
//       appBar:  AppBar(
//         backgroundColor: Color(0xFF2b2b61),
//         title:  Text(
//           "Terms of Service",
//           style: TextStyle(fontSize: 20, color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             // Navigator.pushReplacement(
//             //   context,
//             //   MaterialPageRoute(builder: (context) => HomePage()),
//             // );
//           },
//         ),
//       ),
//       body: FutureBuilder<Uint8List>(
//         future: _fetchPdfContent(murl),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return PdfPreview(
//               allowPrinting: false,
//               allowSharing: false,
//               canChangePageFormat: false,
//               initialPageFormat:
//                   PdfPageFormat(100 * PdfPageFormat.mm, 120 * PdfPageFormat.mm),
//               build: (format) => snapshot.data,
//             );
//           }
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       )
//     );
//   }
// }
// Future<Uint8List> _fetchPdfContent(final String url) async {
//     try {
//       final Response<List<int>> response = await Dio().get<List<int>>(
//         url,
//         options: Options(responseType: ResponseType.bytes),
//       );
//       return Uint8List.fromList(response);
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }