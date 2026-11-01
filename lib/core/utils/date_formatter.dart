import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static const String _dayMonth = 'd MMM';
  static const String _dayMonthTime = 'd MMM · HH:mm';

  static String dayMonth(DateTime value, String locale) =>
      DateFormat(_dayMonth, locale).format(value.toLocal());

  static String dayMonthTime(DateTime value, String locale) =>
      DateFormat(_dayMonthTime, locale).format(value.toLocal());
}
