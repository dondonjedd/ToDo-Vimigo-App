import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';
import 'package:todo_vimigo_app/Models/tasks.dart';
import 'package:todo_vimigo_app/Views/Widgets/completed_tasklist.dart';
import 'package:todo_vimigo_app/Views/Widgets/reorderable_list.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  // final List<Task> _tasks = [];
  // final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
  }

  Widget _checkbox(int index, bool isCompleted) {
    return Checkbox(
      checkColor: Colors.white,
      fillColor:
          MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
      value: TasksController().getTasks(context)[index].isCompleted,
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

      final incompleteTasks = TasksController()
          .getTasks(context)
          .where((t) => t.isCompleted == false)
          .toList();

      TasksController().shiftingElements(
          context,
          TasksController()
              .getIndexWithId(context, incompleteTasks[oldIndex].id),
          TasksController()
              .getIndexWithId(context, incompleteTasks[newIndex].id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<Tasks>(context, listen: true);
    return SizedBox(
      height: MediaQuery.of(context).size.height - // total height
          kToolbarHeight - // top AppBar height
          MediaQuery.of(context).padding.top - // top padding
          kBottomNavigationBarHeight,
      child: ListView(
        children: [
          Consumer<Tasks>(
            builder: (context, value, child) => ReorderableTaskList(
                incompleteTasks: taskProvider.items
                    .where((t) => t.isCompleted == false)
                    .toList(),
                checkbox: _checkbox,
                reorderFunc: onReorder),
          ),

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
