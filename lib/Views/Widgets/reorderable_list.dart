import 'package:flutter/material.dart';

class ReorderableTaskList extends StatelessWidget {
  final incompleteTasks;
  final checkbox;
  final Function(int, int) onReorder;
  const ReorderableTaskList(
      {required this.incompleteTasks,
      required this.checkbox,
      required this.onReorder,
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
          leading: checkbox(index, false),
        );
      },
      itemCount: incompleteTasks.length,
      onReorder: onReorder,
    );
  }
}
