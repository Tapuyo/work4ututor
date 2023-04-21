// import 'package:flutter/material.dart';
// import 'package:popover/popover.dart';

// class PopoverExample extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Popover Example')),
//         body: const SafeArea(
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Button(),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Button extends StatefulWidget {
//   const Button({Key? key}) : super(key: key);

//   @override
//   State<Button> createState() => _ButtonState();
// }

// class _ButtonState extends State<Button> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(5)),
//       ),
//       child: TextFormField(
//         style: const TextStyle(),
//         onTap: () {
//           showPopover(
//             context: context,
//             bodyBuilder: (context) => const ListItems(),
//             onPop: () => print('Popover was popped!'),
//             direction: PopoverDirection.left,
//             width: 200,
//             height: 400,
//             arrowHeight: 15,
//             arrowWidth: 30,
//           );
//         },
//         decoration: const InputDecoration(hintText: "Search Client"),
//       ),
//     );
//   }
// }

// class ListItems extends StatelessWidget {
//   const ListItems({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scrollbar(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: ListView(
//           padding: const EdgeInsets.all(8),
//           children: [
//             TextFormField(
//               decoration: const InputDecoration(hintText: "search"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }