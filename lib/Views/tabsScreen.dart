import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Views/Widgets/addTask_bottomSheet.dart';
import 'package:todo_vimigo_app/Views/calendarScreen.dart';
import 'package:todo_vimigo_app/Views/todoScreen.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../Controllers/tasksController.dart';
import '../utils.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late TutorialCoachMark tutorialCoachMark;
  bool _init = false;

  @override
  void initState() {
    super.initState();
  }

  void showTutorial() {
    // tutorialCoachMark.show(context: context);s
  }

  void createTutorial(BuildContext ctx) {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "AddTaskBtn",
        keyTarget: keyAddTaskBtn,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }

  @override
  void didChangeDependencies() {
    if (!_init) {
      TasksController().initTasks(context).then((_) {
        createTutorial(context);
        Future.delayed(Duration.zero, showTutorial);
        setState(() {
          _init = true;
        });
      });
      super.didChangeDependencies();
    }
  }

  final List<Map<String, Object>> pages = [
    {"page": const TodoScreen(), "title": "Tasks"},
    {"page": const CalendarScreen(), "title": "Calendar"},
  ];

  int selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  startAddTaskBottomSheet(ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return const AddNewTask();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
          child: Text(
            pages[selectedPageIndex]["title"] as String,
            textAlign: TextAlign.center,
          ),
        )),
        body: !_init
            ? const Center(child: CircularProgressIndicator())
            : pages[selectedPageIndex]["page"] as Widget,
        bottomNavigationBar: BottomNavigationBar(
            onTap: _selectPage,
            backgroundColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.cyan,
            selectedItemColor: Colors.white,
            currentIndex: selectedPageIndex,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.list,
                  ),
                  label: "ToDos"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: "Calendar")
            ]),
        floatingActionButton: selectedPageIndex == 0
            ? FloatingActionButton(
                key: keyAddTaskBtn,
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () => startAddTaskBottomSheet(context),
                child: const Icon(
                  Icons.add,
                ),
              )
            : null);
  }
}
