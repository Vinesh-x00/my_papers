import 'dart:convert';

import 'package:crypto/crypto.dart';

///Retrive {Sunday - next Saturday} range to given date
(DateTime, DateTime) getWeekRange(DateTime date) {
  final weekday = date.weekday;

  final daysSinceSunday = weekday == 7 ? 0 : weekday;
  final daysUntilSaturday = 6 - daysSinceSunday;

  final startDate = date.subtract(Duration(days: daysSinceSunday));

  final endDate = date.add(Duration(days: daysUntilSaturday));

  final startOfDay = DateTime(startDate.year, startDate.month, startDate.day);
  final endOfDay =
      DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

  return (startOfDay, endOfDay);
}

/// Convert [DateTime] to string date
String formatDate({required DateTime date, bool withyear = true}) {
  final months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  String day = date.day.toString().padLeft(2, '0'); // Ensures 2-digit day
  String month = months[date.month - 1]; // Get month abbreviation
  String year = date.year.toString(); // Get year

  if (withyear) {
    return "$day $month $year";
  } else {
    return "$day $month";
  }
}

String hashSHA256(String input) {
  return sha256.convert(utf8.encode(input)).toString();
}
