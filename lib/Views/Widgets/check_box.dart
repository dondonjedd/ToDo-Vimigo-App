import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controllers/tasksController.dart';
import '../../Models/tasks.dart';

class TaskCheckBox extends StatelessWidget {
  final int index;
  const TaskCheckBox({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<Tasks>(context, listen: true);
    return Checkbox(
      checkColor: Colors.white,
      fillColor:
          MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
      value: taskProvider.getItemAtIndex(index).isCompleted,
      onChanged: (bool? value) {
        TasksController().setIsCompletedForTask(context, index, value!);
      },
    );
  }
}
