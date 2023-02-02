import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class StudentSignup extends StatefulWidget {
  const StudentSignup({Key? key}) : super(key: key);

  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
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
        image: AssetImage("assets/images/aq.jpeg"),
        fit: BoxFit.cover,
      )),
     child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
      width: 350,
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
              " Welcome!\nLearn from our expert tutors\nall over the world",
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
                children:  [
                  SizedBox(
                    width: 300,
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),),
                        hintText: 'Name',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                   SizedBox(
                    width: 300,
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),),
                        hintText: 'Surname',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                   SizedBox(
                    width: 300,
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),),
                        hintText: 'Email',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                    SizedBox(
                    width: 300,
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),),
                        hintText: 'Password',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                   SizedBox(
                    width: 300,
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),),
                        hintText: 'Confirm Password',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FittedBox(
            // Now it just take the required spaces
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              width: 320,
              height: 70,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(color: Colors.black),
                  backgroundColor: const Color.fromARGB(255, 12, 100, 82),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                onPressed: () => {
                  // Navigator.of(context).pushNamed(const SignInfo() as String),
                },
                icon:  const Icon(
                  Icons.login_rounded,
                  color: Color.fromARGB(255, 12, 100, 82),
                ),
                label:   Text(
                  style:  TextStyle(color: Colors.white, fontSize: 20,),
                  'Confirm Submission',
                ),
              ),
            ),
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