import 'package:flutter/material.dart';

class CompletedTaskList extends StatelessWidget {
  final completedTasks;
  final checkBox;
  const CompletedTaskList({super.key,required this.completedTasks,required this.checkBox});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (ctx, index) {
        return ListTile(
          key: ValueKey(completedTasks[index].id),
          title: Text(completedTasks[index].title),
          leading: checkBox(index, true),
        );
      },
      itemCount: completedTasks.length,
    );
  }
}
