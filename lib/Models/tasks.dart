import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Models/task.dart';

class Tasks extends ChangeNotifier {
  final List<Task> _items = [
    Task(id: "t1", title: 'Today\'s Event 1', date: DateTime.now()),
    Task(id: "t2", title: 'Today\'s Event 2', date: DateTime.utc(2022, 12, 20)),
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
}
