import 'package:intl/intl.dart';

class CustomDateUtils {
  static String getStringFromDate(DateTime? dateTime) {
    if (dateTime == null) {
      return "Invalid date";
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  static DateTime getDateFromString(String stringDate) {
    return DateFormat('dd/MM/yyyy').parse(stringDate);
  }

  static DateTime? getDateFromStringForJson(String stringDate) {
    try {
      return DateFormat('yyyy-MM-ddTHH:mm:ss').parse(stringDate);
    } catch (e) {
      return null;
    }
  }

  static String? getStringFromDateForJson(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
    }

    return null;
  }
}
