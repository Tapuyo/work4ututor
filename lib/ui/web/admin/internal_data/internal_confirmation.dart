// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_null_comparison

import 'package:dotted_border/dotted_border.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wokr4ututor/ui/auth/auth.dart';
import '../../../../shared_components/alphacode3.dart';
import '../../login/login.dart';

class InternalAccess extends StatefulWidget {
  const InternalAccess({super.key});

  @override
  State<InternalAccess> createState() => _InternalAccessState();
}

class _InternalAccessState extends State<InternalAccess> {
  final AuthService _auth = AuthService();
  bool isLoading = false;

  void _handleButtonPress() {
    setState(() {
      isLoading = true;
    });

    // Simulating an asynchronous operation
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(200, 30, 200, 0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    // color: const Color.fromRGBO(1, 118, 132, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    EvaIcons.lockOutline,
                    color: Colors.amberAccent[700],
                    size: 50,
                  )),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: 250,
                      height: 40,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                          hintText: 'Access ID',
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter valid access ID' : null,
                        onChanged: (val) {
                          userEmail = val;
                          final alpha3Code = getAlpha3Code(val);
                          print(alpha3Code);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 250,
                      height: 40,
                      child: TextFormField(
                        obscureText: obscure,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                            icon: Icon(Icons.remove_red_eye_rounded),
                          ),
                          suffixIconColor: Colors.black,
                        ),
                        validator: (val) => val!.length < 6
                            ? 'Enter a 6+ valid password'
                            : null,
                        onChanged: (val) {
                          userPassword = val;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                width: 150,
                height: 60,
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(color: Colors.black),
                    backgroundColor: const Color.fromRGBO(103, 195, 208, 1),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color:
                            Color.fromRGBO(1, 118, 132, 1), // your color here
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () async {
                  },
                  child: isLoading
                      ? CircularProgressIndicator() // Display progress indicator
                      : Text(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          'Access',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
