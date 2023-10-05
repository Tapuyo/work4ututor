import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/ui/web/tutor/settings/update_tutor_information.dart';

import '../../../../data_class/tutor_info_class.dart';

class TutorInfoSettings extends StatefulWidget {
  const TutorInfoSettings({super.key});

  @override
  State<TutorInfoSettings> createState() => _TutorInfoSettingsState();
}

class _TutorInfoSettingsState extends State<TutorInfoSettings> {
  @override
  Widget build(BuildContext context) {
    List<TutorInformation> tutorinfodata =
        Provider.of<List<TutorInformation>>(context);
    return UpdateTutorSevices(
      tutordata: tutorinfodata.first,
    );
  }
}
