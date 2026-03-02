import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  String toOrdinalString() {
    String suffix = 'th';
    final digit = day % 10;
    if ((digit > 0 && digit < 4) && (day < 11 || day > 13)) {
      suffix = ['st', 'nd', 'rd'][digit - 1];
    }
    return '$day$suffix ${DateFormat('MMM yyyy').format(this)}';
  }
}
