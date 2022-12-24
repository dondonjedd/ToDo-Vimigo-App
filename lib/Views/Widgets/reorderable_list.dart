import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';
import 'package:todo_vimigo_app/Views/editTask_screen.dart';
import 'package:todo_vimigo_app/utils.dart';

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
            TasksController()
                .removeTaskWithId(context, incompleteTasks[index].id);

            showScaffold(context,
                text: "Task Removed",
                bgColor: Theme.of(context).colorScheme.error,
                textColor: Theme.of(context).colorScheme.onSecondary,
                duration: const Duration(milliseconds: 500));
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
            onTap: () {
              Navigator.of(context)
                  .pushNamed(EditTask.routeName,
                      arguments: TasksController()
                          .getIndexWithId(context, incompleteTasks[index].id))
                  .then((value) {
                switch (value) {
                  case argumentsEditToTodo.deleted:
                    showScaffold(context,
                        text: "Task Deleted",
                        bgColor: Theme.of(context).colorScheme.error,
                        textColor: Theme.of(context).colorScheme.onError,
                        duration: const Duration(milliseconds: 1000));
                    break;
                  case argumentsEditToTodo.edited:
                    showScaffold(context,
                        text: "Task Edited",
                        bgColor: Theme.of(context).colorScheme.tertiary,
                        textColor: Theme.of(context).colorScheme.onTertiary,
                        duration: const Duration(milliseconds: 1000));
                    break;
                  default:
                }
              });
            },
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
