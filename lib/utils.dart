// Available dates in the calendar
import 'package:flutter/material.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

void showScaffold(BuildContext context,
    {required String text,
    required Color bgColor,
    required Color textColor,
    required Duration duration}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: bgColor,
    content: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: textColor),
    ),
    duration: duration,
  ));
}
