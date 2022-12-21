class Task {
  final String title;
  final DateTime date;

  const Task({required this.title, required this.date});

  @override
  String toString() => title;
}
