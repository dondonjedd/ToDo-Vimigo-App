class Task {
  final String id;
  final String title;
  final DateTime date;

  const Task({required this.id, required this.title, required this.date});

  @override
  String toString() => title;
}
