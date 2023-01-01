import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  DateTime? date;
  @HiveField(4)
  DateTime? reminderDateTime;
  @HiveField(5)
  bool isCompleted;

  Task(
      {required this.id,
      required this.title,
      this.description = "",
      this.date,
      this.reminderDateTime,
      this.isCompleted = false});

  @override
  String toString() => title;

  void setIsCompleted(bool bol) {
    isCompleted = bol;
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    DateTime? reminderDateTime,
    bool? isCompleted,
  }) {
    return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date,
        reminderDateTime: reminderDateTime,
        isCompleted: isCompleted ?? this.isCompleted);
  }
}
