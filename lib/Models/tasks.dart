import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Models/task.dart';

class Tasks extends ChangeNotifier {
  final List<Task> _items = [
    Task(id: "t1", title: 'Today\'s Event 1', date: DateTime.now()),
    Task(id: "t2", title: 'Today\'s Event 2', date: DateTime.utc(2022, 12, 20)),
    Task(id: "t3", title: 'Today\'s Event 3', date: DateTime.now()),
    Task(
        id: "t4",
        title: 'Today\'s Event 4',
        date: DateTime.utc(2022, 12, 20),
        isCompleted: true),
    Task(id: "t5", title: 'Today\'s Event 5', date: DateTime.now()),
    Task(id: "t6", title: 'Today\'s Event 6', date: DateTime.utc(2022, 12, 20)),
    Task(id: "t7", title: 'Today\'s Event 7', date: DateTime.now()),
    Task(id: "t8", title: 'Today\'s Event 8', date: DateTime.utc(2022, 12, 20)),
    Task(id: "t9", title: 'Today\'s Event 9', date: DateTime.now()),
    Task(
        id: "t10",
        title: 'Today\'s Event 10',
        date: DateTime.utc(2022, 12, 20)),
  ];

  List<Task> get items {
    return _items;
  }

  void addTask(Task taskToAdd) {
    _items.add(taskToAdd);
    notifyListeners();
  }

  void insertTask(int index, Task taskToAdd) {
    _items.insert(index, taskToAdd);
    notifyListeners();
  }

  Task removeTask(int index) {
    Task task = _items.removeAt(index);
    notifyListeners();
    return task;
  }

  Task getItemAtIndex(int index) {
    return _items.elementAt(index);
  }

  void toggleCompletedForTask(int index, bool bol) {
    _items.elementAt(index).isCompleted = bol;
    notifyListeners();
  }
}
