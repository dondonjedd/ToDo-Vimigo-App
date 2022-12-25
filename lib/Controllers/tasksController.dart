import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/task.dart';
import '../Models/tasks.dart';

class TasksController {
  List<Task> getTasks(BuildContext context) {
    return Provider.of<Tasks>(context, listen: false).items;
  }

  Future<void> initTasks(BuildContext context) async {
    return await Provider.of<Tasks>(context, listen: false).initItems();
  }

  List<Task> getIncompleteTasksForDay(BuildContext context, DateTime date) {
    final List<Task> items = getTasks(context);
    return items
        .where((task) =>
            task.date?.day == date.day &&
            task.date?.month == date.month &&
            task.date?.year == date.year &&
            task.isCompleted == false)
        .toList();
  }

  Future<int> getTaskslength(BuildContext context) async {
    final List<Task> items = getTasks(context);
    return items.length;
  }

  Task getTaskAtIndex(BuildContext context, int index) {
    return Provider.of<Tasks>(context, listen: false).getItemAtIndex(index);
  }

  int getIndexWithId(BuildContext context, String id) {
    return Provider.of<Tasks>(context, listen: false).getIndexWithId(id);
  }

  Future<void> insertTask(
      BuildContext context, int index, Task taskToAdd) async {
    await Provider.of<Tasks>(context, listen: false)
        .insertTask(index, taskToAdd);
    return;
  }

  Future<Task> removeTask(BuildContext context, int index) async {
    return await Provider.of<Tasks>(context, listen: false).removeTask(index);
  }

  Future<Task> removeTaskWithId(BuildContext context, String id) async {
    return await removeTask(context, getIndexWithId(context, id));
  }

  void setIsCompletedForTask(BuildContext context, int index, bool bol) {
    Provider.of<Tasks>(context, listen: false)
        .toggleCompletedForTask(index, bol);
  }

  void shiftingElements(BuildContext context, int oldIndex, int newIndex) {
    Provider.of<Tasks>(context, listen: false)
        .shiftingElements(oldIndex, newIndex);
  }

  void addNewTask(
    BuildContext context,
    Task newTask,
  ) {
    Provider.of<Tasks>(context, listen: false).addTask(newTask);
  }

  Future<Task> updateTask(
    BuildContext context,
    String id,
    Task newTask,
  ) async {
    return await Provider.of<Tasks>(context, listen: false).updateTask(id, newTask);
  }
}
