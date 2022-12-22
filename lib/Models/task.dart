class Task {
  final String id;
  final String title;
  final DateTime date;
  bool isCompleted;

  Task(
      {required this.id,
      required this.title,
      required this.date,
      this.isCompleted = false});

  @override
  String toString() => title;
}
