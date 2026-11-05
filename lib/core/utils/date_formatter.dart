import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static const String _dayMonth = 'd MMM';
  static const String _dayMonthTime = 'd MMM · HH:mm';
  static const String _time = 'HH:mm';
  static const String _weekday = 'EEE';
  static const String _day = 'd';

  static String dayMonth(DateTime value, String locale) =>
      DateFormat(_dayMonth, locale).format(value.toLocal());

  static String dayMonthTime(DateTime value, String locale) =>
      DateFormat(_dayMonthTime, locale).format(value.toLocal());

  static String time(DateTime value, String locale) =>
      DateFormat(_time, locale).format(value.toLocal());

  static String weekday(DateTime value, String locale) =>
      DateFormat(_weekday, locale).format(value.toLocal());

  static String day(DateTime value, String locale) =>
      DateFormat(_day, locale).format(value.toLocal());
}
