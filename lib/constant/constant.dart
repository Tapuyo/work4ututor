
import 'package:flutter/material.dart';
const runas = 'prod';

const firebaseApiKey = 'AIzaSyAn-thO0sOzHRadg_F51lMd9nOHleBmvyo';
const firebaseAppId = '1:855430775722:web:b8ef6dc3978f6e025ae1d3';
const firebaseMessagingSenderId = '855430775722';
const firebaseProjectId = 'workforyou-7c3b7';
const storageBucket = 'gs://workforyou-7c3b7.appspot.com';

const firebaseConfig = {
  'apiKey': "AIzaSyALA0tuTG0G3q9GtSL_Rn6SmGka4FIeyGU",
  'authDomain': "work4ututordev.firebaseapp.com",
  'projectId': "work4ututordev",
  'storageBucket': "gs://work4ututordev.appspot.com",
  'messagingSenderId': "352539095451",
  'appId': "1:352539095451:web:aa45f7bc3534fe49d3313e"
};

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.black87,
  backgroundColor: Colors.grey[300],
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);
const kFontColorPallets = [
  Color.fromRGBO(26, 31, 56, 1),
  Color.fromRGBO(72, 76, 99, 1),
  Color.fromRGBO(149, 149, 163, 1),
];
const kBorderRadius = 10.0;
const kSpacing = 20.0;