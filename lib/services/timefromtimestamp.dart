import 'package:intl/intl.dart';
import 'package:timezone/browser.dart' as tz;

String updateTime(String timezone, String dateToConvert) {
  final dateFormat = DateFormat('MMMM dd, yyyy h:mm a');

  DateTime convertedDate = DateTime.parse(dateToConvert);
  final targetTimeZone = tz.getLocation(timezone);

  final tzDateTime = tz.TZDateTime.from(convertedDate, targetTimeZone);

  return DateFormat('h:mm a').format(tzDateTime);
}
