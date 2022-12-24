import 'package:flutter/material.dart';

import '../../Controllers/tasksController.dart';
import 'check_box.dart';

class CompletedTaskList extends StatelessWidget {
  final completedTasks;

  const CompletedTaskList({super.key, required this.completedTasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (ctx, index) {
        return Dismissible(
          key: ValueKey(completedTasks[index].id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            TasksController()
                .removeTaskWithId(context, completedTasks[index].id);
          },
          background: Container(
            color: Theme.of(context).colorScheme.error,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.inversePrimary,
              size: 40,
            ),
          ),
          child: ListTile(
            key: ValueKey(completedTasks[index].id),
            title: Text(
              completedTasks[index].title,
              style: const TextStyle(decoration: TextDecoration.lineThrough),
            ),
            leading: TaskCheckBox(
              index: TasksController()
                  .getIndexWithId(context, completedTasks[index].id),
            ),
          ),
        );
      },
      itemCount: completedTasks.length,
    );
  }
}
