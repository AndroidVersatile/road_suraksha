import 'package:intl/intl.dart';

class DatesUtils {

  static DateTime convertDateTime(date) {
    String? timestampStr = date.substring(6, date.length - 2);
    int timestampMs = int.parse(timestampStr!);

    // Converting milliseconds since epoch to DateTime
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(timestampMs);

    print(dateTime);
    return dateTime;


  }




  static String getFormattedDateFromDateTime(DateTime date) {
    date = date.toLocal();
    return "${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(date).replaceAll(",", "")}, ${DateFormat(DateFormat.HOUR_MINUTE).format(date)}";
  }

  static String getFormattedDateOnly(DateTime date) {
    return DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(date);
  }

  static String getFormattedDateMonthOnly(DateTime date) {
    return "${DateFormat(DateFormat.DAY).format(date)}-${DateFormat(DateFormat.NUM_MONTH).format(date)}-${DateFormat(DateFormat.YEAR).format(date)}";
  }

  static String getFormattedHoursTimeOnly(DateTime date) {
    return DateFormat(DateFormat.HOUR_MINUTE).format(date);
  }

  static String getDiffrenceInMin(DateTime startTime, DateTime endTime) {
    return "${endTime.difference(startTime).inMinutes} Min";
  }

  static String getDiffrenceAnalyseInMin(DateTime startTime, DateTime endTime) {
    return "${endTime.difference(startTime).inMinutes}";
  }

  static getDiffrenceInSec(DateTime startTime, DateTime endTime) {
    if (startTime.isBefore(endTime)) {
      return endTime.difference(startTime).inSeconds;
    }
    return 0;
  }

  static String getMonthFromDate(DateTime date) {
    return date.month.toString();
  }

  static MonthYear getMonthYearFromDate(DateTime date) {
    return MonthYear(date.year + date.month,
        DateFormat(DateFormat.YEAR_ABBR_MONTH).format(date));
  }

  static String getMonthNameFromDate(DateTime date) {
    return DateFormat(DateFormat.ABBR_MONTH).format(date);
  }

  static String getMinFromDate(DateTime date) {
    return DateFormat(DateFormat.MINUTE).format(date);
  }

  static bool isInBetweenMonth(int startMonth, int endMonth, DateTime date) {
    return ((startMonth >= date.month) && (date.month <= endMonth));
  }

  static DateTime getDateFromString(String date) {
    var d = DateTime.tryParse(date) ?? DateTime.now();

    return d;
  }

  static String getGraphDate(String date) {
    try {
      var d = DateTime.parse(date);

      return DateFormat(DateFormat.ABBR_MONTH_DAY).format(d);
    } catch (e) {
      return "0";
    }
  }
}

class MonthYear {
  int value;
  String label;

  MonthYear(this.value, this.label);

  @override
  String toString() {
    return label;
  }

  @override
  bool operator ==(Object other) {
    other.toString();
    return label == other;
  }
}
