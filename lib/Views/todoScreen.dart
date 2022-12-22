import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';
import 'package:todo_vimigo_app/Models/tasks.dart';
import 'package:todo_vimigo_app/Views/Widgets/completed_tasklist.dart';
import 'package:todo_vimigo_app/Views/Widgets/reorderable_list.dart';

import '../Models/task.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Task> _tasks = [];
  // final List<Task> _tasks = [];
  // final List<Task> _tasks = [];

  @override
  void initState() {
    _tasks = TasksController().getTasks(context);

    super.initState();
  }

  Widget _checkbox(int index, bool isCompleted) {
    return Checkbox(
      checkColor: Colors.white,
      fillColor:
          MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
      value: _tasks[index].isCompleted,
      onChanged: (bool? value) {
        setState(() {
          TasksController().setIsCompletedForTask(context, index, value!);
        });
      },
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      TasksController().shiftingElements(context, oldIndex, newIndex);

      final taskToSwitch = _tasks.removeAt(oldIndex);
      _tasks.insert(newIndex, taskToSwitch);
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<Tasks>(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height - // total height
          kToolbarHeight - // top AppBar height
          MediaQuery.of(context).padding.top - // top padding
          kBottomNavigationBarHeight,
      child: ListView(
        children: [
          ReorderableTaskList(
              incompleteTasks: taskProvider.items
                  .where((t) => t.isCompleted == false)
                  .toList(),
              checkbox: _checkbox,
              onReorder: onReorder),
          // const Text("Completed Tasks"),
          ExpansionTile(
              initiallyExpanded: true,
              title: const Text("Completed Tasks"),
              children: [
                CompletedTaskList(
                    completedTasks: taskProvider.items
                        .where((t) => t.isCompleted == true)
                        .toList(),
                    checkBox: _checkbox)
              ])
        ],
      ),
    );
  }
}
