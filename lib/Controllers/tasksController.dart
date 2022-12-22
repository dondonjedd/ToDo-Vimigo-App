import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/task.dart';
import '../Models/tasks.dart';

class TasksController {
  List<Task> getTasks(BuildContext context) {
    return Provider.of<Tasks>(context, listen: false).items.toList();
  }

  List<Task> getTasksForDay(BuildContext context, DateTime date) {
    return Provider.of<Tasks>(context, listen: false)
        .items
        .where((task) =>
            task.date.day == date.day &&
            task.date.month == date.month &&
            task.date.year == date.year)
        .toList();
  }

  int getTaskslength(BuildContext context) {
    return Provider.of<Tasks>(context, listen: false).items.length;
  }

  Task getTaskAtIndex(BuildContext context, int index) {
    return Provider.of<Tasks>(context, listen: false).getItemAtIndex(index);
  }

  void insertTask(BuildContext context, int index, Task taskToAdd) {
    Provider.of<Tasks>(context, listen: false).insertTask(index, taskToAdd);
  }

  Task removeTask(BuildContext context, int index) {
    return Provider.of<Tasks>(context, listen: false).removeTask(index);
  }
}
