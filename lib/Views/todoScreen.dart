import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReorderableListView.builder(
          itemBuilder: (ctx, index) {
            final taskAtIndex =
                TasksController().getTaskAtIndex(context, index);
            return ListTile(
              key: ValueKey(taskAtIndex.id),
              leading: Text(taskAtIndex.title),
            );
          },
          itemCount: TasksController().getTaskslength(context),
          onReorder: (_, __) {}),
    );
  }
}
