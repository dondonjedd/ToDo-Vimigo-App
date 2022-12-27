import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';
import 'package:todo_vimigo_app/Models/tasks.dart';
import 'package:todo_vimigo_app/Views/Widgets/completed_tasklist.dart';
import 'package:todo_vimigo_app/Views/Widgets/reorderable_list.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../utils.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late TutorialCoachMark tutorialCoachMark;
  late TutorialCoachMark tutorialCoachMark2;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    // final prefs = await SharedPreferences.getInstance();

    if (TasksController()
            .getTasks(context)
            .where((t) => t.isCompleted == false)
            .toList()
            .length ==
        1) {
      tutorialCoachMark = createTutorial(context, _createTargets);
      Future.delayed(const Duration(seconds: 1),
          () => tutorialCoachMark.show(context: context));
    }

    if (TasksController()
            .getTasks(context)
            .where((t) => t.isCompleted == false)
            .toList()
            .length ==
        2) {
      tutorialCoachMark2 = createTutorial(context, _createTargets2);
      Future.delayed(const Duration(seconds: 1),
          () => tutorialCoachMark2.show(context: context));
    }
    super.didChangeDependencies();
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    targets.add(
      TargetFocus(
        identify: "AddTaskBtn",
        keyTarget: firstTaskTitleAdded,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const FittedBox(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Swipe left to right to delete task",
                        style: TextStyle(color: Colors.blue, fontSize: 30),
                      ),
                    ),
                    Lottie.asset("assets/112299-swipe-left.json")
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "AddTaskBtn",
        keyTarget: keyfirstTaskCheckBox,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const FittedBox(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Tap checkbox to mark as completed",
                        style: TextStyle(color: Colors.blue, fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(100.0),
                      child:
                          Lottie.asset("assets/79071-check-box-animation.json"),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }

  List<TargetFocus> _createTargets2() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "AddTaskBtn",
        keyTarget: firstTaskTrailing,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const FittedBox(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Drag handler up/down to reorder tasks",
                        style: TextStyle(color: Colors.blue, fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(100.0),
                      child: Lottie.asset("assets/lf30_editor_lxwrh7u5.json"),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final incompleteTasks = TasksController()
          .getTasks(context)
          .where((t) => t.isCompleted == false)
          .toList();

      TasksController().shiftingElements(
          context,
          TasksController()
              .getIndexWithId(context, incompleteTasks[oldIndex].id),
          TasksController()
              .getIndexWithId(context, incompleteTasks[newIndex].id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<Tasks>(context, listen: true);
    return SizedBox(
      height: MediaQuery.of(context).size.height - // total height
          kToolbarHeight - // top AppBar height
          MediaQuery.of(context).padding.top - // top padding
          kBottomNavigationBarHeight,
      child: TasksController().getTasks(context).isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Add New Task To Get Started",
                        style: TextStyle(fontSize: 25),
                      ),
                      Lottie.asset("assets/socialv-no-data.json"),
                    ],
                  ),
                ),
              ),
            )
          : ListView(
              children: [
                ReorderableTaskList(
                    incompleteTasks: taskProvider.items
                        .where((t) => t.isCompleted == false)
                        .toList(),
                    reorderFunc: onReorder),

                // const Text("Completed Tasks"),
                ExpansionTile(
                    initiallyExpanded: true,
                    title: const Text("Completed Tasks"),
                    children: [
                      CompletedTaskList(
                        completedTasks: taskProvider.items
                            .where((t) => t.isCompleted == true)
                            .toList(),
                      )
                    ]),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
    );
  }
}
