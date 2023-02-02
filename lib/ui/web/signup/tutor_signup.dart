// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:wokr4ututor/ui/web/signup/tutor_information_signup.dart';

class TutorSignup extends StatefulWidget {
  const TutorSignup({Key? key}) : super(key: key);

  @override
  State<TutorSignup> createState() => _TutorSignupState();
}

final formKey = GlobalKey<FormState>();
//textinputs
String tName = '';
String tLastName = '';
String tEmail = '';
String tPassword = '';
String tConPassword = '';

String error = '';
bool obscure = true;

class _TutorSignupState extends State<TutorSignup> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      title: 'Work4ututor',
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CoverScreen(),
    );
  }
}

class CoverScreen extends StatelessWidget {
  const CoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/12.jpg"),
        fit: BoxFit.cover,
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const <Widget>[
          SignUp(),
          // It will cover 1/3 of free spaces
        ],
      ),
    );
  }
}

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.fromLTRB(200, 120, 200, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text(
              " Make yourself\navailable to students\nall over the world",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(25, 10, 20, 10),
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    width: 320,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Name',
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your Name' : null,
                      onChanged: (val) {
                        tName = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: 320,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Surname',
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your Surname' : null,
                      onChanged: (val) {
                        tLastName = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: 320,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Email',
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        tEmail = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: 320,
                    height: 40,
                    child: TextFormField(
                      obscureText: obscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: null,
                          icon: Icon(Icons.remove_red_eye_rounded),
                        ),
                        suffixIconColor: Colors.black,
                      ),
                      validator: (val) =>
                          val!.length < 6 ? 'Enter a 6+ valid password' : null,
                      onChanged: (val) {
                        tName = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: 320,
                    height: 40,
                    child: TextFormField(
                      obscureText: obscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Confirm Password',
                        suffixIcon: IconButton(
                          onPressed: null,
                          icon: Icon(Icons.remove_red_eye_rounded),
                        ),
                        suffixIconColor: Colors.black,
                      ),
                      validator: (val) =>
                          val != tPassword ? 'Password not Match' : null,
                      onChanged: (val) {
                        tName = val;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            width: 320,
            height: 70,
            child: TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(color: Colors.black),
                backgroundColor: const Color.fromARGB(255, 12, 100, 82),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              onPressed: () {
                print(tName);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const TutorInfo()),
                // );
                FirebaseFirestore.instance.collection('user').add(
                    {'email': tEmail, 'password': tPassword, 'role': 'Tutor'});
              },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),

            //            TextButton.icon(
            //             style: TextButton.styleFrom(
            //               textStyle: const TextStyle(color: Colors.black),
            //               backgroundColor: const Color.fromARGB(255, 12, 100, 82),
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(24.0),
            //               ),
            //             ),
            //             onPressed: () => {
            //               Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const TutorInfo()),
            // ),
            //             },
            //             icon:  const Icon(
            //               Icons.login_rounded,
            //               color: Color.fromARGB(255, 12, 100, 82),
            //             ),
            //             label:   Text(
            //               style:  TextStyle(color: Colors.white, fontSize: 20,),
            //               'Confirm Submission',
            //             ),
            //           ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Text(
              "By signing up, you agree to Work4uTutor\nTerms of Service and Privacy Policy",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Color.fromARGB(255, 59, 59, 59),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
// void showDialogWithFields() {
//   showDialog(
//     context: context,
//     builder: (_) {
//       var emailController = TextEditingController();
//       var messageController = TextEditingController();
//       return AlertDialog(
//         title: Text('Contact Us'),
//         content: ListView(
//           shrinkWrap: true,
//           children: [
//             TextFormField(
//               controller: emailController,
//               decoration: InputDecoration(hintText: 'Email'),
//             ),
//             TextFormField(
//               controller: messageController,
//               decoration: InputDecoration(hintText: 'Message'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               // Send them to your email maybe?
//               var email = emailController.text;
//               var message = messageController.text;
//               Navigator.pop(context);
//             },
//             child: Text('Send'),
//           ),
//         ],
//       );
//     },
//   );
// }