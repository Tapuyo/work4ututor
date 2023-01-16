import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( TutorSignup());
  WidgetsFlutterBinding.ensureInitialized();
}

class TutorSignup extends StatelessWidget {
   TutorSignup({super.key});

 final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work4ututor',
      theme: ThemeData(
        primaryColor: Colors.grey,
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
      // decoration: const BoxDecoration(
      //     image: DecorationImage(
      //   image: AssetImage("assets/images/12.jpg"),
      //   fit: BoxFit.cover,
      // )),
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
      width: 350,
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            width: 320,
            height: 60,
            child: OutlinedButton.icon(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(color: Colors.black),
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              onPressed: () => {},
              icon: const Icon(
                Icons.g_translate_rounded,
                color: Colors.black,
              ),
              label: const Text(
                style:  TextStyle(color: Colors.black, fontSize: 18,),
                'Subscribe with Google',
              ),
            ),
          ),
          // ignore: prefer_const_constructors
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
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
                    height: 10,
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
                    height: 10,
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
                    height: 10,
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
                    height: 10,
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
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                onPressed: () => {
                  // Navigator.of(context).pushNamed(const SignInfo() as String),
                },
                icon: const Icon(
                  Icons.login_rounded,
                  color: Colors.black,
                ),
                label: const Text(
                  style:  TextStyle(color: Colors.black, fontSize: 25,),
                  'Sign Up',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}