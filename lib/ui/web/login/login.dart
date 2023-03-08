import 'package:flutter/material.dart';
import 'package:wokr4ututor/components/nav_bar.dart';
import 'package:wokr4ututor/ui/auth/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final AuthService _auth = AuthService();
final formKey = GlobalKey<FormState>();

String userPassword = '';
String userEmail = '';

String error = '';
bool obscure = true;

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work4ututor',
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          // appBar: null,
          body: Center(
        child: Column(
          children: const <Widget>[
            LogScreen(),
            // It will cover 1/3 of free spaces
          ],
        ),
      )),
    );
  }
}

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/Student (12).png"),
        fit: BoxFit.cover,
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const <Widget>[
          CustomAppBar(),
          SigniN(),
          // It will cover 1/3 of free spaces
        ],
      ),
    );
  }
}

class SigniN extends StatefulWidget {
  const SigniN({super.key});

  @override
  State<SigniN> createState() => _SigniNState();
}

class _SigniNState extends State<SigniN> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(200, 50, 200, 100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(1, 118, 132, 1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Image.asset(
                'assets/images/worklogo.png',
                width: 350.0,
                height: 100.0,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Text(
                " Welcome Back!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(25, 10, 20, 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: 380,
                    height: 60,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Email',
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        userEmail = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 380,
                    height: 60,
                    child: TextFormField(
                      obscureText: obscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Password',
                        suffixIcon: const IconButton(
                          onPressed: null,
                          icon: Icon(Icons.remove_red_eye_rounded),
                        ),
                        suffixIconColor: Colors.black,
                      ),
                      validator: (val) =>
                          val!.length < 6 ? 'Enter a 6+ valid password' : null,
                      onChanged: (val) {
                        userPassword = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            FittedBox(
              // Now it just take the required spaces
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                width: 380,
                height: 70,
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(color: Colors.black),
                    backgroundColor: const Color.fromRGBO(103, 195, 208, 1),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Color.fromRGBO(1, 118, 132, 1), // your color here
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: ()  async{
                     if (formKey.currentState!.validate()){
                    dynamic result = await _auth.signinwEmailandPassword(userEmail, userPassword);
                    if(result ==  null){
                      setState(() {
                        error = 'Could not sign in w/ those credential';
                        print(error);
                      });
                    }
                   }
                  },
                  child: Text(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    'Confirm Submission',
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Text(
                "Don't have an account? Register Now",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color.fromARGB(255, 59, 59, 59),
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
