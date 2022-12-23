import 'package:flutter/widgets.dart';

class Task extends ChangeNotifier {
  final String id;
  final String title;
  DateTime? date;
  bool isCompleted;

  Task(
      {required this.id,
      required this.title,
      this.date,
      this.isCompleted = false});

  @override
  String toString() => title;

  void setIsCompleted(bool bol) {
    isCompleted = bol;
    notifyListeners();
  }
}
