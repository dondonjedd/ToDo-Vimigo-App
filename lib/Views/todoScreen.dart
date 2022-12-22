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
  List<Task> _completedTasks = [];
  List<Task> _incompleteTasks = [];
  @override
  void initState() {
    _tasks.addAll(TasksController().getTasks(context));
    _completedTasks = _tasks.where((t) => t.isCompleted == true).toList();
    _incompleteTasks = _tasks.where((t) => t.isCompleted == false).toList();
    super.initState();
  }

  Widget checkbox(int index, bool isCompleted) {
    return Checkbox(
      checkColor: Colors.white,
      fillColor:
          MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
      value: isCompleted,
      onChanged: (bool? value) {
        setState(() {
          TasksController().toggleCompletedForTask(context, index, value!);
          if (isCompleted) {
            _completedTasks[index].isCompleted = value;

            Task tempTask = Task(
                id: _completedTasks[index].id,
                title: _completedTasks[index].title,
                date: _completedTasks[index].date);

            _completedTasks.removeAt(index);

            _incompleteTasks.add(tempTask);
          } else {
            _incompleteTasks[index].isCompleted = value;

            Task tempTask = Task(
                id: _incompleteTasks[index].id,
                title: _incompleteTasks[index].title,
                date: _incompleteTasks[index].date);
            _incompleteTasks.removeAt(index);
            _completedTasks.add(tempTask);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //Incomplete tasks
    var reorderableListView = ReorderableListView.builder(
      buildDefaultDragHandles: true,
      itemBuilder: (ctx, index) {
        return ListTile(
          key: Key(_incompleteTasks[index].id),
          title: Text(_incompleteTasks[index].title),
          leading: checkbox(index, false),
        );
      },
      itemCount: _incompleteTasks.length,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final taskToSwitchProvider =
              TasksController().removeTask(context, oldIndex);
          TasksController().insertTask(context, newIndex, taskToSwitchProvider);

          final taskToSwitch = _incompleteTasks.removeAt(oldIndex);
          _incompleteTasks.insert(newIndex, taskToSwitch);
        });
      },
    );

    //Completed Tasks
    var listView = ListView.builder(
      itemBuilder: (ctx, index) {
        return ListTile(
          key: ValueKey(_completedTasks[index].id),
          title: Text(_completedTasks[index].title),
          leading: checkbox(index, true),
        );
      },
      itemCount: _completedTasks.length,
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height - // total height
          kToolbarHeight - // top AppBar height
          MediaQuery.of(context).padding.top - // top padding
          kBottomNavigationBarHeight,
      child: Column(children: [
        Flexible(
          flex: 4,
          child: reorderableListView,
        ),
        const Flexible(flex: 1, child: Text("Completed Tasks")),
        Flexible(
          flex: 4,
          child: listView,
        )
      ]),
    );
  }
}
