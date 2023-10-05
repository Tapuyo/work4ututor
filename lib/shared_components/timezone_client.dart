import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data_class/timezone.dart';

class TimezoneClient {
  Future<String> getTimezone() async {
    final response =
        await http.get(Uri.parse('http://worldtimeapi.org/api/timezone'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the timezone from the JSON data.
      final List<dynamic> timezones = json.decode(response.body);
      if (timezones.isNotEmpty) {
        // Assuming you want the first timezone in the list.
        return timezones[0];
      } else {
        throw Exception('No timezones found');
      }
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception with the status code and message.
      throw Exception('Failed to load timezone: ${response.statusCode}');
    }
  }
}
