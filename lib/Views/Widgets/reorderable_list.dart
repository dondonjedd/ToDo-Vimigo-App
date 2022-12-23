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
      buildDefaultDragHandles: false,
      itemBuilder: (ctx, index) {
        return Dismissible(
          key: ValueKey(incompleteTasks[index].id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            TasksController().removeTask(
                context,
                TasksController()
                    .getIndexWithId(context, incompleteTasks[index].id));
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
            key: Key(incompleteTasks[index].id),
            title: Text(incompleteTasks[index].title),
            leading: checkbox(
                TasksController()
                    .getIndexWithId(context, incompleteTasks[index].id),
                false),
            trailing: ReorderableDragStartListener(
                index: index, child: const Icon(Icons.drag_indicator_outlined)),
          ),
        );
      },
      itemCount: incompleteTasks.length,
      onReorder: reorderFunc,
    );
  }
}
