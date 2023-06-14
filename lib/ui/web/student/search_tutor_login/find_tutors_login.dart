// ignore_for_file: avoid_print

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/data_class/tutor_info_class.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/provider/search_provider.dart';
import 'package:wokr4ututor/ui/web/search_tutor/tutor_list.dart';
import 'package:wokr4ututor/utils/themes.dart';

import '../../../../components/nav_bar.dart';
import '../../signup/student_signup.dart';

class FindTutorLogin extends StatefulWidget {
  const FindTutorLogin({super.key});

  @override
  State<FindTutorLogin> createState() => _FindTutorLoginState();
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
bool _showModal = false;
  GlobalKey _buttonKey = GlobalKey();
  int newmessagecount = 1;
  int newnotificationcount = 1;
final TextEditingController _typeAheadController = TextEditingController();

final TextEditingController _typeAheadController1 = TextEditingController();

final TextEditingController _typeAheadController2 = TextEditingController();

final TextEditingController _typeAheadController3 = TextEditingController();

final TextEditingController _typeAheadController4 = TextEditingController();

final TextEditingController _typeAheadController5 = TextEditingController();

bool filtervisible = true;
double _pricevalue = 0;
int _rating = 0;

class _FindTutorLoginState extends State<FindTutorLogin> {
  @override
  Widget build(BuildContext context) {
    final String setSearch = context.select((SearchTutorProvider p) => p.tName);
    final tutorsinfo = Provider.of<List<TutorInformation>>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
              toolbarHeight: 65,
              backgroundColor: kColorPrimary,
              elevation: 4,
              shadowColor: Colors.black,
              title: Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                width: 240,
                child: Image.asset(
                  "assets/images/worklogo.png",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                  child: Badge(
                    isLabelVisible: newmessagecount == 0 ? false : true,
                    alignment: AlignmentDirectional.centerEnd,
                    label: Text(
                      newmessagecount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          EvaIcons.email,
                          color: Colors.white,
                          size: 25,
                        ),
                        onPressed: () {
                          final provider = context.read<InitProvider>();
                          provider.setMenuIndex(2);
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                  child: Badge(
                    isLabelVisible: newnotificationcount == 0 ? false : true,
                    alignment: AlignmentDirectional.centerEnd,
                    label: Text(
                      newnotificationcount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                        key: _buttonKey,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          EvaIcons.bell,
                          color: Colors.white,
                          size: 25,
                        ),
                        onPressed: () {
                          setState(() {
                            _showModal = !_showModal;
                          });
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const  Text(
                        "MJ Selma",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                       const  Text(
                        "STUPHL202301",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      RatingBar(
                          initialRating: 4,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 16,
                          ratingWidget: RatingWidget(
                              full: const Icon(Icons.star, color: Colors.orange),
                              half: const Icon(
                                Icons.star_half,
                                color: Colors.orange,
                              ),
                              empty: const Icon(
                                Icons.star_outline,
                                color: Colors.orange,
                              )),
                          onRatingUpdate: (value) {
                            // _ratingValue = value;
                          }),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/sample.jpg',
                    ),
                    radius: 25,
                  ),
                ),
              ],
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(100, 25, 100, 0),
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
                                      size: 25,
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
                                          fontSize: 18,
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
                                      size: 25,
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 220,
                                height: 50,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            final provider = context
                                                .read<SearchTutorProvider>();
                                            provider.setSearch(tName);
                                            TutorList(
                                              tutorslist: tutorsinfo,
                                              keyword: setSearch,
                                              displayRange: displayRange,
                                              isLoading: false,
                                            );
                                          });
                                        },
                                        child: const Icon(
                                          Icons.search_rounded,
                                          color: Colors.grey,
                                        ),
                                      ),
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
                                height: 10,
                              ),
                              Visibility(
                                visible: filtervisible ? true : false,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 220,
                                      padding: const EdgeInsets.only(
                                          right: 20, left: 20),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: kColorLight,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
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
                                            hintText: 'Country',
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
                                      height: 10,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 220,
                                      padding: const EdgeInsets.only(
                                          right: 20, left: 20),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: kColorLight,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
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
                                            hintText: 'City',
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
                                      height: 10,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 220,
                                      padding: const EdgeInsets.only(
                                          right: 20, left: 20),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: kColorLight,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
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
                                            hintText: 'Language',
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
                                      height: 10,
                                    ),
                                    Container(
                                        height: 50,
                                        width: 220,
                                        padding: const EdgeInsets.only(
                                            right: 20, left: 20, top: 2),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: kColorLight,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                             Text(
                                              'Pricing: $_pricevalue',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SliderTheme(
                                                  data: SliderTheme.of(context)
                                                      .copyWith(
                                                    trackHeight: 5.0,
                                                    trackShape:
                                                        const RoundedRectSliderTrackShape(),
                                                    activeTrackColor:
                                                        kColorPrimary,
                                                    inactiveTrackColor:
                                                        Colors.white,
                                                    thumbShape:
                                                        const RoundSliderThumbShape(
                                                      enabledThumbRadius: 10.0,
                                                      pressedElevation: 0.0,
                                                    ),
                                                    thumbColor: kColorPrimary,
                                                    overlayColor:
                                                        Colors.transparent,
                                                    overlayShape:
                                                        const RoundSliderOverlayShape(
                                                            overlayRadius: 0.0),
                                                    tickMarkShape:
                                                        const RoundSliderTickMarkShape(),
                                                    activeTickMarkColor:
                                                        kColorPrimaryDark,
                                                    inactiveTickMarkColor:
                                                        Colors.white,
                                                    valueIndicatorShape:
                                                        const PaddleSliderValueIndicatorShape(),
                                                    valueIndicatorColor:
                                                        Colors.black,
                                                    valueIndicatorTextStyle:
                                                        const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                  child: Slider(
                                                    min: 0.0,
                                                    max: 500.0,
                                                    value: _pricevalue,
                                                    divisions: 500,
                                                    label:
                                                        '${_pricevalue.round()}',
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _pricevalue = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 220,
                                      padding: const EdgeInsets.only(
                                          right: 20, left: 20, top: 2),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: kColorLight,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                           Text(
                                            'Rating: $_rating',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                icon: Icon(
                                                  _rating >= 1
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: _rating >= 1
                                                      ? Colors.orange
                                                      : Colors.white,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (_rating > 1 ||
                                                        _rating == 0) {
                                                      _rating = 1;
                                                    }else{
                                                      _rating = 0;
                                                    }
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                icon: Icon(
                                                  _rating >= 2
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: _rating >= 2
                                                      ? Colors.orange
                                                      : Colors.white,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _rating = 2;
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                icon: Icon(
                                                  _rating >= 3
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: _rating >= 3
                                                      ? Colors.orange
                                                      : Colors.white,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _rating = 3;
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                icon: Icon(
                                                  _rating >= 4
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: _rating >= 4
                                                      ? Colors.orange
                                                      : Colors.white,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _rating = 4;
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                icon: Icon(
                                                  _rating >= 5
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: _rating >= 5
                                                      ? Colors.orange
                                                      : Colors.white,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _rating = 5;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 220,
                                      padding: const EdgeInsets.only(
                                          right: 20, left: 20),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: kColorLight,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
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
                                            hintText: 'Subject',
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
                                      height: 10,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 220,
                                      padding: const EdgeInsets.only(
                                          right: 20, left: 20),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: kColorLight,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
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
                                            hintText: 'Service Provided',
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
                                      height: 10,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 220,
                                      padding: const EdgeInsets.only(
                                          right: 20, left: 20),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: kColorLight,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
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
                                            hintText: 'Type of Class',
                                            hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        suggestionsCallback: (pattern) {
                                          return typeofclass.where((item) =>
                                              item.toLowerCase().contains(
                                                  pattern.toLowerCase()));
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
                      SizedBox(
                        width: 20,
                        height: MediaQuery.of(context).size.height,
                        child: const VerticalDivider(
                          thickness: 1,
                        ),
                      ),
                      Flexible(
                        flex: 15,
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Column(
                            children: [
                              TutorList(
                                tutorslist: tutorsinfo,
                                keyword: setSearch,
                                displayRange: displayRange,
                                isLoading: false,
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
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: "search"),
            )
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
