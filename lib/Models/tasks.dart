import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Models/task.dart';

class Tasks extends ChangeNotifier {
  final List<Task> _items = [
    const Task('Today\'s Event 1'),
    const Task('Today\'s Event 2'),
  ];

  List<Task> get items {
    return _items;
  }

  void addTask(Task taskToAdd) {
    _items.add(taskToAdd);
    notifyListeners();
  }
}
