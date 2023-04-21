import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/ui/auth/database.dart';

import '../../../../data_class/user_class.dart';
import '../../../../provider/user_id_provider.dart';
import '../../../../utils/themes.dart';
import '../../../auth/auth.dart';

class CalendarSetup extends StatefulWidget {
  const CalendarSetup({super.key});

  @override
  State<CalendarSetup> createState() => _CalendarSetupState();
}

class _CalendarSetupState extends State<CalendarSetup> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _typeAheadController3 = TextEditingController();

  final TextEditingController _typeAheadController4 = TextEditingController();
  List<String> provided = [
    '4',
    '6',
    '7',
    '8',
    '9',
  ];
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final int startHour = 0;
  final int endHour = 24;
  String dateselected = '';
  bool _checkboxavailableday = false;
  bool _checkboxavailabledate = false;
  bool _checkboxavailabledayTime = false;
  bool _checkboxavailabledateTime = false;
  bool _checkboxspeceficdate = false;
  bool _checkboxavailabledayblock = false;
  bool _checkboxavailabledateblock = false;
  bool _checkboxspeceficdateblock = false;

  String selectedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: kColorPrimary,
            colorScheme: const ColorScheme.light(primary: kColorPrimary),
            dialogBackgroundColor: Colors.white,
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              backgroundColor: Colors.transparent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateFormat('MMMM dd, yyyy').format(picked);
      });
    }
  }

  TimeOfDay _selectedTime = TimeOfDay.now();
  String selectedTime = DateFormat('hh:mm a')
      .format(DateTime(0, 0, 0, TimeOfDay.now().hour, TimeOfDay.now().minute));
  String selectedTimeto = DateFormat('hh:mm a')
      .format(DateTime(0, 0, 0, TimeOfDay.now().hour, TimeOfDay.now().minute));

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      useRootNavigator: false,
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );
    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
        TimeOfDay time = _selectedTime;
        String formattedTime = DateFormat('hh:mm a')
            .format(DateTime(0, 0, 0, time.hour, time.minute));
        print(formattedTime);
        selectedTime = formattedTime.toString();
      });
    }
  }

  Future<void> _selectTimeto(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      useRootNavigator: false,
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );
    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
        TimeOfDay time = _selectedTime;
        String formattedTime = DateFormat('hh:mm a')
            .format(DateTime(0, 0, 0, time.hour, time.minute));
        print(formattedTime);
        selectedTimeto = formattedTime.toString();
      });
    }
  }

  int canbeuseDayoff = 0;
  int canbeuseTimeavailable = 0;
  int canbeuseBlock = 0;
  @override
  Widget build(BuildContext context) {
    final String userID= context.select((UserIDProvider p) => p.userID);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Container(
        width: 650,
        height: 600,
        child: Column(
          children: [
            Container(
              width: 500,
              height: 90,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/8347.png',
                      width: 210.0,
                      height: 90.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Flexible(
                    flex: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Calendar Setup / Date and Time ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'Select your day off and date and time availability at your own preferences.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 130,
                width: 650,
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kCalendarColorFB,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2, bottom: 0),
                      child: Text(
                        'SELECT DAY OFF',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _checkboxavailableday,
                          onChanged: (value) {
                            setState(() {
                              _checkboxavailableday = value!;
                              _checkboxavailabledate = false;
                              if (canbeuseDayoff == 0 || canbeuseDayoff == 2) {
                                canbeuseDayoff = 1;
                              } else {
                                canbeuseDayoff = 0;
                              }
                            });
                          },
                        ),
                        Text('Apply as weekly day off'),
                        const SizedBox(
                          width: 5,
                        ),
                        Checkbox(
                          value: _checkboxavailabledate,
                          onChanged: (value) {
                            setState(() {
                              _checkboxavailabledate = value!;
                              _checkboxavailableday = false;
                              if (canbeuseDayoff == 0 || canbeuseDayoff == 1) {
                                canbeuseDayoff = 2;
                              } else {
                                canbeuseDayoff = 0;
                              }
                            });
                          },
                        ),
                        Text('Apply for specific date'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: canbeuseDayoff != 2 ? true : false,
                          child: Container(
                            height: 40,
                            width: 155,
                            padding: const EdgeInsets.only(right: 5, left: 5),
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: TypeAheadField(
                              hideOnEmpty: false,
                              textFieldConfiguration: TextFieldConfiguration(
                                textAlign: TextAlign.left,
                                textAlignVertical: TextAlignVertical.center,
                                autocorrect: true,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                autofocus: false,
                                controller: _typeAheadController3,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 8),
                                  border: InputBorder.none,
                                  hintText: 'Select Days',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                return days.where((item) => item
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
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Visibility(
                          visible: canbeuseDayoff != 1 ? true : false,
                          child: Container(
                            height: 40,
                            width: 160,
                            padding: const EdgeInsets.only(right: 5, left: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(selectedDate),
                                IconButton(
                                  onPressed: () => _selectDate(context),
                                  icon: const Icon(Icons.calendar_today),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () async {
                            final UserDataService _userid = UserDataService(userUID: userID);
                            final result =
                                await _userid.addScheduleTimeavailable();
                                //  Users result1 =
                                // await _auth.addDayoffs();
                            if (result == null) {
                              print('error');
                            } else {
                              print('success');
                            }
                            //  if (result1 == null) {
                            //   print('error1');
                            // } else {
                            //   print('success1');
                            // }
                          },
                          child: const Text(
                            'Add',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        const Flexible(
                          flex: 10,
                          child: Text(
                            'Days Off:',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 10,
                          child: InkWell(
                            onTap: () {
                              //add formula
                            },
                            child: const Text(
                              'Clear Selection',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 165,
                width: 650,
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kCalendarColorAB,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2, bottom: 0),
                      child: Text(
                        'TIME AVAILABLE',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _checkboxavailabledayTime,
                          onChanged: (value) {
                            setState(() {
                              _checkboxavailabledayTime = value!;
                              _checkboxavailabledateTime = false;
                              _checkboxspeceficdate = false;
                              if (canbeuseTimeavailable != 1) {
                                canbeuseTimeavailable = 1;
                              } else {
                                canbeuseTimeavailable = 0;
                              }
                            });
                          },
                        ),
                        Text('Apply for every available day'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _checkboxspeceficdate,
                          onChanged: (value) {
                            setState(() {
                              _checkboxspeceficdate = value!;
                              _checkboxavailabledateTime = false;
                              _checkboxavailabledayTime = false;
                              if (canbeuseTimeavailable != 3) {
                                canbeuseTimeavailable = 3;
                              } else {
                                canbeuseTimeavailable = 0;
                              }
                            });
                          },
                        ),
                        Text('Apply for specific day'),
                        Checkbox(
                          value: _checkboxavailabledateTime,
                          onChanged: (value) {
                            setState(() {
                              _checkboxavailabledateTime = value!;
                              _checkboxavailabledayTime = false;
                              _checkboxspeceficdate = false;
                              if (canbeuseTimeavailable != 2) {
                                canbeuseTimeavailable = 2;
                              } else {
                                canbeuseTimeavailable = 0;
                              }
                            });
                          },
                        ),
                        Text('Apply for specific date'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: canbeuseTimeavailable == 0 ||
                                  canbeuseTimeavailable == 3
                              ? true
                              : false,
                          child: Container(
                            height: 40,
                            width: 155,
                            padding: const EdgeInsets.only(right: 5, left: 5),
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: TypeAheadField(
                              hideOnEmpty: false,
                              textFieldConfiguration: TextFieldConfiguration(
                                textAlign: TextAlign.left,
                                textAlignVertical: TextAlignVertical.center,
                                autocorrect: true,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                autofocus: false,
                                controller: _typeAheadController3,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 8),
                                  border: InputBorder.none,
                                  hintText: 'Select Days',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                return days.where((item) => item
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
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Visibility(
                          visible: canbeuseTimeavailable == 0 ||
                                  canbeuseTimeavailable == 2
                              ? true
                              : false,
                          child: Container(
                            height: 40,
                            width: 160,
                            padding: const EdgeInsets.only(right: 5, left: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(selectedDate),
                                IconButton(
                                  onPressed: () => _selectDate(context),
                                  icon: const Icon(Icons.calendar_today),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 40,
                          width: 125,
                          padding: const EdgeInsets.only(right: 2, left: 2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedTime),
                              IconButton(
                                onPressed: () => _selectTime(context),
                                icon: const Icon(Icons.timelapse_rounded),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          child: Text('to'),
                        ),
                        Container(
                          height: 40,
                          width: 125,
                          padding: const EdgeInsets.only(right: 2, left: 2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedTimeto),
                              IconButton(
                                onPressed: () => _selectTimeto(context),
                                icon: const Icon(Icons.timelapse_rounded),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            //add formula
                          },
                          child: const Text(
                            'Add',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        const Flexible(
                          flex: 10,
                          child: Text(
                            'Days Off:',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 10,
                          child: InkWell(
                            onTap: () {
                              //add formula
                            },
                            child: const Text(
                              'Clear Selection',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 165,
                width: 650,
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kCalendarColorB,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2, bottom: 0),
                      child: Text(
                        'BLOCK TIME AND DATE',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _checkboxavailabledayblock,
                          onChanged: (value) {
                            setState(() {
                              _checkboxavailabledayblock = value!;
                              _checkboxavailabledateblock = false;
                              _checkboxspeceficdateblock = false;
                              if (canbeuseBlock != 1) {
                                canbeuseBlock = 1;
                              } else {
                                canbeuseBlock = 0;
                              }
                            });
                          },
                        ),
                        Text('Apply for every available day'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _checkboxspeceficdateblock,
                          onChanged: (value) {
                            setState(() {
                              _checkboxspeceficdateblock = value!;
                              _checkboxavailabledateblock = false;
                              _checkboxavailabledayblock = false;
                              if (canbeuseBlock != 3) {
                                canbeuseBlock = 3;
                              } else {
                                canbeuseBlock = 0;
                              }
                            });
                          },
                        ),
                        Text('Apply for specific days'),
                        Checkbox(
                          value: _checkboxavailabledateblock,
                          onChanged: (value) {
                            setState(() {
                              _checkboxavailabledateblock = value!;
                              _checkboxavailabledayblock = false;
                              _checkboxspeceficdateblock = false;
                              if (canbeuseBlock != 2) {
                                canbeuseBlock = 2;
                              } else {
                                canbeuseBlock = 0;
                              }
                            });
                          },
                        ),
                        Text('Apply for specific date'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: canbeuseBlock == 0 || canbeuseBlock == 3
                              ? true
                              : false,
                          child: Container(
                            height: 40,
                            width: 155,
                            padding: const EdgeInsets.only(right: 5, left: 5),
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: TypeAheadField(
                              hideOnEmpty: false,
                              textFieldConfiguration: TextFieldConfiguration(
                                textAlign: TextAlign.left,
                                textAlignVertical: TextAlignVertical.center,
                                autocorrect: true,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                autofocus: false,
                                controller: _typeAheadController3,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 8),
                                  border: InputBorder.none,
                                  hintText: 'Select Days',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                return days.where((item) => item
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
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Visibility(
                          visible: canbeuseBlock == 0 || canbeuseBlock == 2
                              ? true
                              : false,
                          child: Container(
                            height: 40,
                            width: 160,
                            padding: const EdgeInsets.only(right: 5, left: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(selectedDate),
                                IconButton(
                                  onPressed: () => _selectDate(context),
                                  icon: const Icon(Icons.calendar_today),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 40,
                          width: 125,
                          padding: const EdgeInsets.only(right: 2, left: 2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedTime),
                              IconButton(
                                onPressed: () => _selectTime(context),
                                icon: const Icon(Icons.timelapse_rounded),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          child: Text('to'),
                        ),
                        Container(
                          height: 40,
                          width: 125,
                          padding: const EdgeInsets.only(right: 2, left: 2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedTimeto),
                              IconButton(
                                onPressed: () => _selectTimeto(context),
                                icon: const Icon(Icons.timelapse_rounded),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            //add formula
                          },
                          child: const Text(
                            'Add',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        const Flexible(
                          flex: 10,
                          child: Text(
                            'Days Off:',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 10,
                          child: InkWell(
                            onTap: () {
                              //add formula
                            },
                            child: const Text(
                              'Clear Selection',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
