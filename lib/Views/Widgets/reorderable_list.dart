import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';

class ReorderableTaskList extends StatelessWidget {
  final incompleteTasks;
  final checkbox;
  final Function(int, int) reorderFunc;
  const ReorderableTaskList(
      {required this.incompleteTasks,
      required this.checkbox,
      required this.reorderFunc,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      buildDefaultDragHandles: true,
      itemBuilder: (ctx, index) {
        return ListTile(
          key: Key(incompleteTasks[index].id),
          title: Text(incompleteTasks[index].title),
          leading: checkbox(
              TasksController()
                  .getIndexWithId(context, incompleteTasks[index].id),
              false),
        );
      },
      itemCount: incompleteTasks.length,
      onReorder: reorderFunc,
    );
  }
}