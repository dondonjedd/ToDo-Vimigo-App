import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_vimigo_app/Views/Widgets/addTask_bottomSheet.dart';
import 'package:todo_vimigo_app/Views/Screens/calendarScreen.dart';
import 'package:todo_vimigo_app/Views/Screens/todoScreen.dart';
import 'package:todo_vimigo_app/Views/Widgets/main_drawer.dart';
import 'package:todo_vimigo_app/api/notification_api.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../Controllers/tasksController.dart';
import '../../utils.dart';

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

  @override
  void didChangeDependencies() async {
    if (!_init) {
      TasksController().initTasks(context).then((_) async {
        final prefs = await SharedPreferences.getInstance();
        final isShown = prefs.getBool("tabsScreen") ?? false;
        if (!isShown) {
          tutorialCoachMark = createTutorial(context, _createTargets);
          Future.delayed(const Duration(seconds: 1), showTutorial);
        }
        // print("Tabs Screen: $isShown");
        notifApi = NotificationApi();
        notifApi.init();
        listenNotifications();
        setState(() {
          _init = true;
        });
      });
      super.didChangeDependencies();
    }
  }

  void listenNotifications() =>
      notifApi.onNotifications.stream.listen(onClickedNotification);

  onClickedNotification(String? payload) {
    if (payload == null) {
      return;
    }

    TasksController().updateTask(
        context,
        payload,
        TasksController()
            .getTaskAtIndex(
                context, TasksController().getIndexWithId(context, payload))
            .copyWith(reminderDateTime: null));
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
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
                children: <Widget>[
                  Lottie.asset("assets/4345-single-tap-mobile-gesture.json"),
                  FittedBox(
                    child: Text(
                      textAlign: TextAlign.left,
                      "Add a new task by tapping this button",
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyBottomNavigationBar",
        keyTarget: keyBottomNavigationBar,
        alignSkip: Alignment.topRight,
        paddingFocus: 50,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Lottie.asset("assets/111844-schedule.json"),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: FittedBox(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Switch to Calendar View\nby tapping this navigation bar",
                        style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
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
        drawer: const MainDrawer(),
        appBar: AppBar(
            title: Text(
          pages[selectedPageIndex]["title"] as String,
          textAlign: TextAlign.center,
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
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.list,
                  ),
                  label: "ToDos"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month, key: keyBottomNavigationBar),
                  label: "Calendar")
            ]),
        floatingActionButton: selectedPageIndex == 0
            ? FloatingActionButton(
                key: keyAddTaskBtn,
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  startAddTaskBottomSheet(context);
                },
                child: const Icon(
                  Icons.add,
                ),
              )
            : null);
  }
}
