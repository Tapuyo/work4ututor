import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/data_class/tutor_info_class.dart';
import 'package:wokr4ututor/provider/search_provider.dart';
import 'package:wokr4ututor/ui/web/search_tutor/tutor_list.dart';
import 'package:wokr4ututor/utils/themes.dart';

import '../../../components/nav_bar.dart';
import '../../../provider/init_provider.dart';
import '../../../services/services.dart';
import '../signup/student_signup.dart';

class FindTutor extends StatefulWidget {
  const FindTutor({super.key});

  @override
  State<FindTutor> createState() => _FindTutorState();
}

int displayRange = 12;
List<String> languages = [
  'Filipino',
  'English',
  'Russian',
  'Chinese',
  'Japanese',
];
List<String> subjects = [
  'Math',
  'English',
  'Geometry',
  'Music',
  'Language',
];
List<String> items = [
  'Philippines',
  'China',
  'Russia',
  'United States',
  'India',
  'Japan',
];
List<String> typeofclass = [
  'In person Class',
  'Online Class',
];
List<String> provided = [
  'Philippines',
  'China',
  'Russia',
  'United States',
  'India',
  'Japan',
];
List<String> city = [
  'Philippines',
  'China',
];

final TextEditingController _typeAheadController = TextEditingController();

final TextEditingController _typeAheadController1 = TextEditingController();

final TextEditingController _typeAheadController2 = TextEditingController();

final TextEditingController _typeAheadController3 = TextEditingController();

final TextEditingController _typeAheadController4 = TextEditingController();

final TextEditingController _typeAheadController5 = TextEditingController();

bool filtervisible = true;

class _FindTutorState extends State<FindTutor> {
  @override
  Widget build(BuildContext context) {
    final String setSearch = context.select((SearchTutorProvider p) => p.tName);
    final tutorsinfo = Provider.of<List<TutorInformation>>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 116, 135, 1),
        elevation: 3,
        toolbarHeight: 100,
        title: const FindTutorNavbar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(100, 50, 100, 0),
          child: SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: size.width > 1350 ? 3 : 4,
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      filtervisible = !filtervisible;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.filter_list,
                                    size: 30,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      filtervisible = !filtervisible;
                                    });
                                  },
                                  child: const Text(
                                    "Filters",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    _typeAheadController.text = '';
                                    _typeAheadController1.text = '';
                                    _typeAheadController2.text = '';
                                    _typeAheadController3.text = '';
                                    _typeAheadController4.text = '';
                                    _typeAheadController5.text = '';
                                  },
                                  child: const Icon(
                                    Icons.clear,
                                    size: 30,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _typeAheadController.text = '';
                                    _typeAheadController1.text = '';
                                    _typeAheadController2.text = '';
                                    _typeAheadController3.text = '';
                                    _typeAheadController4.text = '';
                                    _typeAheadController5.text = '';
                                  },
                                  child: const Text(
                                    "Clear",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: filtervisible ? true : false,
                              child: Column(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 200,
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: kColorLight,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: TypeAheadField(
                                      hideOnEmpty: false,
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        autofocus: false,
                                        controller: _typeAheadController,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'COUNTRY',
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return items.where((item) => item
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()));
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion.toString(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (selectedItem) {
                                        print('Selected item: $selectedItem');
                                        setState(() {
                                          _typeAheadController.text =
                                              selectedItem.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 45,
                                    width: 200,
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: kColorLight,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: TypeAheadField(
                                      hideOnEmpty: false,
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        autofocus: false,
                                        controller: _typeAheadController1,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'CITY',
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return city.where((item) => item
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()));
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion.toString(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (selectedItem) {
                                        print('Selected item: $selectedItem');
                                        setState(() {
                                          _typeAheadController1.text =
                                              selectedItem.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 45,
                                    width: 200,
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: kColorLight,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: TypeAheadField(
                                      hideOnEmpty: false,
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        autofocus: false,
                                        controller: _typeAheadController2,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'LANGUAGE',
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return languages.where((item) => item
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()));
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion.toString(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (selectedItem) {
                                        print('Selected item: $selectedItem');
                                        setState(() {
                                          _typeAheadController2.text =
                                              selectedItem.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 45,
                                    width: 200,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: kColorLight,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        shape: const BeveledRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontStyle: FontStyle.normal,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      onPressed: () {
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           const StudentSignup()),
                                        // );
                                      },
                                      child: const Text(
                                        'PRICING',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 45,
                                    width: 200,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: kColorLight,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        shape: const BeveledRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontStyle: FontStyle.normal,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      onPressed: () {
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           const StudentSignup()),
                                        // );
                                      },
                                      child: const Text(
                                        'RATING',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 45,
                                    width: 200,
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: kColorLight,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: TypeAheadField(
                                      hideOnEmpty: false,
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        autofocus: false,
                                        controller: _typeAheadController3,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'SUBJECT',
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return subjects.where((item) => item
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()));
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion.toString(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (selectedItem) {
                                        print('Selected item: $selectedItem');
                                        setState(() {
                                          _typeAheadController3.text =
                                              selectedItem.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 45,
                                    width: 200,
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: kColorLight,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: TypeAheadField(
                                      hideOnEmpty: false,
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        autofocus: false,
                                        controller: _typeAheadController4,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'SERVICE PROVIDED',
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return provided.where((item) => item
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()));
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion.toString(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (selectedItem) {
                                        print('Selected item: $selectedItem');
                                        setState(() {
                                          _typeAheadController4.text =
                                              selectedItem.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 45,
                                    width: 200,
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: kColorLight,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: TypeAheadField(
                                      hideOnEmpty: false,
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        autofocus: false,
                                        controller: _typeAheadController5,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'TYPE OF CLASS',
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return typeofclass.where((item) => item
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()));
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(
                                            suggestion.toString(),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (selectedItem) {
                                        print('Selected item: $selectedItem');
                                        setState(() {
                                          _typeAheadController5.text =
                                              selectedItem.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                      // height: MediaQuery.of(context).size.height,
                      // child: const VerticalDivider(
                      //   thickness: 1,
                      // ),
                    ),
                    Flexible(
                      flex: 15,
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width - 505,
                                  height: 60,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      hintStyle: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      hintText: 'Search',
                                    ),
                                    validator: (val) => val!.isEmpty
                                        ? 'Enter your search filter'
                                        : null,
                                    onChanged: (val) {
                                      tName = val;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        splashColor: kColorLight,
                                        onTap: () {
                                          setState(() {
                                            final provider = context
                                                .read<SearchTutorProvider>();
                                            provider.setSearch(tName);
                                            TutorList(
                                              tutorslist: tutorsinfo,
                                              keyword: setSearch,
                                              displayRange: displayRange,
                                            );
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const <Widget>[
                                            Icon(Icons.search), // <-- Icon
                                            Text("Search"), // <-- Text
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            TutorList(
                              tutorslist: tutorsinfo,
                              keyword: setSearch,
                              displayRange: displayRange,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 45,
                              width: 200,
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: kColorLight,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  shape: const BeveledRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                onPressed: () {
                                  // Navigator.pushReplacement(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           const StudentSignup()),
                                  // );
                                },
                                child: const Text('Display More'),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
