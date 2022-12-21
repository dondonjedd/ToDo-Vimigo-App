import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Models/task.dart';

class Tasks extends ChangeNotifier {
  final List<Task> _items = [
    Task(title: 'Today\'s Event 1', date: DateTime.now()),
    Task(title: 'Today\'s Event 2', date: DateTime.now()),
  ];

  List<Task> get items {
    return _items;
  }

  void addTask(Task taskToAdd) {
    _items.add(taskToAdd);
    notifyListeners();
  }
}
