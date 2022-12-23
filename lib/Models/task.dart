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

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
  }) {
    return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
        isCompleted: isCompleted ?? this.isCompleted);
  }
}
