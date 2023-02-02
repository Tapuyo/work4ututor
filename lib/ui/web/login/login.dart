
import 'package:flutter/material.dart';
import 'package:wokr4ututor/components/nav_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

String userPassword = '';
String userEmail = '';

String error = '';
bool obscure = true;

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      title: 'Work4ututor',
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          appBar: null,
          body: Center(
            child: Column(
              children: <Widget>[
                CustomAppBar(),
                SignUp(),
                // It will cover 1/3 of free spaces
              ],
            ),
          )),
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
        image: AssetImage("assets/images/log1.jpg"),
        fit: BoxFit.cover,
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          CustomAppBar(),
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
      width: 400,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(200, 70, 200, 100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(50, 15, 50, 10),
            child: Image.asset(
              'assets/images/NewLogo3-removebg-preview.png',
              width: 350.0,
              height: 100.0,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text(
              " Welcome Back!",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Color.fromARGB(255, 3, 63, 56),
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
                  width: 350,
                  height: 50,
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
                  width: 350,
                  height: 50,
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
              width: 350,
              height: 70,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(color: Colors.black),
                  backgroundColor: const Color.fromARGB(255, 9, 93, 116),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: () => {
                  // Navigator.of(context).pushNamed(const SignInfo() as String),
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
                    color: Color.fromARGB(255, 59, 59, 59),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
