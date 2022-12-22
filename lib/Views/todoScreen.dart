import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';

import '../Models/task.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Task> _tasks = [];
  @override
  void initState() {
    // TODO: implement initState
    _tasks.addAll(TasksController().getTasks(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReorderableListView.builder(
        itemBuilder: (ctx, index) {
          return ListTile(
            key: Key(index.toString()),
            title: Text(_tasks[index].title),
            leading: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.primary),
              value: false,
              onChanged: (bool? value) {
                // setState(() {
                //   isChecked = value!;
                // });
              },
            ),
          );
        },
        itemCount: _tasks.length,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final taskToSwitchProvider =
                TasksController().removeTask(context, oldIndex);
            TasksController()
                .insertTask(context, newIndex, taskToSwitchProvider);

            final taskToSwitch = _tasks.removeAt(oldIndex);
            _tasks.insert(newIndex, taskToSwitch);
          });
        },
      ),
    );
  }
}
