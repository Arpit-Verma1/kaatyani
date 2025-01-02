import 'package:intl/intl.dart';

class DateTimeUtil {
  static String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
  }
  static String formatTimestampToTime(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final formattedTime = DateFormat('h a').format(dateTime); // Formats time as "11 AM"
      return formattedTime;
    } catch (e) {
      print('Error parsing timestamp: $e');
      return 'Invalid time';
    }
  }
}
