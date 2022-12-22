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
          int indexFromAllTask = isCompleted
              ? TasksController()
                  .getIndexWithId(context, _completedTasks[index].id)
              : TasksController()
                  .getIndexWithId(context, _incompleteTasks[index].id);

          TasksController()
              .toggleCompletedForTask(context, indexFromAllTask, value!);
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

  Widget incompleteReorderableTaskList() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
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
          final oldIndexOfAllTasks = TasksController()
              .getIndexWithId(context, _incompleteTasks[oldIndex].id);
          final newIndexOfAllTasks = TasksController()
              .getIndexWithId(context, _incompleteTasks[newIndex].id);

          TasksController().shiftingElements(
              context, oldIndexOfAllTasks, newIndexOfAllTasks);

          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          final taskToSwitch = _incompleteTasks.removeAt(oldIndex);
          _incompleteTasks.insert(newIndex, taskToSwitch);
        });
      },
    );
  }

  Widget completeTaskList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (ctx, index) {
        return ListTile(
          key: ValueKey(_completedTasks[index].id),
          title: Text(_completedTasks[index].title),
          leading: checkbox(index, true),
        );
      },
      itemCount: _completedTasks.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - // total height
          kToolbarHeight - // top AppBar height
          MediaQuery.of(context).padding.top - // top padding
          kBottomNavigationBarHeight,
      child: ListView(
        children: [
          incompleteReorderableTaskList(),
          // const Text("Completed Tasks"),
          ExpansionTile(
              initiallyExpanded: true,
              title: const Text("Completed Tasks"),
              children: [completeTaskList()])
        ],
      ),
    );
  }
}
