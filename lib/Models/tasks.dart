import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_vimigo_app/Models/task.dart';

class Tasks extends ChangeNotifier {
  // final List<Task> _items = [
  //   Task(id: "t1", title: 'Today\'s Event 1', date: DateTime.now()),
  //   Task(id: "t2", title: 'Today\'s Event 2', date: DateTime.utc(2022, 12, 20)),
  //   Task(id: "t3", title: 'Today\'s Event 3', date: DateTime.now()),
  //   Task(
  //       id: "t4",
  //       title: 'Today\'s Event 4',
  //       date: DateTime.utc(2022, 12, 20),
  //       isCompleted: true),
  //   Task(id: "t5", title: 'Today\'s Event 5', date: DateTime.now()),
  //   Task(id: "t6", title: 'Today\'s Event 6', date: DateTime.utc(2022, 12, 20)),
  //   Task(id: "t7", title: 'Today\'s Event 7', date: DateTime.now()),
  //   Task(id: "t8", title: 'Today\'s Event 8', date: DateTime.utc(2022, 12, 20)),
  //   Task(id: "t9", title: 'Today\'s Event 9', date: DateTime.now()),
  //   Task(
  //       id: "t10",
  //       title: 'Today\'s Event 10',
  //       date: DateTime.utc(2022, 12, 20)),
  // ];

  List<Task> _items = [];
  UnmodifiableListView<Task> get items => UnmodifiableListView(_items);
  final String _dbKey = "TaskList";

  Future<void> setItems() async {
    Box<Task> box = await Hive.openBox<Task>(_dbKey);
    _items = box.values.toList();
    notifyListeners();
  }

  Future<void> addTask(Task taskToAdd) async {
    Box<Task> box = await Hive.openBox<Task>(_dbKey);
    await box.add(taskToAdd);
    _items.add(taskToAdd);
    _items = box.values.toList();
    notifyListeners();
  }

  Future<void> insertTask(int index, Task taskToAdd) async {
    Box<Task> box = await Hive.openBox<Task>(_dbKey);
    await box.add(taskToAdd);
    _items.insert(index, taskToAdd);
    _items = box.values.toList();
    // _db.put(_dbKey, _items);
    notifyListeners();
  }

  Task removeTask(int index) {
    Task task = _items.removeAt(index);
    // _db.put(_dbKey, _items);
    notifyListeners();
    return task;
  }

  Task getItemAtIndex(int index) {
    return [..._items][index];
  }

  int getTaskWithId(String id) {
    return [..._items].indexWhere((task) => task.id == id);
  }

  void toggleCompletedForTask(int index, bool bol) {
    _items[index].setIsCompleted(bol);
    // _db.put(_dbKey, _items);
    notifyListeners();
  }

  // void swapTask(int oldIndex, int newIndex) {
  //   _items.swap(oldIndex, newIndex);
  // }

  void shiftingElements(int oldIndex, int newIndex) {
    final taskToSwitchProvider = _items.removeAt(oldIndex);
    _items.insert(newIndex, taskToSwitchProvider);
    // _db.put(_dbKey, _items);
    notifyListeners();
  }

  void updateProduct(String id, Task newTask) {
    final taskIndex = getTaskWithId(id);
    if (taskIndex >= 0) {
      _items[taskIndex] = newTask;
      // _db.put(_dbKey, _items);
      notifyListeners();
    }
  }
}
