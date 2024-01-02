// ignore_for_file: empty_catches

import 'dart:convert';
import 'package:http/http.dart' as http;

class SendEmailService {
  static sendMail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try{
    var endPointUrl = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    var response = await http.post(
      endPointUrl,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
        'service_id': 'service_wlllg2y',
        'template_id': 'template_8dcdxpg',
        'user_id': 'sAaiMSlffCYzPDOCa',
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_subject': subject,
          'user_message': message,
        }
      }
      ),
    );
    if (response.statusCode == 200){
    }else{
    }
    }catch(e){
    }
  }
}

class SendEmailtoadmin {
  static sendMail({
    required String name,
    required String email,
    required String message,
  }) async {
    try{
    var endPointUrl = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    var response = await http.post(
      endPointUrl,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
        'service_id': 'service_wlllg2y',
        'template_id': 'template_gdnslk7',
        'user_id': 'sAaiMSlffCYzPDOCa',
        'template_params': {
          'from_name': name,
          'to_email': email,
          'message': message,
        }
      }
      ),
    );
    if (response.statusCode == 200){
    }else{
    }
    }catch(e){
    }
  }
}




