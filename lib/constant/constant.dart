
import 'package:flutter/material.dart';

const firebaseApiKey = 'AIzaSyAn-thO0sOzHRadg_F51lMd9nOHleBmvyo';
const firebaseAppId = '1:855430775722:web:b8ef6dc3978f6e025ae1d3';
const firebaseMessagingSenderId = '855430775722';
const firebaseProjectId = 'workforyou-7c3b7';

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);