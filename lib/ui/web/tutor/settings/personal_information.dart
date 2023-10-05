// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data_class/tutor_info_class.dart';
import '../../../../services/getlanguages.dart';
import 'update_tutor_info.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  String profilelink = '';
  List<String> timezonesList = [];
  List<String> countryList = [];
  dynamic tutordata;
  List<String> countryNames = [];
  List<LanguageData> names = [];
  @override
  Widget build(BuildContext context) {
    countryNames = Provider.of<List<String>>(context);
    names = Provider.of<List<LanguageData>>(context);
    List<TutorInformation> tutorinfodata =
        Provider.of<List<TutorInformation>>(context);
    return UpdateTutor(
      countryNames: countryNames,
      names: names,
      tutordata: tutorinfodata.first,
    );
  }
}
