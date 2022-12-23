import 'package:flutter/widgets.dart';

class Task extends ChangeNotifier {
  final String id;
  final String title;
  String description;
  DateTime? date;
  bool isCompleted;

  Task(
      {required this.id,
      required this.title,
      this.description = "",
      this.date,
      this.isCompleted = false});

  @override
  String toString() => title;

  void setIsCompleted(bool bol) {
    isCompleted = bol;
    notifyListeners();
  }
}
