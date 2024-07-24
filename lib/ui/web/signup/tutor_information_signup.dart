// ignore_for_file: avoid_web_libraries_in_flutter, avoid_print, unused_local_variable, unused_field, prefer_final_fields, unused_element, use_build_context_synchronously

import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_pickers/country.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'dart:js' as js;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/services/getlanguages.dart';
import '../../../components/nav_bar.dart';
import '../../../data_class/subject_class.dart';
import '../../../data_class/subject_teach_pricing.dart';
import '../../../services/getstudentinfo.dart';
import '../../../services/send_email.dart';
import '../../../shared_components/alphacode3.dart';
import '../../../utils/themes.dart';
import '../../auth/auth.dart';
import '../terms/termpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TutorInfo extends StatefulWidget {
  final String uid;
  final String email;
  const TutorInfo({Key? key, required this.uid, required this.email})
      : super(key: key);

  @override
  State<TutorInfo> createState() => _TutorInfoState();
}

class _TutorInfoState extends State<TutorInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Center(
            child: InputInfo(
          uid: widget.uid,
          email: widget.email,
        )));
  }
}

class InputInfo extends StatefulWidget {
  final String uid;
  final String email;
  const InputInfo({super.key, required this.uid, required this.email});

  @override
  State<InputInfo> createState() => _InputInfoState();
}

class _InputInfoState extends State<InputInfo> {
  // void main() {
  //   super.initState();
  //   _initData();
  //   tz.initializeTimeZone();
  // }

// timezone
  var dtf = js.context['Intl'].callMethod('DateTimeFormat');
  var ops = js.context['Intl']
      .callMethod('DateTimeFormat')
      .callMethod('resolvedOptions');
  String? dropdownvalue;
  String? dropdownvaluesubject;
  bool select = false;

//tutor information
  // Map<String, Location> _timeZones = {};
  TextEditingController _selectedTimeZone = TextEditingController();
  FocusNode _selectedTimeZonefocusNode = FocusNode();
  bool _showselectedTimeZoneSuggestions = false;
  TextEditingController firstname = TextEditingController();
  TextEditingController middlename = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController price2 = TextEditingController();
  TextEditingController price3 = TextEditingController();
  TextEditingController preice5 = TextEditingController();
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'US');
  TextEditingController phoneNumberController = TextEditingController();

  String selectedCountry = "";
  String tcontactNumber = "";
  String tCountry = "";
  TextEditingController tCity = TextEditingController();
  String selectedbirthCountry = "";
  String selectedGender = "";

  TextEditingController birthtCity = TextEditingController();
  List<String> tTimezone = [];
  int age = 0;
  List<String> uSubjects = [];
  String uID = "Upload your ID";
  String uPicture = "";
  List<String> servicesprovided = [];
  List<String> tlanguages = [];
  List<String> citizenship = [];

  String currentLanguage = '';
  String currentctzship = '';

  List<String> genders = ['Male', 'Female', 'Rather not say'];

  List<SubjectTeach> tSubjects = [];
  String uCV = "";
  String uVideo = "";
  String tAbout = "";
  bool shareInfo = false;
  bool selection1 = false;
  bool selection2 = false;
  bool selection3 = false;
  bool selection4 = false;
  bool selection5 = false;
  bool onlineclas = false;
  bool inperson = false;
  int languageCount = 1;
  int subjectcount = 1;
  double subjecthieght = 250;
  double thieght = 45;

  //term
  bool termStatus = false;
  bool countryStatus = false;
  bool genderStatus = false;

  bool showme = false;
  bool showmecustom = false;

  DateTime selectedDate = DateTime.now();
  String bdate = "Date of Birth";
  String myage = "Age";
  String guardianbdate = "Date of Birth";
  String guardianage = "Age";

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(5000));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        bdate = DateFormat("MMMM dd, yyyy").format(selectedDate);
        calculateAge(picked);
      });
    }
  }

  void calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int currentage = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (currentage < 0) {
    } else {
      if (month2 > month1) {
        currentage--;
        setState(() {
          age = currentage;
          myage = age.toString();
        });
      } else if (month1 == month2) {
        int day1 = currentDate.day;
        int day2 = birthDate.day;
        if (day2 > day1) {
          currentage--;
          setState(() {
            age = currentage;
            myage = age.toString();
          });
        } else if (day2 <= day1) {
          setState(() {
            age = currentage;
            myage = age.toString();
          });
        }
      } else if (month1 > month2) {
        setState(() {
          age = currentage;
          myage = age.toString();
        });
      }
    }
  }

  List<String> timezonesList = [];
  List<String> countryList = [];

  String tutorIDNumber = 'TTR*********';
  String applicantsID = '';
  final tutorformKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // _initData();
    getTimezones();
    getCountries();
    // _timeZones = tz.timeZoneDatabase.locations;
  }

  // Future<void> _initData() async {
  //   //   // try {
  //   //   //   _selectedTimeZone.text = await FlutterNativeTimezone
  //   //   //       .getLocalTimezone(); // Set local timezone here
  //   //   // } catch (e) {
  //   //   //   print(e.toString());
  //   //   // }
  //   _selectedTimeZone.text == 'Select your Timezone';
  // }

  Future<void> getTimezones() async {
    final response =
        await http.get(Uri.parse('http://worldtimeapi.org/api/timezone'));

    if (response.statusCode == 200) {
      final List<dynamic> timezones = json.decode(response.body);
      if (timezones.isNotEmpty) {
        setState(() {
          timezonesList = List<String>.from(timezones);
        });
      } else {
        throw Exception('No timezones found');
      }
    } else {
      throw Exception('Failed to load timezones: ${response.statusCode}');
    }
  }

  Future<void> getCountries() async {
    final response =
        await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      final List<dynamic> countriesData = json.decode(response.body);
      if (countriesData.isNotEmpty) {
        // Initialize an empty list to store the common names
        final List<String> commonNamesList = [];

        // Iterate through the countries and extract the 'common' names
        for (final countryData in countriesData) {
          final String commonName = countryData['name']['common'] as String;
          commonNamesList.add(commonName);
        }

        // Print the list of common names

        // If you need to use this list elsewhere, you can assign it to your countryList
        setState(() {
          countryList = commonNamesList;
        });
      } else {
        throw Exception('No countries found');
      }
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }

  TextEditingController _selectedCountryController = TextEditingController();
  TextEditingController _selectedBirthCountryController =
      TextEditingController();
  TextEditingController _selectedGenderController = TextEditingController();
  TextEditingController _selectedTimezoneController = TextEditingController();
  TextEditingController _selectedLanguageController = TextEditingController();
  TextEditingController _selectedSubjectController = TextEditingController();

  final TextEditingController price2Controller = TextEditingController();
  final TextEditingController price3Controller = TextEditingController();
  final TextEditingController price5Controller = TextEditingController();
  final TextEditingController aboutme = TextEditingController();
  final AuthService _auth = AuthService();

  final List<Map<String, String>> languages = [
    {"isoCode": "ab", "name": "Abkhazian"},
    {"isoCode": "aa", "name": "Afar"},
    {"isoCode": "af", "name": "Afrikaans"},
    {"isoCode": "ak", "name": "Akan"},
    {"isoCode": "sq", "name": "Albanian"},
    {"isoCode": "am", "name": "Amharic"},
    {"isoCode": "ar", "name": "Arabic"},
    {"isoCode": "an", "name": "Aragonese"},
    {"isoCode": "hy", "name": "Armenian"},
    {"isoCode": "as", "name": "Assamese"},
    {"isoCode": "av", "name": "Avaric"},
    {"isoCode": "ae", "name": "Avestan"},
    {"isoCode": "ay", "name": "Aymara"},
    {"isoCode": "az", "name": "Azerbaijani"},
    {"isoCode": "bm", "name": "Bambara"},
    {"isoCode": "ba", "name": "Bashkir"},
    {"isoCode": "eu", "name": "Basque"},
    {"isoCode": "be", "name": "Belarusian"},
    {"isoCode": "bn", "name": "Bengali"},
    {"isoCode": "bh", "name": "Bihari Languages"},
    {"isoCode": "bi", "name": "Bislama"},
    {"isoCode": "bs", "name": "Bosnian"},
    {"isoCode": "br", "name": "Breton"},
    {"isoCode": "bg", "name": "Bulgarian"},
    {"isoCode": "my", "name": "Burmese"},
    {"isoCode": "ca", "name": "Catalan"},
    {"isoCode": "km", "name": "Central Khmer"},
    {"isoCode": "ch", "name": "Chamorro"},
    {"isoCode": "ce", "name": "Chechen"},
    {"isoCode": "ny", "name": "Chewa (Nyanja)"},
    {"isoCode": "zh_Hans", "name": "Chinese (Simplified)"},
    {"isoCode": "zh_Hant", "name": "Chinese (Traditional)"},
    {"isoCode": "cu", "name": "Church Slavonic"},
    {"isoCode": "cv", "name": "Chuvash"},
    {"isoCode": "kw", "name": "Cornish"},
    {"isoCode": "co", "name": "Corsican"},
    {"isoCode": "cr", "name": "Cree"},
    {"isoCode": "hr", "name": "Croatian"},
    {"isoCode": "cs", "name": "Czech"},
    {"isoCode": "da", "name": "Danish"},
    {"isoCode": "dv", "name": "Dhivehi"},
    {"isoCode": "nl", "name": "Dutch"},
    {"isoCode": "dz", "name": "Dzongkha"},
    {"isoCode": "en", "name": "English"},
    {"isoCode": "eo", "name": "Esperanto"},
    {"isoCode": "et", "name": "Estonian"},
    {"isoCode": "ee", "name": "Ewe"},
    {"isoCode": "fo", "name": "Faroese"},
    {"isoCode": "fj", "name": "Fijian"},
    {"isoCode": "fi", "name": "Finnish"},
    {"isoCode": "fr", "name": "French"},
    {"isoCode": "ff", "name": "Fulah"},
    {"isoCode": "gd", "name": "Gaelic"},
    {"isoCode": "gl", "name": "Galician"},
    {"isoCode": "lg", "name": "Ganda"},
    {"isoCode": "ka", "name": "Georgian"},
    {"isoCode": "de", "name": "German"},
    {"isoCode": "el", "name": "Greek"},
    {"isoCode": "gn", "name": "Guarani"},
    {"isoCode": "gu", "name": "Gujarati"},
    {"isoCode": "ht", "name": "Haitian"},
    {"isoCode": "ha", "name": "Hausa"},
    {"isoCode": "he", "name": "Hebrew"},
    {"isoCode": "hz", "name": "Herero"},
    {"isoCode": "hi", "name": "Hindi"},
    {"isoCode": "ho", "name": "Hiri Motu"},
    {"isoCode": "hu", "name": "Hungarian"},
    {"isoCode": "is", "name": "Icelandic"},
    {"isoCode": "io", "name": "Ido"},
    {"isoCode": "ig", "name": "Igbo"},
    {"isoCode": "id", "name": "Indonesian"},
    {"isoCode": "ia", "name": "Interlingua"},
    {"isoCode": "ie", "name": "Interlingue"},
    {"isoCode": "iu", "name": "Inuktitut"},
    {"isoCode": "ik", "name": "Inupiaq"},
    {"isoCode": "ga", "name": "Irish"},
    {"isoCode": "it", "name": "Italian"},
    {"isoCode": "ja", "name": "Japanese"},
    {"isoCode": "jv", "name": "Javanese"},
    {"isoCode": "kl", "name": "Kalaallisut"},
    {"isoCode": "kn", "name": "Kannada"},
    {"isoCode": "kr", "name": "Kanuri"},
    {"isoCode": "ks", "name": "Kashmiri"},
    {"isoCode": "kk", "name": "Kazakh"},
    {"isoCode": "ki", "name": "Kikuyu"},
    {"isoCode": "rw", "name": "Kinyarwanda"},
    {"isoCode": "ky", "name": "Kirghiz"},
    {"isoCode": "kv", "name": "Komi"},
    {"isoCode": "kg", "name": "Kongo"},
    {"isoCode": "ko", "name": "Korean"},
    {"isoCode": "kj", "name": "Kuanyama"},
    {"isoCode": "ku", "name": "Kurdish"},
    {"isoCode": "lo", "name": "Lao"},
    {"isoCode": "la", "name": "Latin"},
    {"isoCode": "lv", "name": "Latvian"},
    {"isoCode": "li", "name": "Limburgan"},
    {"isoCode": "ln", "name": "Lingala"},
    {"isoCode": "lt", "name": "Lithuanian"},
    {"isoCode": "lu", "name": "Luba-Katanga"},
    {"isoCode": "lb", "name": "Luxembourgish"},
    {"isoCode": "mk", "name": "Macedonian"},
    {"isoCode": "mg", "name": "Malagasy"},
    {"isoCode": "ms", "name": "Malay"},
    {"isoCode": "ml", "name": "Malayalam"},
    {"isoCode": "mt", "name": "Maltese"},
    {"isoCode": "gv", "name": "Manx"},
    {"isoCode": "mi", "name": "Maori"},
    {"isoCode": "mr", "name": "Marathi"},
    {"isoCode": "mh", "name": "Marshallese"},
    {"isoCode": "mn", "name": "Mongolian"},
    {"isoCode": "na", "name": "Nauru"},
    {"isoCode": "nv", "name": "Navajo"},
    {"isoCode": "nd", "name": "Ndebele, North"},
    {"isoCode": "nr", "name": "Ndebele, South"},
    {"isoCode": "ng", "name": "Ndonga"},
    {"isoCode": "ne", "name": "Nepali"},
    {"isoCode": "se", "name": "Northern Sami"},
    {"isoCode": "no", "name": "Norwegian"},
    {"isoCode": "nn", "name": "Norwegian Nynorsk"},
    {"isoCode": "oc", "name": "Occitan"},
    {"isoCode": "oj", "name": "Ojibwa"},
    {"isoCode": "or", "name": "Oriya"},
    {"isoCode": "om", "name": "Oromo"},
    {"isoCode": "os", "name": "Ossetian"},
    {"isoCode": "pi", "name": "Pali"},
    {"isoCode": "pa", "name": "Panjabi"},
    {"isoCode": "fa", "name": "Persian"},
    {"isoCode": "pl", "name": "Polish"},
    {"isoCode": "pt", "name": "Portuguese"},
    {"isoCode": "ps", "name": "Pushto"},
    {"isoCode": "qu", "name": "Quechua"},
    {"isoCode": "ro", "name": "Romanian"},
    {"isoCode": "rm", "name": "Romansh"},
    {"isoCode": "rn", "name": "Rundi"},
    {"isoCode": "ru", "name": "Russian"},
    {"isoCode": "sm", "name": "Samoan"},
    {"isoCode": "sg", "name": "Sango"},
    {"isoCode": "sa", "name": "Sanskrit"},
    {"isoCode": "sc", "name": "Sardinian"},
    {"isoCode": "sr", "name": "Serbian"},
    {"isoCode": "sn", "name": "Shona"},
    {"isoCode": "ii", "name": "Sichuan Yi"},
    {"isoCode": "sd", "name": "Sindhi"},
    {"isoCode": "si", "name": "Sinhala"},
    {"isoCode": "sk", "name": "Slovak"},
    {"isoCode": "sl", "name": "Slovenian"},
    {"isoCode": "so", "name": "Somali"},
    {"isoCode": "st", "name": "Sotho, Southern"},
    {"isoCode": "es", "name": "Spanish"},
    {"isoCode": "su", "name": "Sundanese"},
    {"isoCode": "sw", "name": "Swahili"},
    {"isoCode": "ss", "name": "Swati"},
    {"isoCode": "sv", "name": "Swedish"},
    {"isoCode": "tl", "name": "Tagalog"},
    {"isoCode": "ty", "name": "Tahitian"},
    {"isoCode": "tg", "name": "Tajik"},
    {"isoCode": "ta", "name": "Tamil"},
    {"isoCode": "tt", "name": "Tatar"},
    {"isoCode": "te", "name": "Telugu"},
    {"isoCode": "th", "name": "Thai"},
    {"isoCode": "bo", "name": "Tibetan"},
    {"isoCode": "ti", "name": "Tigrinya"},
    {"isoCode": "to", "name": "Tonga (Tonga Islands)"},
    {"isoCode": "ts", "name": "Tsonga"},
    {"isoCode": "tn", "name": "Tswana"},
    {"isoCode": "tr", "name": "Turkish"},
    {"isoCode": "tk", "name": "Turkmen"},
    {"isoCode": "tw", "name": "Twi"},
    {"isoCode": "ug", "name": "Uighur"},
    {"isoCode": "uk", "name": "Ukrainian"},
    {"isoCode": "ur", "name": "Urdu"},
    {"isoCode": "uz", "name": "Uzbek"},
    {"isoCode": "ve", "name": "Venda"},
    {"isoCode": "vi", "name": "Vietnamese"},
    {"isoCode": "vo", "name": "Volapük"},
    {"isoCode": "wa", "name": "Walloon"},
    {"isoCode": "cy", "name": "Welsh"},
    {"isoCode": "fy", "name": "Western Frisian"},
    {"isoCode": "wo", "name": "Wolof"},
    {"isoCode": "xh", "name": "Xhosa"},
    {"isoCode": "yi", "name": "Yiddish"},
    {"isoCode": "yo", "name": "Yoruba"},
    {"isoCode": "za", "name": "Zhuang"},
    {"isoCode": "zu", "name": "Zulu"}
  ];

  void saveNamesToFirestore(List<Map<String, String>> languages) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Reference the Firestore collection where you want to save the data
      CollectionReference namesCollection = firestore.collection('languages');

      // Extract only the names from the list of languages
      List<String> names = languages.map((language) {
        return language['name'] ??
            ''; // Replace '' with a default value if 'name' is missing
      }).toList();

      // Add the list of names to the Firestore collection
      await namesCollection.add({'names': names});

      print('Names saved to Firestore.');
    } catch (e) {
      print('Error saving names to Firestore: $e');
    }
  }

  List<Color> vibrantColors = [
    const Color.fromRGBO(185, 237, 221, 1),
    const Color.fromRGBO(135, 203, 185, 1),
    const Color.fromRGBO(86, 157, 170, 1),
    const Color.fromRGBO(87, 125, 134, 1),
  ];

  Uint8List? selectedImage;
  String filename = '';

// Function to select an image
  void selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        selectedImage = result.files.first.bytes;
        filename = result.files.first.name;
      });
    }
  }

  List<Uint8List?> selectedIDfiles = [];
  List<String> idfilenames = [];
  List<String> idfilenamestype = [];
  void selectImagesID() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedIDfiles.addAll(result.files.map((file) => file.bytes));
        idfilenames.addAll(result.files.map((file) => file.name));
        // Determine file types and add them to idfilenamestype list
        List<String> fileExtensions = result.files.map((file) {
          final fileName = file.name;
          final extension = fileName.split('.').last.toLowerCase();
          return extension;
        }).toList();

        idfilenamestype.addAll(fileExtensions.map((extension) {
          // List common image extensions
          List<String> imageExtensions = [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'bmp',
            'webp'
          ];

          // Check if the extension is in the list of image extensions
          if (imageExtensions.contains(extension)) {
            return "Image";
          } else {
            return extension;
          }
        }));
      });
    }
  }

  List<Uint8List?> selectedresume = [];
  List<String> resumefilenames = [];
  List<String> resumefilenamestype = [];
  void selectResumes() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedresume.addAll(result.files.map((file) => file.bytes));
        resumefilenames.addAll(result.files.map((file) => file.name));
        List<String> fileExtensions = result.files.map((file) {
          final fileName = file.name;
          final extension = fileName.split('.').last.toLowerCase();
          return extension;
        }).toList();

        resumefilenamestype.addAll(fileExtensions.map((extension) {
          // List common image extensions
          List<String> imageExtensions = [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'bmp',
            'webp'
          ];

          // Check if the extension is in the list of image extensions
          if (imageExtensions.contains(extension)) {
            return "Image";
          } else {
            return extension;
          }
        }));
      });
    }
  }

  List<Uint8List?> selectedCertificates = [];
  List<String> certificatesfilenames = [];
  List<String> certificatesfilenamestype = [];
  void selectCertificates() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedCertificates.addAll(result.files.map((file) => file.bytes));
        certificatesfilenames.addAll(result.files.map((file) => file.name));
        List<String> fileExtensions = result.files.map((file) {
          final fileName = file.name;
          final extension = fileName.split('.').last.toLowerCase();
          return extension;
        }).toList();

        certificatesfilenamestype.addAll(fileExtensions.map((extension) {
          // List common image extensions
          List<String> imageExtensions = [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'bmp',
            'webp'
          ];

          // Check if the extension is in the list of image extensions
          if (imageExtensions.contains(extension)) {
            return "Image";
          } else {
            return extension;
          }
        }));
      });
    }
  }

  List<Uint8List?> selectedVideos = [];
  List<String> videoFilenames = [];

  void selectVideos() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video, // Specify that only video files should be allowed.
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedVideos.addAll(result.files.map((file) => file.bytes));
        videoFilenames.addAll(result.files.map((file) => file.name));
      });
    }
  }

// Declare a ScrollController
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  ScrollController _scrollController3 = ScrollController();

  bool isLoading = false;
  ScrollController updatescrollController1 = ScrollController();
  ScrollController updatescrollController2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<String> countryNames = Provider.of<List<String>>(context);
    List<LanguageData> names = Provider.of<List<LanguageData>>(context);
    final subjectlist = Provider.of<List<Subjects>>(context);
    uSubjects = subjectlist.map((subject) => subject.subjectName).toList();
    uSubjects.insert(0, 'Others');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarLog(),
          Form(
            key: tutorformKey,
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 130,
                      child: GestureDetector(
                        onTap: () {
                          saveNamesToFirestore(languages);
                        },
                        child: const Text(
                          "Subscribe with your information",
                          style: TextStyle(
                            // textStyle: Theme.of(context).textTheme.headlineMedium,
                            color: Color.fromRGBO(1, 118, 132, 1),
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 0, 15, 5),
                      alignment: Alignment.centerLeft,
                      width: 680,
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              Card(
                                margin: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                                child: SizedBox(
                                  width: 350,
                                  height: 350,
                                  // decoration: BoxDecoration(
                                  //     borderRadius: const BorderRadius.all(
                                  //         Radius.circular(20)),
                                  //     color: Colors.grey.shade100,
                                  //     border: Border.all(
                                  //         color: Colors.grey, width: .5)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: FadeInImage(
                                        fadeInDuration:
                                            const Duration(milliseconds: 500),
                                        placeholder: const AssetImage(
                                            "assets/images/login.png"),
                                        image: (selectedImage != null)
                                            ? MemoryImage(selectedImage!)
                                            : const AssetImage(
                                                    "assets/images/login.png")
                                                as ImageProvider<
                                                    Object>, // Display image from profileurl
                                        // imageErrorBuilder:
                                        //     (context, error, stackTrace) {
                                        //   return Image.asset(
                                        //       "assets/images/login.png");
                                        // },
                                        fit: BoxFit.cover,
                                        height: 70,
                                        width: 70,
                                      )),
                                ),
                              ),
                              Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    child: IconButton(
                                      onPressed: () async {
                                        // String? downloadURL =
                                        //     await uploadTutorProfile(
                                        // if (downloadURL != null) {
                                        //   // The upload was successful, and downloadURL contains the URL.
                                        //   print(
                                        //       "File uploaded successfully. URL: $downloadURL");
                                        //   setState(() {
                                        //     profileurl = downloadURL;
                                        //     updateTutorProfile(
                                        //         widget.uid, profileurl);
                                        //   });
                                        //   selectImage()
                                        // } else {
                                        //   // There was an error during file selection or upload.
                                        //   print("Error uploading file.");
                                        // }
                                        selectImage();
                                      },
                                      icon: const Icon(
                                        Icons.add_a_photo,
                                        size: 25.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          Column(
                            children: [Container()],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 0, 15, 5),
                      alignment: Alignment.centerLeft,
                      width: 680,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Tutor Identification Number",
                                style: TextStyle(
                                  color: kColorLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "(Auto Generated once Country of residence selected)*",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Card(
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                                child: Container(
                                  width: 300,
                                  height: 45,
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                  // decoration: BoxDecoration(
                                  //     borderRadius: const BorderRadius.all(
                                  //         Radius.circular(5)),
                                  //     color: Colors.white,
                                  //     border: Border.all(
                                  //         color: Colors.grey, width: 1)),
                                  child: Row(
                                    children: [
                                      Text(
                                        tutorIDNumber.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: kColorGrey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Personal Information",
                                style: TextStyle(
                                  color: kColorGrey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                " Required*",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "First Name",
                                    style: TextStyle(
                                        color: kColorLight,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: SizedBox(
                                      width: 190,
                                      height: 45,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextFormField(
                                          controller: firstname,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey,
                                            hintText: 'First Name',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 10),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // Rounded border
                                              borderSide: BorderSide
                                                  .none, // No outline border
                                            ),
                                          ),
                                          style: const TextStyle(
                                              color: kColorGrey),
                                          // validator: (val) => val!.isEmpty
                                          //     ? 'Enter a firstname'
                                          //     : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Middle Name",
                                    style: TextStyle(
                                        color: kColorLight,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: SizedBox(
                                      width: 190,
                                      height: 45,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextFormField(
                                          controller: middlename,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey,
                                            hintText: '(Optional)',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 10),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // Rounded border
                                              borderSide: BorderSide
                                                  .none, // No outline border
                                            ),
                                          ),
                                          style: const TextStyle(
                                              color: kColorGrey),
                                          // validator: (val) => val!.isEmpty
                                          //     ? 'Enter a middlename'
                                          //     : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Last Name",
                                    style: TextStyle(
                                        color: kColorLight,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: SizedBox(
                                      width: 190,
                                      height: 45,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextFormField(
                                          controller: lastname,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey,
                                            hintText: 'Last Name',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 10),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // Rounded border
                                              borderSide: BorderSide
                                                  .none, // No outline border
                                            ),
                                          ),
                                          style: const TextStyle(
                                              color: kColorGrey),
                                          // validator: (val) => val!.isEmpty
                                          //     ? 'Enter a lastname'
                                          //     : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Date of Birth",
                                    style: TextStyle(
                                        color: kColorLight,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      width: 400,
                                      height: 45,
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                      // decoration: BoxDecoration(
                                      //     borderRadius: const BorderRadius.all(
                                      //         Radius.circular(5)),
                                      //     color: Colors.white,
                                      //     border: Border.all(
                                      //         color: Colors.grey, width: 1)),
                                      child: Row(
                                        children: [
                                          Text(
                                            bdate.toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: bdate == 'Date of Birth'
                                                    ? Colors.grey
                                                    : kColorGrey),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            tooltip: 'Select Date',
                                            hoverColor: Colors.transparent,
                                            icon: const Icon(
                                              EvaIcons.calendarOutline,
                                              color: Colors.blue,
                                              size: 25,
                                            ),
                                            onPressed: () {
                                              _selectDate();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Age",
                                    style: TextStyle(
                                        color: kColorLight,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      width: 150,
                                      height: 45,
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                      // decoration: BoxDecoration(
                                      //     borderRadius: const BorderRadius.all(
                                      //         Radius.circular(5)),
                                      //     color: Colors.white,
                                      //     border: Border.all(
                                      //         color: Colors.grey, width: 1)),
                                      child: Row(
                                        children: [
                                          Text(
                                            myage.toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: myage == 'Age'
                                                    ? Colors.grey
                                                    : kColorGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Gender",
                                    style: TextStyle(
                                        color: kColorLight,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: SizedBox(
                                      width: 300,
                                      height: 45,

                                      child: TypeAheadFormField<String>(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          controller: _selectedGenderController,
                                          decoration: InputDecoration(
                                            hintText: 'Select a Gender',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // Rounded border
                                              borderSide: BorderSide
                                                  .none, // No outline border
                                            ),
                                            suffixIcon: const Icon(
                                                Icons.arrow_drop_down),
                                          ),
                                        ),
                                        suggestionsCallback: (String pattern) {
                                          return genders.where((country) =>
                                              country.toLowerCase().contains(
                                                  pattern.toLowerCase()));
                                        },
                                        itemBuilder:
                                            (context, String suggestion) {
                                          return ListTile(
                                            title: Text(
                                              suggestion,
                                              style: const TextStyle(
                                                  color: kColorGrey),
                                            ),
                                          );
                                        },
                                        onSuggestionSelected:
                                            (String suggestion) {
                                          setState(() {
                                            selectedGender = suggestion;
                                            _selectedGenderController.text =
                                                suggestion;
                                          });
                                        },
                                      ),
                                      // country.name
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Citizenship",
                                        style: TextStyle(
                                            color: kColorLight,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "(You can select more than one language.)",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w100,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: SizedBox(
                                      width: 300,
                                      height: 45,

                                      child: TypeAheadFormField<String>(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          // controller:
                                          //     _selectedBirthCountryController,
                                          decoration: InputDecoration(
                                            hintText: 'Select a Citizenship',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // Rounded border
                                              borderSide: BorderSide
                                                  .none, // No outline border
                                            ),
                                            suffixIcon: const Icon(
                                                Icons.arrow_drop_down),
                                          ),
                                        ),
                                        suggestionsCallback: (String pattern) {
                                          return countryNames.where((country) =>
                                              country.toLowerCase().contains(
                                                  pattern.toLowerCase()));
                                        },
                                        itemBuilder:
                                            (context, String suggestion) {
                                          return ListTile(
                                            title: Text(suggestion),
                                          );
                                        },
                                        onSuggestionSelected:
                                            (String suggestion) {
                                          if (citizenship
                                              .contains(suggestion)) {
                                            null;
                                          } else {
                                            setState(() {
                                              citizenship.add(suggestion
                                                  .toString()); // Add the LanguageData object to tlanguages
                                            });
                                          }
                                        },
                                      ),
                                      // country.name
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: citizenship.isNotEmpty ? true : false,
                            child: const SizedBox(
                              height: 10,
                            ),
                          ),
                          Visibility(
                            visible: citizenship.isNotEmpty ? true : false,
                            child: Container(
                              width: 680,
                              height: 45,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              // decoration: BoxDecoration(
                              //     borderRadius: const BorderRadius.all(
                              //         Radius.circular(5)),
                              //     color: Colors.white,
                              //     border: Border.all(
                              //         color: Colors.grey.shade300, width: 1)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 600,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          iconSize: 12,
                                          padding: EdgeInsets.zero,
                                          splashRadius: 1,
                                          icon: const Icon(
                                            Icons
                                                .arrow_back_ios, // Left arrow icon
                                            color: kColorPrimary,
                                          ),
                                          onPressed: () {
                                            // Scroll to the left
                                            updatescrollController2.animateTo(
                                              updatescrollController2.offset -
                                                  100.0, // Adjust the value as needed
                                              duration: const Duration(
                                                  milliseconds:
                                                      500), // Adjust the duration as needed
                                              curve: Curves.ease,
                                            );
                                          },
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              controller:
                                                  updatescrollController1,
                                              itemCount: citizenship.length,
                                              itemBuilder: (context, index) {
                                                String language =
                                                    citizenship[index];
                                                Color color = vibrantColors[index %
                                                    vibrantColors
                                                        .length]; // Cycle through colors

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (citizenship[
                                                                index] ==
                                                            currentctzship) {
                                                          currentctzship = '';
                                                        } else {
                                                          currentctzship =
                                                              citizenship[
                                                                  index];
                                                        }
                                                      });
                                                    },
                                                    child: Card(
                                                      margin: EdgeInsets.zero,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      elevation: 5,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 0, 10, 0),
                                                        decoration: citizenship[
                                                                    index] ==
                                                                currentctzship
                                                            ? const BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black12,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              4),
                                                                      blurRadius:
                                                                          5.0)
                                                                ],
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .centerLeft,
                                                                  end: Alignment
                                                                      .centerRight,
                                                                  stops: [
                                                                    0.0,
                                                                    1.0
                                                                  ],
                                                                  colors:
                                                                      buttonFocuscolors,
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                              )
                                                            : const BoxDecoration(
                                                                boxShadow: [
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .black12,
                                                                        offset: Offset(
                                                                            0,
                                                                            4),
                                                                        blurRadius:
                                                                            5.0)
                                                                  ],
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                                color: Colors
                                                                    .white),
                                                        child: Center(
                                                          child: Text(
                                                            language,
                                                            style: TextStyle(
                                                                color: citizenship[
                                                                            index] ==
                                                                        currentctzship
                                                                    ? Colors
                                                                        .white
                                                                    : kColorGrey),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                        IconButton(
                                          iconSize: 12,
                                          padding: EdgeInsets.zero,
                                          splashRadius: 1,
                                          icon: const Icon(
                                            Icons
                                                .arrow_forward_ios, // Right arrow icon
                                            color: kColorPrimary,
                                          ),
                                          onPressed: () {
                                            // Scroll to the right
                                            updatescrollController2.animateTo(
                                              updatescrollController2.offset +
                                                  100.0, // Adjust the value as needed
                                              duration: const Duration(
                                                  milliseconds:
                                                      500), // Adjust the duration as needed
                                              curve: Curves.ease,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    visualDensity: const VisualDensity(
                                        horizontal: -4, vertical: -4),
                                    icon: const Icon(
                                        Icons.delete_outline_outlined),
                                    color: Colors.red,
                                    iconSize: 18,
                                    onPressed: () {
                                      setState(() {
                                        citizenship.removeWhere(
                                            (item) => item == currentctzship);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Country of Residence",
                                    style: TextStyle(
                                        color: Color.fromRGBO(1, 118, 132, 1),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: SizedBox(
                                      width: 300,
                                      height: 45,
                                      child: TypeAheadFormField<String>(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          controller:
                                              _selectedCountryController,
                                          decoration: InputDecoration(
                                            hintText: 'Select a Country',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // Rounded border
                                              borderSide: BorderSide
                                                  .none, // No outline border
                                            ),
                                            labelStyle: const TextStyle(
                                                color: kColorGrey),
                                            suffixIcon: const Icon(
                                                Icons.arrow_drop_down),
                                          ),
                                        ),
                                        suggestionsCallback: (String pattern) {
                                          return countryNames.where((country) =>
                                              country.toLowerCase().contains(
                                                  pattern.toLowerCase()));
                                        },
                                        itemBuilder:
                                            (context, String suggestion) {
                                          return ListTile(
                                            title: Text(
                                              suggestion,
                                              style: const TextStyle(
                                                  color: kColorGrey),
                                            ),
                                          );
                                        },
                                        onSuggestionSelected:
                                            (String suggestion) {
                                          final alpha3Code =
                                              getAlpha3Code(suggestion);
                                          Random random = Random();

                                          DateTime datenow = DateTime.now();
                                          String currenttime =
                                              DateFormat('HHmmss')
                                                  .format(datenow);
                                          String randomNumber = random
                                                  .nextInt(1000000)
                                                  .toString() +
                                              currenttime.toString();
                                          String currentyear =
                                              DateFormat('yyyyMMdd')
                                                  .format(datenow);
                                          //todo please replace the random number with legnth of students enrolled
                                          setState(() {
                                            selectedCountry = suggestion;
                                            _selectedCountryController.text =
                                                suggestion;
                                            tutorIDNumber =
                                                'TTR$alpha3Code$currentyear$currenttime';
                                            applicantsID =
                                                'Work$currentyear$currenttime';
                                          });
                                          if (countryStatus) {
                                            setState(() {
                                              _selectedBirthCountryController
                                                  .text = suggestion;
                                            });
                                          }
                                        },
                                      ),
                                      // country.name
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "City of Residence",
                                    style: TextStyle(
                                        color: kColorLight,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      width: 266,
                                      height: 45,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      // decoration: BoxDecoration(
                                      //     borderRadius: const BorderRadius.all(
                                      //         Radius.circular(5)),
                                      //     color: Colors.white,
                                      //     border: Border.all(
                                      //         color: Colors.grey, width: 1)),
                                      child: TextFormField(
                                        style:
                                            const TextStyle(color: kColorGrey),
                                        controller: tCity,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            fillColor: Colors.grey,
                                            hintText: 'City',
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
                                            labelStyle:
                                                TextStyle(color: kColorGrey)),
                                        // validator: (val) => val!.isEmpty
                                        //     ? 'Enter your City'
                                        //     : null,
                                        onChanged: (val) {
                                          if (countryStatus) {
                                            setState(() {
                                              birthtCity.text = tCity.text;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Container(
                          //   alignment: Alignment.topLeft,
                          //   child: CheckboxListTile(
                          //     contentPadding: EdgeInsets.zero,
                          //     title: const Text(
                          //       'My residence information is same with birth place',
                          //       style:
                          //           TextStyle(fontSize: 12, color: kColorGrey),
                          //     ),
                          //     // subtitle: const Text(
                          //     //     'A computer science portal for geeks.'),
                          //     // secondary: const Icon(Icons.code),
                          //     autofocus: false,
                          //     activeColor: Colors.green,
                          //     checkColor: Colors.white,
                          //     selected: countryStatus,
                          //     value: countryStatus,
                          //     controlAffinity: ListTileControlAffinity.leading,
                          //     visualDensity: const VisualDensity(
                          //         horizontal: -4, vertical: -4),
                          //     onChanged: (value) {
                          //       if (countryStatus) {
                          //         setState(() {
                          //           countryStatus = value!;
                          //           selectedbirthCountry = selectedCountry;
                          //           _selectedBirthCountryController.text =
                          //               selectedCountry;
                          //           birthtCity.text = tCity.text;
                          //         });
                          //       } else {
                          //         setState(() {
                          //           countryStatus = value!;
                          //           selectedbirthCountry = selectedCountry;
                          //           _selectedBirthCountryController.text =
                          //               selectedCountry;
                          //           birthtCity.text = tCity.text;
                          //         });
                          //       }
                          //     },
                          //   ),
                          // ),
                          const SizedBox(
                            height: 15,
                          ),
                          // Row(
                          //   children: [
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         const Text(
                          //           "Country of Birth",
                          //           style: TextStyle(
                          //               color: kColorLight,
                          //               fontWeight: FontWeight.w600),
                          //         ),
                          //         Card(
                          //           margin: EdgeInsets.zero,
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(10),
                          //           ),
                          //           elevation: 5,
                          //           child: SizedBox(
                          //             width: 300,
                          //             height: 45,

                          //             child: TypeAheadFormField<String>(
                          //               textFieldConfiguration:
                          //                   TextFieldConfiguration(
                          //                 controller:
                          //                     _selectedBirthCountryController,
                          //                 decoration: InputDecoration(
                          //                   hintText: 'Select a Country',
                          //                   hintStyle: const TextStyle(
                          //                       color: Colors.grey),
                          //                   border: OutlineInputBorder(
                          //                     borderRadius:
                          //                         BorderRadius.circular(
                          //                             10.0), // Rounded border
                          //                     borderSide: BorderSide
                          //                         .none, // No outline border
                          //                   ),
                          //                   suffixIcon: const Icon(
                          //                       Icons.arrow_drop_down),
                          //                 ),
                          //               ),
                          //               suggestionsCallback: (String pattern) {
                          //                 return countryNames.where((country) =>
                          //                     country.toLowerCase().contains(
                          //                         pattern.toLowerCase()));
                          //               },
                          //               itemBuilder:
                          //                   (context, String suggestion) {
                          //                 return ListTile(
                          //                   title: Text(suggestion),
                          //                 );
                          //               },
                          //               onSuggestionSelected:
                          //                   (String suggestion) {
                          //                 setState(() {
                          //                   selectedbirthCountry = suggestion;
                          //                   _selectedBirthCountryController
                          //                       .text = suggestion;
                          //                 });
                          //               },
                          //             ),
                          //             // country.name
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     const Spacer(),
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         const Text(
                          //           "City of Birth",
                          //           style: TextStyle(
                          //               color: kColorLight,
                          //               fontWeight: FontWeight.w600),
                          //         ),
                          //         Card(
                          //           margin: EdgeInsets.zero,
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(10),
                          //           ),
                          //           elevation: 5,
                          //           child: Container(
                          //             width: 266,
                          //             height: 45,
                          //             padding: const EdgeInsets.fromLTRB(
                          //                 10, 0, 10, 0),
                          //             // decoration: BoxDecoration(
                          //             //     borderRadius: const BorderRadius.all(
                          //             //         Radius.circular(5)),
                          //             //     color: Colors.white,
                          //             //     border: Border.all(
                          //             //         color: Colors.grey, width: 1)),
                          //             child: TextFormField(
                          //               controller: birthtCity,
                          //               decoration: const InputDecoration(
                          //                 border: InputBorder.none,
                          //                 fillColor: Colors.grey,
                          //                 hintText: 'City',
                          //                 hintStyle: TextStyle(
                          //                     color: Colors.grey, fontSize: 15),
                          //               ),
                          //               validator: (val) => val!.isEmpty
                          //                   ? 'Enter your City'
                          //                   : null,
                          //               // onChanged: (val) {
                          //               //   tCity = val;
                          //               // },
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 15,
                          // ),

                          Row(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Timezone",
                                  style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.w600),
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  child: SizedBox(
                                    width: 300,
                                    height: 45,
                                    child: GestureDetector(
                                      onTap: () {
                                        // Close suggestions when tapped anywhere outside the input field.
                                        if (_selectedTimeZonefocusNode
                                            .hasFocus) {
                                          _selectedTimeZonefocusNode.unfocus();
                                          setState(() {
                                            _showselectedTimeZoneSuggestions =
                                                false;
                                          });
                                        }
                                      },
                                      child: TypeAheadFormField<String>(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          controller: _selectedTimeZone,
                                          focusNode: _selectedTimeZonefocusNode,
                                          onTap: () {
                                            setState(() {
                                              _showselectedTimeZoneSuggestions =
                                                  false;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Select your Timezone',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // Rounded border
                                              borderSide: BorderSide
                                                  .none, // No outline border
                                            ),
                                            suffixIcon: const Icon(
                                                Icons.arrow_drop_down),
                                          ),
                                        ),
                                        suggestionsCallback: (String pattern) {
                                          return timezonesList.where(
                                              (timezone) => timezone
                                                  .toLowerCase()
                                                  .contains(
                                                      pattern.toLowerCase()));
                                        },
                                        itemBuilder:
                                            (context, String suggestion) {
                                          return ListTile(
                                            title: Text(suggestion),
                                          );
                                        },
                                        onSuggestionSelected:
                                            (String suggestion) {
                                          setState(() {
                                            _selectedTimeZone.text = suggestion;
                                          });
                                        },
                                        hideOnEmpty:
                                            true, // Hide suggestions when the input is empty.
                                        hideOnLoading:
                                            true, // Hide suggestions during loading.
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Contact Number",
                                  style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.w600),
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  child: Container(
                                    width: 266,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    // decoration: BoxDecoration(
                                    //     borderRadius: const BorderRadius.all(
                                    //         Radius.circular(5)),
                                    //     color: Colors.white,
                                    //     border: Border.all(
                                    //         color: Colors.grey, width: 1)),
                                    child: InternationalPhoneNumberInput(
                                      maxLength: 20,
                                      onInputChanged: (PhoneNumber number) {
                                        phoneNumber = number;
                                      },
                                      selectorConfig: const SelectorConfig(
                                        selectorType:
                                            PhoneInputSelectorType.DIALOG,
                                        trailingSpace: false,
                                        leadingPadding: 0,
                                        setSelectorButtonAsPrefixIcon: true,
                                      ),
                                      ignoreBlank: false,
                                      autoValidateMode:
                                          AutovalidateMode.disabled,
                                      selectorTextStyle: const TextStyle(
                                          color: Colors.black, fontSize: 15),
                                      formatInput: true,
                                      inputDecoration: const InputDecoration(
                                          filled: false,
                                          isCollapsed: false,
                                          isDense: false,
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.only(bottom: 9)),
                                      // keyboardType:
                                      //     const TextInputType.numberWithOptions(
                                      //         signed: true, decimal: true),
                                      initialValue: phoneNumber,
                                      textFieldController:
                                          phoneNumberController,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Languages",
                                    style: TextStyle(
                                        color: kColorLight,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "(You can select more than one language.)",
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w100,
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Card(
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                                child: SizedBox(
                                  width: 680,
                                  height: 45,
                                  child: TypeAheadFormField<LanguageData>(
                                    // Specify LanguageData as the generic type
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      // controller: _selectedLanguageController,
                                      decoration: InputDecoration(
                                        hintText: 'Choose your language',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Rounded border
                                          borderSide: BorderSide
                                              .none, // No outline border
                                        ),
                                        suffixIcon:
                                            const Icon(Icons.arrow_drop_down),
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      // Assuming names is a List<LanguageData>
                                      final suggestions = names
                                          .where((language) => language
                                              .languageNamesStream
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase()))
                                          .toList(); // Return a list of LanguageData objects
                                      return suggestions;
                                    },
                                    itemBuilder: (context, suggestions) {
                                      return ListTile(
                                        title: Text(
                                          suggestions.languageNamesStream,
                                          style: const TextStyle(
                                              color: kColorGrey),
                                        ), // Access the language name
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      if (tlanguages.contains(
                                          suggestion.languageNamesStream)) {
                                        null;
                                      } else {
                                        setState(() {
                                          tlanguages.add(suggestion
                                              .languageNamesStream
                                              .toString()); // Add the LanguageData object to tlanguages
                                        });
                                      }
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          Visibility(
                            visible: tlanguages.isNotEmpty ? true : false,
                            child: const SizedBox(
                              height: 10,
                            ),
                          ),
                          Visibility(
                            visible: tlanguages.isNotEmpty ? true : false,
                            child: Container(
                              width: 680,
                              height: 45,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              // decoration: BoxDecoration(
                              //     borderRadius: const BorderRadius.all(
                              //         Radius.circular(5)),
                              //     color: Colors.white,
                              //     border: Border.all(
                              //         color: Colors.grey.shade300, width: 1)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 600,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          iconSize: 12,
                                          padding: EdgeInsets.zero,
                                          splashRadius: 1,
                                          icon: const Icon(
                                            Icons
                                                .arrow_back_ios, // Left arrow icon
                                            color: kColorPrimary,
                                          ),
                                          onPressed: () {
                                            // Scroll to the left
                                            updatescrollController1.animateTo(
                                              updatescrollController1.offset -
                                                  100.0, // Adjust the value as needed
                                              duration: const Duration(
                                                  milliseconds:
                                                      500), // Adjust the duration as needed
                                              curve: Curves.ease,
                                            );
                                          },
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              controller:
                                                  updatescrollController1,
                                              itemCount: tlanguages.length,
                                              itemBuilder: (context, index) {
                                                String language =
                                                    tlanguages[index];
                                                Color color = vibrantColors[index %
                                                    vibrantColors
                                                        .length]; // Cycle through colors

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (tlanguages[index] ==
                                                            currentLanguage) {
                                                          currentLanguage = '';
                                                        } else {
                                                          currentLanguage =
                                                              tlanguages[index];
                                                        }
                                                      });
                                                    },
                                                    child: Card(
                                                      margin: EdgeInsets.zero,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      elevation: 5,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 0, 10, 0),
                                                        decoration: tlanguages[
                                                                    index] ==
                                                                currentLanguage
                                                            ? const BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black12,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              4),
                                                                      blurRadius:
                                                                          5.0)
                                                                ],
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .centerLeft,
                                                                  end: Alignment
                                                                      .centerRight,
                                                                  stops: [
                                                                    0.0,
                                                                    1.0
                                                                  ],
                                                                  colors:
                                                                      buttonFocuscolors,
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                              )
                                                            : const BoxDecoration(
                                                                boxShadow: [
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .black12,
                                                                        offset: Offset(
                                                                            0,
                                                                            4),
                                                                        blurRadius:
                                                                            5.0)
                                                                  ],
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                                color: Colors
                                                                    .white),
                                                        child: Center(
                                                          child: Text(
                                                            language,
                                                            style: TextStyle(
                                                                color: tlanguages[
                                                                            index] ==
                                                                        currentLanguage
                                                                    ? Colors
                                                                        .white
                                                                    : kColorGrey),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                        IconButton(
                                          iconSize: 12,
                                          padding: EdgeInsets.zero,
                                          splashRadius: 1,
                                          icon: const Icon(
                                            Icons
                                                .arrow_forward_ios, // Right arrow icon
                                            color: kColorPrimary,
                                          ),
                                          onPressed: () {
                                            // Scroll to the right
                                            updatescrollController1.animateTo(
                                              updatescrollController1.offset +
                                                  100.0, // Adjust the value as needed
                                              duration: const Duration(
                                                  milliseconds:
                                                      500), // Adjust the duration as needed
                                              curve: Curves.ease,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    visualDensity: const VisualDensity(
                                        horizontal: -4, vertical: -4),
                                    icon: const Icon(
                                        Icons.delete_outline_outlined),
                                    color: Colors.red,
                                    iconSize: 18,
                                    onPressed: () {
                                      setState(() {
                                        tlanguages.removeWhere(
                                            (item) => item == currentLanguage);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Subjects you teach and pricing",
                                style: TextStyle(
                                  color: kColorLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                " Required*",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: tSubjects.isNotEmpty,
                            child: SizedBox(
                              width: 680,
                              child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: tSubjects.length,
                                itemBuilder: (context, index) {
                                  SubjectTeach subjectdata = tSubjects[index];
                                  // Set the initial values for the controllers
                                  // price2Controller.text = subjectdata.price2;
                                  // price3Controller.text = subjectdata.price3;
                                  // price5Controller.text = subjectdata.price5;

                                  // Create TextEditingController instances for each TextFormField
                                  TextEditingController subjectnameController =
                                      TextEditingController();
                                  TextEditingController price2Controller =
                                      TextEditingController(
                                          text: subjectdata.price2);
                                  TextEditingController price3Controller =
                                      TextEditingController(
                                          text: subjectdata.price3);
                                  TextEditingController price5Controller =
                                      TextEditingController(
                                          text: subjectdata.price5);
                                  return subjectdata.subjectname == 'Others'
                                      ? Column(
                                          children: [
                                            Container(
                                              width: 680,
                                              height: 45,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 1)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(subjectdata.subjectname),
                                                  const Spacer(),
                                                  IconButton(
                                                    visualDensity:
                                                        const VisualDensity(
                                                            horizontal: -4,
                                                            vertical: -4),
                                                    icon: const Icon(Icons
                                                        .delete_outline_outlined),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      setState(() {
                                                        tSubjects
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 14,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 580,
                                                  height: 45,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: TextFormField(
                                                      controller:
                                                          subjectnameController,
                                                      onChanged: (value) {
                                                        if (uSubjects.contains(
                                                            subjectnameController
                                                                .text)) {
                                                          CoolAlert.show(
                                                            context: context,
                                                            type: CoolAlertType
                                                                .warning,
                                                            title: 'Oops...',
                                                            width: 200,
                                                            text:
                                                                'Subject name already in the subject list. Select the subject or enter a new name!',
                                                          );
                                                          subjectnameController
                                                              .clear();
                                                        } else {
                                                          subjectdata
                                                                  .subjectname =
                                                              value;
                                                        }
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        fillColor: Colors.grey,
                                                        hintText:
                                                            '(Input subject name)',
                                                        hintStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 14,
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 350,
                                                      height: 45,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              width: 1)),
                                                      child: const Text(
                                                          "Price for 2 classes"),
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      width: 100,
                                                      height: 45,
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 10, 0),
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromRGBO(
                                                            242, 242, 242, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            price2Controller, // Use the controller
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          fillColor:
                                                              Colors.grey,
                                                          hintText: '',
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          prefixIcon: Icon(Icons
                                                              .attach_money),
                                                        ),
                                                        keyboardType:
                                                            const TextInputType
                                                                    .numberWithOptions(
                                                                decimal: true),
                                                        validator: (val) {
                                                          if (val!.isEmpty) {
                                                            return 'Input price';
                                                          }
                                                          try {
                                                            double.parse(val);
                                                            return null; // Parsing succeeded, val is a valid double
                                                          } catch (e) {
                                                            return 'Invalid input, please enter a valid number';
                                                          }
                                                        },
                                                        onChanged: (val) {
                                                          // Update the subjectdata when the value changes
                                                          subjectdata.price2 =
                                                              val;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 350,
                                                      height: 45,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              width: 1)),
                                                      child: const Text(
                                                          "Price for 3 classes"),
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      width: 100,
                                                      height: 45,
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 10, 0),
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromRGBO(
                                                            242, 242, 242, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            price3Controller, // Use the controller
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          fillColor:
                                                              Colors.grey,
                                                          hintText: '',
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          prefixIcon: Icon(Icons
                                                              .attach_money),
                                                        ),
                                                        keyboardType:
                                                            const TextInputType
                                                                    .numberWithOptions(
                                                                decimal: true),
                                                        validator: (val) {
                                                          if (val!.isEmpty) {
                                                            return 'Input price';
                                                          }
                                                          try {
                                                            double.parse(val);
                                                            return null; // Parsing succeeded, val is a valid double
                                                          } catch (e) {
                                                            return 'Invalid input, please enter a valid number';
                                                          }
                                                        },
                                                        onChanged: (val) {
                                                          // Update the subjectdata when the value changes
                                                          subjectdata.price3 =
                                                              val;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 350,
                                                      height: 45,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              width: 1)),
                                                      child: const Text(
                                                          "Price for 5 classes"),
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      width: 100,
                                                      height: 45,
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 10, 0),
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromRGBO(
                                                            242, 242, 242, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            price5Controller, // Use the controller
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          fillColor:
                                                              Colors.grey,
                                                          hintText: '',
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          prefixIcon: Icon(Icons
                                                              .attach_money),
                                                        ),
                                                        keyboardType:
                                                            const TextInputType
                                                                    .numberWithOptions(
                                                                decimal: true),
                                                        validator: (val) {
                                                          if (val!.isEmpty) {
                                                            return 'Input price';
                                                          }
                                                          try {
                                                            double.parse(val);
                                                            return null; // Parsing succeeded, val is a valid double
                                                          } catch (e) {
                                                            return 'Invalid input, please enter a valid number';
                                                          }
                                                        },
                                                        onChanged: (val) {
                                                          // Update the subjectdata when the value changes
                                                          subjectdata.price5 =
                                                              val;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            Container(
                                              width: 680,
                                              height: 45,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 1)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(subjectdata.subjectname),
                                                  const Spacer(),
                                                  IconButton(
                                                    visualDensity:
                                                        const VisualDensity(
                                                            horizontal: -4,
                                                            vertical: -4),
                                                    icon: const Icon(Icons
                                                        .delete_outline_outlined),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      setState(() {
                                                        tSubjects
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 14,
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 350,
                                                      height: 45,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              width: 1)),
                                                      child: const Text(
                                                          "Price for 2 classes"),
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      width: 100,
                                                      height: 45,
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 10, 0),
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromRGBO(
                                                            242, 242, 242, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            price2Controller, // Use the controller
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          fillColor:
                                                              Colors.grey,
                                                          hintText: '',
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          prefixIcon: Icon(Icons
                                                              .attach_money),
                                                        ),
                                                        validator: (val) {
                                                          if (val!.isEmpty) {
                                                            return 'Input price';
                                                          }
                                                          try {
                                                            double.parse(val);
                                                            return null; // Parsing succeeded, val is a valid double
                                                          } catch (e) {
                                                            return 'Invalid input, please enter a valid number';
                                                          }
                                                        },
                                                        onChanged: (val) {
                                                          // Update the subjectdata when the value changes
                                                          subjectdata.price2 =
                                                              val;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 350,
                                                      height: 45,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              width: 1)),
                                                      child: const Text(
                                                          "Price for 3 classes"),
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      width: 100,
                                                      height: 45,
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 10, 0),
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromRGBO(
                                                            242, 242, 242, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            price3Controller, // Use the controller
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          fillColor:
                                                              Colors.grey,
                                                          hintText: '',
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          prefixIcon: Icon(Icons
                                                              .attach_money),
                                                        ),
                                                        validator: (val) {
                                                          if (val!.isEmpty) {
                                                            return 'Input price';
                                                          }
                                                          try {
                                                            double.parse(val);
                                                            return null; // Parsing succeeded, val is a valid double
                                                          } catch (e) {
                                                            return 'Invalid input, please enter a valid number';
                                                          }
                                                        },
                                                        onChanged: (val) {
                                                          // Update the subjectdata when the value changes
                                                          subjectdata.price3 =
                                                              val;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 350,
                                                      height: 45,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              width: 1)),
                                                      child: const Text(
                                                          "Price for 5 classes"),
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      width: 100,
                                                      height: 45,
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 10, 0),
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromRGBO(
                                                            242, 242, 242, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            price5Controller, // Use the controller
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          fillColor:
                                                              Colors.grey,
                                                          hintText: '',
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          prefixIcon: Icon(Icons
                                                              .attach_money),
                                                        ),
                                                        validator: (val) {
                                                          if (val!.isEmpty) {
                                                            return 'Input price';
                                                          }
                                                          try {
                                                            double.parse(val);
                                                            return null; // Parsing succeeded, val is a valid double
                                                          } catch (e) {
                                                            return 'Invalid input, please enter a valid number';
                                                          }
                                                        },
                                                        onChanged: (val) {
                                                          // Update the subjectdata when the value changes
                                                          subjectdata.price5 =
                                                              val;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                },
                              ),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            child: SizedBox(
                              width: 680,
                              height: 45,
                              child: Container(
                                width: 680,
                                height: 45,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                // decoration: BoxDecoration(
                                //     borderRadius: const BorderRadius.all(
                                //         Radius.circular(5)),
                                //     color: Colors.white,
                                //     border: Border.all(
                                //         color: Colors.grey.shade300, width: 1)),
                                child: DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    border: InputBorder.none,
                                  ),
                                  value: dropdownvaluesubject,
                                  hint: const Text("Select your subject"),
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: kColorGrey,
                                  ),
                                  items: uSubjects.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      SubjectTeach data = SubjectTeach(
                                          subjectname: newValue!,
                                          price2: '',
                                          price3: '',
                                          price5: '',
                                          subjectid: '');
                                      tSubjects.add(data);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: const [
                              Text(
                                "(You can select more than one subject you teach.)",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: const [
                              Text(
                                "What services are you able to provide?",
                                style: TextStyle(
                                  color: kColorLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                " Required, you can select more than one.*",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    width: 250,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text(
                                            'Recovery Lessons',
                                            style: TextStyle(color: kColorGrey),
                                          ),
                                          // subtitle: const Text(
                                          //     'A computer science portal for geeks.'),
                                          // secondary: const Icon(Icons.code),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: selection1,
                                          value: selection1,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            if (selection1 == true) {
                                              if (servicesprovided.contains(
                                                  'Recovery Lessons')) {
                                                servicesprovided
                                                    .remove('Recovery Lessons');
                                                setState(() {
                                                  selection1 = value!;
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                servicesprovided
                                                    .add('Recovery Lessons');
                                                selection1 = value!;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 320,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text(
                                            'Kids with Learning Difficulties',
                                            style: TextStyle(color: kColorGrey),
                                          ),
                                          // subtitle: const Text(
                                          //     'A computer science portal for geeks.'),
                                          // secondary: const Icon(Icons.code),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: selection2,
                                          value: selection2,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            if (selection2 == true) {
                                              if (servicesprovided.contains(
                                                  'Kids with Learning Difficulties')) {
                                                servicesprovided.remove(
                                                    'Kids with Learning Difficulties');
                                                setState(() {
                                                  selection2 = value!;
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                servicesprovided.add(
                                                    'Kids with Learning Difficulties');
                                                selection2 = value!;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 250,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text(
                                            'Pre Exam Classes',
                                            style: TextStyle(color: kColorGrey),
                                          ),
                                          // subtitle: const Text(
                                          //     'A computer science portal for geeks.'),
                                          // secondary: const Icon(Icons.code),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: selection3,
                                          value: selection3,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            if (selection3 == true) {
                                              if (servicesprovided.contains(
                                                  'Pre Exam Classes')) {
                                                servicesprovided
                                                    .remove('Pre Exam Classes');
                                                setState(() {
                                                  selection3 = value!;
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                servicesprovided
                                                    .add('Pre Exam Classes');
                                                selection3 = value!;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 250,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text(
                                            'Deaf Language',
                                            style: TextStyle(color: kColorGrey),
                                          ),
                                          // subtitle: const Text(
                                          //     'A computer science portal for geeks.'),
                                          // secondary: const Icon(Icons.code),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: selection4,
                                          value: selection4,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            if (selection4 == true) {
                                              if (servicesprovided
                                                  .contains('Deaf Language')) {
                                                servicesprovided
                                                    .remove('Deaf Language');
                                                setState(() {
                                                  selection4 = value!;
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                servicesprovided
                                                    .add('Deaf Language');
                                                selection4 = value!;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 250,
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: ListTileTheme(
                                        child: CheckboxListTile(
                                          title: const Text(
                                            'Own Program',
                                            style: TextStyle(color: kColorGrey),
                                          ),
                                          // subtitle: const Text(
                                          //     'A computer science portal for geeks.'),
                                          // secondary: const Icon(Icons.code),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: selection5,
                                          value: selection5,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (value) {
                                            if (selection5 == true) {
                                              if (servicesprovided
                                                  .contains('Own Program')) {
                                                servicesprovided
                                                    .remove('Own Program');
                                                setState(() {
                                                  selection5 = value!;
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                servicesprovided
                                                    .add('Own Program');
                                                selection5 = value!;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // const SizedBox(
                          //   height: 50,
                          // ),
                          // Row(
                          //   children: const [
                          //     Text(
                          //       "Type of classes you can offer.",
                          //       style: TextStyle(
                          //         color: Color.fromRGBO(0, 0, 0, 1),
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 18,
                          //       ),
                          //       textAlign: TextAlign.left,
                          //     ),
                          //     Text(
                          //       "Required, you can select morethan one.*",
                          //       style: TextStyle(
                          //         color: Colors.redAccent,
                          //         fontWeight: FontWeight.normal,
                          //         fontSize: 12,
                          //         fontStyle: FontStyle.italic,
                          //       ),
                          //       textAlign: TextAlign.left,
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Row(
                          //   children: [
                          //     Container(
                          //       width: 250,
                          //       height: 45,
                          //       alignment: Alignment.centerLeft,
                          //       child: Theme(
                          //         data: ThemeData(
                          //           checkboxTheme: CheckboxThemeData(
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(10),
                          //             ),
                          //           ),
                          //         ),
                          //         child: ListTileTheme(
                          //           child: CheckboxListTile(
                          //             title: const Text('Online Classes'),
                          //             // subtitle: const Text(
                          //             //     'A computer science portal for geeks.'),
                          //             // secondary: const Icon(Icons.code),
                          //             autofocus: false,
                          //             activeColor: Colors.green,
                          //             checkColor: Colors.white,
                          //             selected: onlineclas,
                          //             value: onlineclas,
                          //             controlAffinity:
                          //                 ListTileControlAffinity.leading,
                          //             onChanged: (value) {
                          //               setState(() {
                          //                 onlineclas = value!;
                          //               });
                          //             },
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     Container(
                          //       width: 320,
                          //       height: 45,
                          //       alignment: Alignment.centerLeft,
                          //       child: Theme(
                          //         data: ThemeData(
                          //           checkboxTheme: CheckboxThemeData(
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(10),
                          //             ),
                          //           ),
                          //         ),
                          //         child: ListTileTheme(
                          //           child: CheckboxListTile(
                          //             title: const Text('In Person Classes'),
                          //             // subtitle: const Text(
                          //             //     'A computer science portal for geeks.'),
                          //             // secondary: const Icon(Icons.code),
                          //             autofocus: false,
                          //             activeColor: Colors.green,
                          //             checkColor: Colors.white,
                          //             selected: inperson,
                          //             value: inperson,
                          //             controlAffinity:
                          //                 ListTileControlAffinity.leading,
                          //             onChanged: (value) {
                          //               setState(() {
                          //                 inperson = value!;
                          //               });
                          //             },
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Upload your documents.",
                                style: TextStyle(
                                  color: kColorLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "ID and Picture required, CV, certification\nand presentation recommended*",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                width: 180,
                                height: 55,
                                child: TextButton(
                                  // style: TextButton.styleFrom(
                                  //   textStyle:
                                  //       const TextStyle(color: Colors.black),
                                  //   backgroundColor:
                                  //       const Color.fromRGBO(103, 195, 208, 1),
                                  //   shape: RoundedRectangleBorder(
                                  //     side: const BorderSide(
                                  //       color: Color.fromRGBO(
                                  //           1, 118, 132, 1), // your color here
                                  //       width: 1,
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(30.0),
                                  //   ),
                                  // ),
                                  onPressed: () async {
                                    selectImagesID();
                                  },
                                  child: const Text(
                                    'Upload ID',
                                    style: TextStyle(
                                        color: kColorPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              idfilenames.isNotEmpty
                                  ? Container(
                                      width: 400,
                                      height: 55,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            iconSize: 15,
                                            icon: const Icon(
                                              Icons
                                                  .arrow_back_ios, // Left arrow icon
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              // Scroll to the left
                                              _scrollController.animateTo(
                                                _scrollController.offset -
                                                    100.0, // Adjust the value as needed
                                                duration: const Duration(
                                                    milliseconds:
                                                        500), // Adjust the duration as needed
                                                curve: Curves.ease,
                                              );
                                            },
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              controller:
                                                  _scrollController, // Assign the ScrollController to the ListView
                                              scrollDirection: Axis.horizontal,
                                              itemCount: idfilenames.length,
                                              itemBuilder: (context, index) {
                                                Color color = vibrantColors[
                                                    index %
                                                        vibrantColors.length];

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 5, 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  15)),
                                                      color: color,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            idfilenames[index]),
                                                        IconButton(
                                                          iconSize: 15,
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              idfilenames
                                                                  .removeAt(
                                                                      index);
                                                              selectedIDfiles
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            iconSize: 15,
                                            icon: const Icon(
                                              Icons
                                                  .arrow_forward_ios, // Right arrow icon
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              // Scroll to the right
                                              _scrollController.animateTo(
                                                _scrollController.offset +
                                                    100.0, // Adjust the value as needed
                                                duration: const Duration(
                                                    milliseconds:
                                                        500), // Adjust the duration as needed
                                                curve: Curves.ease,
                                              );
                                            },
                                          ),
                                        ],
                                      ))
                                  : Container(
                                      width: 400,
                                      height: 55,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: const Center(
                                        child: Text(
                                          '"You can upload front and back of ID."',
                                          style: TextStyle(color: kColorGrey),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                width: 180,
                                height: 55,
                                child: TextButton(
                                  // style: TextButton.styleFrom(
                                  //   textStyle:
                                  //       const TextStyle(color: Colors.black),
                                  //   backgroundColor:
                                  //       const Color.fromRGBO(103, 195, 208, 1),
                                  //   shape: RoundedRectangleBorder(
                                  //     side: const BorderSide(
                                  //       color: Color.fromRGBO(
                                  //           1, 118, 132, 1), // your color here
                                  //       width: 1,
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(30.0),
                                  //   ),
                                  // ),
                                  onPressed: () {
                                    selectResumes();
                                  },
                                  child: const Text(
                                    'Upload CV/Resmue',
                                    style: TextStyle(
                                        color: kColorPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              resumefilenames.isNotEmpty
                                  ? Container(
                                      width: 400,
                                      height: 55,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            iconSize: 15,
                                            icon: const Icon(
                                              Icons
                                                  .arrow_back_ios, // Left arrow icon
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              // Scroll to the left
                                              _scrollController1.animateTo(
                                                _scrollController1.offset -
                                                    100.0, // Adjust the value as needed
                                                duration: const Duration(
                                                    milliseconds:
                                                        500), // Adjust the duration as needed
                                                curve: Curves.ease,
                                              );
                                            },
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              controller:
                                                  _scrollController1, // Assign the ScrollController to the ListView
                                              scrollDirection: Axis.horizontal,
                                              itemCount: resumefilenames.length,
                                              itemBuilder: (context, index) {
                                                Color color = vibrantColors[
                                                    index %
                                                        vibrantColors.length];

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 5, 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  15)),
                                                      color: color,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(resumefilenames[
                                                            index]),
                                                        IconButton(
                                                          iconSize: 15,
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              resumefilenames
                                                                  .removeAt(
                                                                      index);
                                                              selectedresume
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            iconSize: 15,
                                            icon: const Icon(
                                              Icons
                                                  .arrow_forward_ios, // Right arrow icon
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              // Scroll to the right
                                              _scrollController1.animateTo(
                                                _scrollController1.offset +
                                                    100.0, // Adjust the value as needed
                                                duration: const Duration(
                                                    milliseconds:
                                                        500), // Adjust the duration as needed
                                                curve: Curves.ease,
                                              );
                                            },
                                          ),
                                        ],
                                      ))
                                  : Container(
                                      width: 400,
                                      height: 55,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: const Center(
                                        child: Text(
                                          '"You can upload more than one resume."',
                                          style: TextStyle(color: kColorGrey),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                width: 180,
                                height: 55,
                                child: TextButton(
                                  // style: TextButton.styleFrom(
                                  //   textStyle:
                                  //       const TextStyle(color: Colors.black),
                                  //   backgroundColor:
                                  //       const Color.fromRGBO(103, 195, 208, 1),
                                  //   shape: RoundedRectangleBorder(
                                  //     side: const BorderSide(
                                  //       color: Color.fromRGBO(
                                  //           1, 118, 132, 1), // your color here
                                  //       width: 1,
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(30.0),
                                  //   ),
                                  // ),
                                  onPressed: () {
                                    selectCertificates();
                                  },
                                  child: const Text(
                                    'Upload Certicates',
                                    style: TextStyle(
                                        color: kColorPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              certificatesfilenames.isNotEmpty
                                  ? Container(
                                      width: 400,
                                      height: 55,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            iconSize: 15,
                                            icon: const Icon(
                                              Icons
                                                  .arrow_back_ios, // Left arrow icon
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              // Scroll to the left
                                              _scrollController2.animateTo(
                                                _scrollController2.offset -
                                                    100.0, // Adjust the value as needed
                                                duration: const Duration(
                                                    milliseconds:
                                                        500), // Adjust the duration as needed
                                                curve: Curves.ease,
                                              );
                                            },
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              controller:
                                                  _scrollController2, // Assign the ScrollController to the ListView
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  certificatesfilenames.length,
                                              itemBuilder: (context, index) {
                                                Color color = vibrantColors[
                                                    index %
                                                        vibrantColors.length];

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 5, 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  15)),
                                                      color: color,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            certificatesfilenames[
                                                                index]),
                                                        IconButton(
                                                          iconSize: 15,
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              certificatesfilenames
                                                                  .removeAt(
                                                                      index);
                                                              selectedCertificates
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            iconSize: 15,
                                            icon: const Icon(
                                              Icons
                                                  .arrow_forward_ios, // Right arrow icon
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              // Scroll to the right
                                              _scrollController2.animateTo(
                                                _scrollController2.offset +
                                                    100.0, // Adjust the value as needed
                                                duration: const Duration(
                                                    milliseconds:
                                                        500), // Adjust the duration as needed
                                                curve: Curves.ease,
                                              );
                                            },
                                          ),
                                        ],
                                      ))
                                  : Container(
                                      width: 400,
                                      height: 55,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: const Center(
                                        child: Text(
                                          '"You can upload morethan one certificate."',
                                          style: TextStyle(color: kColorGrey),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Container(
                          //       padding:
                          //           const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          //       width: 180,
                          //       height: 55,
                          //       child: TextButton(
                          //         // style: TextButton.styleFrom(
                          //         //   textStyle:
                          //         //       const TextStyle(color: Colors.black),
                          //         //   backgroundColor:
                          //         //       const Color.fromRGBO(103, 195, 208, 1),
                          //         //   shape: RoundedRectangleBorder(
                          //         //     side: const BorderSide(
                          //         //       color: Color.fromRGBO(
                          //         //           1, 118, 132, 1), // your color here
                          //         //       width: 1,
                          //         //     ),
                          //         //     borderRadius: BorderRadius.circular(30.0),
                          //         //   ),
                          //         // ),
                          //         onPressed: () {
                          //           selectVideos();
                          //         },
                          //         child: const Text(
                          //           'Upload Video',
                          //           style: TextStyle(
                          //               color: kColorPrimary,
                          //               fontSize: 16,
                          //               fontWeight: FontWeight.bold),
                          //         ),
                          //       ),
                          //     ),
                          //     const Spacer(),
                          //     videoFilenames.isNotEmpty
                          //         ? Container(
                          //             width: 400,
                          //             height: 55,
                          //             padding: const EdgeInsets.fromLTRB(
                          //                 10, 0, 10, 0),
                          //             child: Row(
                          //               children: [
                          //                 IconButton(
                          //                   iconSize: 15,
                          //                   icon: const Icon(
                          //                     Icons
                          //                         .arrow_back_ios, // Left arrow icon
                          //                     color: Colors.blue,
                          //                   ),
                          //                   onPressed: () {
                          //                     // Scroll to the left
                          //                     _scrollController3.animateTo(
                          //                       _scrollController3.offset -
                          //                           100.0, // Adjust the value as needed
                          //                       duration: const Duration(
                          //                           milliseconds:
                          //                               500), // Adjust the duration as needed
                          //                       curve: Curves.ease,
                          //                     );
                          //                   },
                          //                 ),
                          //                 Expanded(
                          //                   child: ListView.builder(
                          //                     controller:
                          //                         _scrollController3, // Assign the ScrollController to the ListView
                          //                     scrollDirection: Axis.horizontal,
                          //                     itemCount: videoFilenames.length,
                          //                     itemBuilder: (context, index) {
                          //                       Color color = vibrantColors[
                          //                           index %
                          //                               vibrantColors.length];

                          //                       return Padding(
                          //                         padding:
                          //                             const EdgeInsets.only(
                          //                                 left: 10.0,
                          //                                 right: 10),
                          //                         child: Container(
                          //                           padding: const EdgeInsets
                          //                               .fromLTRB(5, 0, 5, 0),
                          //                           decoration: BoxDecoration(
                          //                             borderRadius:
                          //                                 const BorderRadius
                          //                                         .all(
                          //                                     Radius.circular(
                          //                                         15)),
                          //                             color: color,
                          //                           ),
                          //                           child: Row(
                          //                             mainAxisAlignment:
                          //                                 MainAxisAlignment
                          //                                     .spaceBetween,
                          //                             children: [
                          //                               Text(videoFilenames[
                          //                                   index]),
                          //                               IconButton(
                          //                                 iconSize: 15,
                          //                                 icon: const Icon(
                          //                                   Icons.delete,
                          //                                   color: Colors.red,
                          //                                 ),
                          //                                 onPressed: () {
                          //                                   setState(() {
                          //                                     videoFilenames
                          //                                         .removeAt(
                          //                                             index);
                          //                                     selectedVideos
                          //                                         .removeAt(
                          //                                             index);
                          //                                   });
                          //                                 },
                          //                               ),
                          //                             ],
                          //                           ),
                          //                         ),
                          //                       );
                          //                     },
                          //                   ),
                          //                 ),
                          //                 IconButton(
                          //                   iconSize: 15,
                          //                   icon: const Icon(
                          //                     Icons
                          //                         .arrow_forward_ios, // Right arrow icon
                          //                     color: Colors.blue,
                          //                   ),
                          //                   onPressed: () {
                          //                     // Scroll to the right
                          //                     _scrollController3.animateTo(
                          //                       _scrollController3.offset +
                          //                           100.0, // Adjust the value as needed
                          //                       duration: const Duration(
                          //                           milliseconds:
                          //                               500), // Adjust the duration as needed
                          //                       curve: Curves.ease,
                          //                     );
                          //                   },
                          //                 ),
                          //               ],
                          //             ))
                          //         : Container(
                          //             width: 400,
                          //             height: 55,
                          //             padding: const EdgeInsets.fromLTRB(
                          //                 10, 0, 10, 0),
                          //             child: const Center(
                          //               child: Text(
                          //                 '"You can upload morethan one video."',
                          //                 style: TextStyle(color: kColorGrey),
                          //               ),
                          //             ),
                          //           )
                          //   ],
                          // ),

                          const SizedBox(
                            height: 30,
                          ),
                          Column(
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Describe your skills, your approach, your teaching method, and tell',
                                    style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'us why a student should choose you! (max 5000 characters)',
                                    style: TextStyle(
                                      color: kColorLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "Required.*",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            child: Container(
                              width: 680,
                              height: 350,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              // decoration: BoxDecoration(
                              //     borderRadius:
                              //         const BorderRadius.all(Radius.circular(5)),
                              //     color: Colors.white,
                              //     border: Border.all(
                              //         color: Colors.grey.shade300, width: 1)),
                              child: TextFormField(
                                controller: aboutme,
                                textAlignVertical: TextAlignVertical.top,
                                maxLines: null,
                                expands: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.grey,
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    color: kColorGrey,
                                    inherit: true,
                                  ),
                                  alignLabelWithHint: true,
                                  hintMaxLines: 10,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: CheckboxListTile(
                              title: const Text(
                                'Agree to Work4uTutor Terms & Condition and Privacy Policy.',
                                style: TextStyle(fontSize: 15),
                              ),
                              // subtitle: const Text(
                              //     'A computer science portal for geeks.'),
                              // secondary: const Icon(Icons.code),
                              autofocus: false,
                              activeColor: Colors.green,
                              checkColor: Colors.white,
                              selected: termStatus,
                              value: termStatus,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value) async {
                                dynamic accept = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      var height =
                                          MediaQuery.of(context).size.height;
                                      var width =
                                          MediaQuery.of(context).size.width;
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              15.0), // Adjust the radius as needed
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        content: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              15.0), // Same radius as above
                                          child: Container(
                                            color: Colors
                                                .white, // Set the background color of the circular content

                                            child: Stack(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: height,
                                                  width: 900,
                                                  child: const TermPage(
                                                    pdfurl: '',
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 10.0,
                                                  right: 10.0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).pop(
                                                          false); // Close the dialog
                                                    },
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });

                                setState(() {
                                  if (accept != null) {
                                    termStatus = accept;
                                  }
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            width: 380,
                            height: 75,
                            child: TextButton(
                              // style: TextButton.styleFrom(
                              //   textStyle: const TextStyle(color: Colors.black),
                              //   backgroundColor:
                              //       const Color.fromRGBO(103, 195, 208, 1),
                              //   shape: RoundedRectangleBorder(
                              //     side: const BorderSide(
                              //       color: Color.fromRGBO(
                              //           1, 118, 132, 1), // your color here
                              //       width: 1,
                              //     ),
                              //     borderRadius: BorderRadius.circular(40.0),
                              //   ),
                              // ),
                              onPressed: () async {
                                // if (filename == '' ||
                                //     firstname.text == '' ||
                                //     lastname.text == '' ||
                                //     selectedDate != DateTime.now() ||
                                //     age != 0 ||
                                //     selectedCountry == '' ||
                                //     tCity.text == '' ||
                                //     selectedbirthCountry == '' ||
                                //     birthtCity.text == '' ||
                                //     _selectedTimeZone.text == '' ||
                                //     // phoneNumberController.text == '' ||
                                //     tlanguages.isEmpty ||
                                //     tSubjects.isEmpty ||
                                //     idfilenames.isEmpty ||
                                //     resumefilenames.isEmpty ||
                                //     certificatesfilenames.isEmpty ||
                                //     videoFilenames.isEmpty ||
                                //     aboutme.text == '') {
                                //   CoolAlert.show(
                                //     context: context,
                                //     width: 200,
                                //     type: CoolAlertType.error,
                                //     text: "Please input data requireds!",
                                //   );
                                // } else
                                if (aboutme.text == '') {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Please input about yourself!",
                                  );
                                }
                                // else if (videoFilenames.isEmpty) {
                                //   CoolAlert.show(
                                //     context: context,
                                //     width: 200,
                                //     type: CoolAlertType.error,
                                //     text: "Video presentations Required!",
                                //   );
                                // }
                                else if (filename.isEmpty) {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Profile picture Required!",
                                  );
                                } else if (certificatesfilenames.isEmpty) {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Certificates Required!",
                                  );
                                } else if (resumefilenames.isEmpty) {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Resume/CV Required!",
                                  );
                                } else if (idfilenames.isEmpty) {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Valid ID's Required!",
                                  );
                                } else if (tSubjects.isEmpty) {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Subjects to teach Required!",
                                  );
                                } else if (tlanguages.isEmpty) {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Languages Required!",
                                  );
                                } else if (_selectedTimeZone.text == '') {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Timezone Required!",
                                  );
                                } else if (selectedGender == '') {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Gender Required!",
                                  );
                                } else if (citizenship.isEmpty) {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Citizenship Required!",
                                  );
                                }
                                // else if (birthtCity.text == '') {
                                //   CoolAlert.show(
                                //     context: context,
                                //     width: 200,
                                //     type: CoolAlertType.error,
                                //     text: "City of birth Required!",
                                //   );
                                // } else if (selectedbirthCountry == '') {
                                //   CoolAlert.show(
                                //     context: context,
                                //     width: 200,
                                //     type: CoolAlertType.error,
                                //     text: "Country of birth Required!",
                                //   );
                                // }
                                else if (tCity.text == '') {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "City of residence Required!",
                                  );
                                } else if (selectedCountry == '') {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Country of residence Required!",
                                  );
                                } else if (termStatus == false) {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Please accept terms & conditions!",
                                  );
                                } else if (age == 0) {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Age Required!",
                                  );
                                } else if (selectedDate == DateTime.now()) {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Date of Birth Required!",
                                  );
                                } else if (firstname.text == '') {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Firstname Required!",
                                  );
                                } else if (lastname.text == '') {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Lastname Required!",
                                  );
                                } else if (selection1 == false &&
                                    selection2 == false &&
                                    selection3 == false &&
                                    selection4 == false &&
                                    selection5 == false) {
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.error,
                                    text: "Service you provide Required!",
                                  );
                                } else {
                                  CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      barrierDismissible: false,
                                      type: CoolAlertType.loading,
                                      text: 'Uploading your data....');
                                  String? data = await uploadTutorProfile(
                                    widget.uid,
                                    selectedImage!,
                                    filename,
                                  );
                                  List<String?> idlinks =
                                      await uploadTutorProfileList(widget.uid,
                                          'ID', selectedIDfiles, idfilenames);
                                  List<String?> resumelinks =
                                      await uploadTutorresumeList(
                                          widget.uid,
                                          'Resume',
                                          selectedresume,
                                          resumefilenames);
                                  List<String?> certificatelinks =
                                      await uploadTutorcertificateList(
                                          widget.uid,
                                          'Certificates',
                                          selectedCertificates,
                                          certificatesfilenames);
                                  // List<String?> videolinks =
                                  //     await uploadTutorvideoList(
                                  //         widget.uid,
                                  //         'Videos',
                                  //         selectedVideos,
                                  //         videoFilenames);
                                  String? result = await updateTutorInformation(
                                      widget.uid,
                                      selectedGender,
                                      citizenship,
                                      tCity.text,
                                      selectedCountry,
                                      selectedbirthCountry,
                                      birthtCity.text,
                                      tCity.text,
                                      firstname.text,
                                      middlename.text,
                                      lastname.text,
                                      tlanguages,
                                      tutorIDNumber,
                                      widget.uid,
                                      phoneNumber.phoneNumber.toString(),
                                      DateTime.now(),
                                      age.toString(),
                                      selectedDate,
                                      _selectedTimeZone.text,
                                      applicantsID,
                                      tSubjects,
                                      'completed',
                                      aboutme.text,
                                      data!,
                                      certificatelinks.isEmpty
                                          ? []
                                          : certificatelinks,
                                      certificatesfilenamestype.isEmpty
                                          ? []
                                          : certificatesfilenamestype,
                                      resumelinks.isEmpty ? [] : resumelinks,
                                      resumefilenamestype.isEmpty
                                          ? []
                                          : resumefilenamestype,
                                      [],
                                      // videolinks.isEmpty ? [] : videolinks,
                                      idlinks.isEmpty ? [] : idlinks,
                                      idfilenamestype.isEmpty
                                          ? []
                                          : idfilenamestype,
                                      servicesprovided);
                                  if (result == 'success') {
                                    dynamic result = await _auth.signOutAnon();
                                    SendWelcomeEmailtoUser.sendMail(
                                          email: widget.email,
                                          name: firstname.text);
                                    deleteAllData();

                                    setState(() {
                                      CoolAlert.show(
                                        context: context,
                                        width: 200,
                                        type: CoolAlertType.success,
                                        text: 'Sign up succesfully!',
                                        autoCloseDuration:
                                            const Duration(seconds: 1),
                                      ).then((value) {
                                        GoRouter.of(context).go('/');
                                      });
                                    });
                                  } else {
                                    CoolAlert.show(
                                      context: context,
                                      width: 200,
                                      type: CoolAlertType.error,
                                      text: result.toString(),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                'Proceed Now',
                                style: TextStyle(
                                    color: kColorPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//Display all the Countries
  _buildCountryPickerDropdownSoloExpanded() {
    String valueme = "Select your Country";
    return CountryPickerDropdown(
      hint: const Text("Select your Country"),
      // initialValue: valueme,
      onValuePicked: (Country country) {
        valueme = country.toString();
        setState(() {
          // _initData();
        });
      },
      itemBuilder: (Country country) {
        return Row(
          children: <Widget>[
            Expanded(child: Text(country.name)),
          ],
        );
      },
      itemHeight: 50,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
    );
  }

  void deleteAllData() async {
    final box = await Hive.openBox('userID');
    await box.clear();
  }

  // ignore: prefer_function_declarations_over_variables
  final languageBuilder = (language) => Text(language.name);

  Widget _buildDropdownItem(Country country) => Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              const SizedBox(
                width: 8.0,
              ),
              Text(country.name),
            ],
          ),
        ],
      );
}
//Identifies the device timezone and datetime
// Future<void> setup() async {
//   // var dtf = js.context['Intl'].callMethod('DateTimeFormat');
//   // var ops = dtf.callMethod('resolvedOptions');
//   // print(ops['timeZone']);
//   tz.initializeTimeZone();
//   var response = tz.timeZoneDatabase;
//   Map data = jsonDecode(response as String);
//   // var istanbulTimeZone = tz.getLocation(ops['timeZone']);
//   // var now = tz.TZDateTime.now(istanbulTimeZone);
//   print(data);
// }
