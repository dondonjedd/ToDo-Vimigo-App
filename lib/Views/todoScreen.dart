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
              title: Text(taskAtIndex.title),
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
          itemCount: TasksController().getTaskslength(context),
          onReorder: (_, __) {}),
    );
  }
}
