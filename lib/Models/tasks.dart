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

  Future<void> initItems() async {
    Box<Task> box = await Hive.openBox<Task>(_dbKey);
    _items = box.values.toList();
    notifyListeners();
  }

  Future<void> addTask(Task taskToAdd) async {
    Box<Task> box = await Hive.openBox<Task>(_dbKey);
    await box.add(taskToAdd);
    _items = box.values.toList();
    notifyListeners();
  }

  Future<void> insertTask(int index, Task taskToAdd) async {
    Box<Task> box = await Hive.openBox<Task>(_dbKey);
    await box.add(taskToAdd);
    _items = box.values.toList();
    notifyListeners();
  }

  Future<Task> removeTask(int index) async {
    Box<Task> box = await Hive.openBox<Task>(_dbKey);
    await box.deleteAt(index);
    Task task = _items.removeAt(index);
    _items = box.values.toList();
    notifyListeners();
    return task;
  }

  Task getItemAtIndex(int index) {
    return [..._items][index];
  }

  int getIndexWithId(String id) {
    return [..._items].indexWhere((task) => task.id == id);
  }

  void toggleCompletedForTask(int index, bool bol) async {
    Box<Task> box = await Hive.openBox<Task>(_dbKey);

    await box.putAt(index, _items[index].copyWith(isCompleted: bol));
    _items = box.values.toList();
    notifyListeners();
  }

  // void swapTask(int oldIndex, int newIndex) {
  //   _items.swap(oldIndex, newIndex);
  // }

  void shiftingElements(int oldIndex, int newIndex) async {
    final taskToSwitchProvider = _items.removeAt(oldIndex);
    _items.insert(newIndex, taskToSwitchProvider);
    Box<Task> box = await Hive.openBox<Task>(_dbKey);
    await box.clear();
    await box.addAll(_items);
    _items = box.values.toList();
    notifyListeners();
  }

  Future<Task> updateTask(String id, Task newTask) async {
    int taskIndex = getIndexWithId(id);
    if (taskIndex >= 0) {
      Box<Task> box = await Hive.openBox<Task>(_dbKey);
      await box.putAt(taskIndex, newTask);
      _items = box.values.toList();
      notifyListeners();
    }
    return newTask;
  }
}
