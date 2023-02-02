import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class TutorInfo extends StatefulWidget {
  const TutorInfo({Key? key}) : super(key: key);

  @override
  State<TutorInfo> createState() => _TutorInfoState();
}

class _TutorInfoState extends State<TutorInfo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work4ututor',
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(
          appBar: null,
          body: Center(
            child: InputInfo()
            )),
    );
  }
}

class InputInfo extends StatelessWidget {
  const InputInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 130,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 14, 113, 93),
            ),
            child: Text(
              "Subcribe with your information",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 600,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Country of Birth',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  SizedBox(
                    width: 600,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Country of Residence',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  SizedBox(
                    width: 600,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Timezone',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  SizedBox(
                    width: 600,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Laguage Spoken',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 600,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Subject you would like to teach',
                      ),
                    ),
                  ),
                   const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 600,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Subject you would like to teach',
                      ),
                    ),
                  ),
                   const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 600,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Subject you would like to teach',
                      ),
                    ),
                  ),
                   const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                        "Terms and Conditions",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: const Color.fromARGB(255, 12, 90, 85),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                        SizedBox(
                        width: 100,
                        height: 50,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: 'Subject you would like to teach',
                          ),
                        ),
                      ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    width: 300,
                    height: 70,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.black),
                        backgroundColor:
                            const Color.fromARGB(255, 12, 100, 82),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      onPressed: () => {
                        // Navigator.of(context).pushNamed(const SignInfo() as String),
                      },
                        child: Text(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        'Continue Submission',  
                      ),
                    ),
                  ),
                  Container(
                      child: Text(
                        "Terms and Conditions",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: const Color.fromARGB(255, 12, 90, 85),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
