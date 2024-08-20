import 'package:intl/intl.dart';
import 'package:timezone/browser.dart' as tz;

DateTime formatTime(String timeselected) {
  String inputTime = timeselected;

  const String datePart = 'August 6, 2024';

  String dateTimeStr = '$datePart $inputTime';

  DateFormat inputFormat = DateFormat('MMMM d, yyyy h:mm a');
  DateTime dateTime = inputFormat.parse(dateTimeStr);

  const String targetTimeZone = 'Asia/Manila';

  final tz.Location targetLocation = tz.getLocation(targetTimeZone);

  // Convert to target timezone
  final tz.TZDateTime targetTzTime =
      tz.TZDateTime.from(dateTime, targetLocation);

  final DateTime formattedTimestamp = targetTzTime;

  return formattedTimestamp;
}

DateTime formatTimewDate(String date, String timeselected) {
  String inputTime = timeselected;
  print(timeselected);
  const String datePart = 'August 6, 2024';

  String dateTimeStr = '$date $inputTime';

  DateFormat inputFormat = DateFormat('MMMM d, yyyy h:mm a');
  DateTime dateTime = inputFormat.parse(dateTimeStr);

  const String targetTimeZone = 'Asia/Manila';

  final tz.Location targetLocation = tz.getLocation(targetTimeZone);

  // Convert to target timezone
  final tz.TZDateTime targetTzTime =
      tz.TZDateTime.from(dateTime, targetLocation);

  final DateTime formattedTimestamp = targetTzTime;

  return formattedTimestamp;
}

DateTime formatTimewDatewZone(String date, timezone) {
  String dateTimeStr = date;

  DateFormat inputFormat = DateFormat('MMMM d, yyyy h:mm a');
  DateTime dateTime = inputFormat.parse(dateTimeStr);

  String targetTimeZone = timezone;

  final tz.Location targetLocation = tz.getLocation(targetTimeZone);

  // Convert to target timezone
  final tz.TZDateTime targetTzTime =
      tz.TZDateTime.from(dateTime, targetLocation);

  final DateTime formattedTimestamp = targetTzTime;

  return formattedTimestamp;
}

DateTime createTimeWithDateAndZone(String date, String timezone, String time) {
  try {
    // Combine the date and time into a single string
    String dateTimeStr = '$date $time';

    // Define the input format for the combined date and time
    DateFormat inputFormat = DateFormat('MMMM d, yyyy h:mm a');

    // Parse the combined date and time string into a DateTime object
    DateTime dateTime = inputFormat.parse(dateTimeStr);

    // Get the target timezone location
    final tz.Location targetLocation = tz.getLocation(timezone);
    print(targetLocation);
    // Create a TZDateTime using the target location without converting
    final tz.TZDateTime tzDateTime = tz.TZDateTime(
      targetLocation,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );
    final DateTime formattedTimestamp = tzDateTime;
    return formattedTimestamp;
  } catch (e) {
    print(e);
    return DateTime.now();
  }
}
