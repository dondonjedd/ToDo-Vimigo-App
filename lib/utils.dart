// Available dates in the calendar
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

void showScaffold(BuildContext context,
    {required String text,
    required Color bgColor,
    required Color textColor,
    required Duration duration}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: bgColor,
    content: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: textColor),
    ),
    duration: duration,
  ));
}

enum argumentsEditToTodo { deleted, edited, none }

GlobalKey keyAddTaskBtn = GlobalKey();
GlobalKey keyTitleTextForm = GlobalKey();
GlobalKey keyNewTaskCalendarBtn = GlobalKey();
GlobalKey firstTaskTitleAdded = GlobalKey();
GlobalKey firstTaskTrailing = GlobalKey();
GlobalKey keyCalendar = GlobalKey();
GlobalKey keyTaskListInCalendar = GlobalKey();
GlobalKey keyBottomNavigationBar = GlobalKey();
GlobalKey keyfirstTaskCheckBox = GlobalKey();

TutorialCoachMark createTutorial(BuildContext ctx, targets) {
  return TutorialCoachMark(
    targets: targets(),
    colorShadow: Colors.orange,
    // alignSkip: Alignment.centerRight,
    hideSkip: true,
    // skipWidget: ElevatedButton(
    //     onPressed: () {},
    //     child: const Text(
    //       "Skip",
    //       style: TextStyle(
    //           backgroundColor: Colors.blue,
    //           color: Colors.white,
    //           fontWeight: FontWeight.normal,
    //           fontSize: 20),
    //     )),
    paddingFocus: 10,
    opacityShadow: 0.8,
    onFinish: () {
      print("finish");
    },
    onClickTarget: (target) async {
      final prefs = await SharedPreferences.getInstance();

      // if (target.keyTarget == keyAddTaskBtn) {
      //   await prefs.setBool("keyAddTaskBtn", true);
      // }
      if (target.keyTarget == keyBottomNavigationBar) {
        await prefs.setBool("tabsScreen", true);
      }

      if (target.keyTarget == keyfirstTaskCheckBox) {
        await prefs.setBool("todoScreen1", true);
      }

      if (target.keyTarget == firstTaskTrailing) {
        await prefs.setBool("todoScreen2", true);
      }

      if (target.keyTarget == keyNewTaskCalendarBtn) {
        await prefs.setBool("addTaskSheet", true);
      }
      if (target.keyTarget == keyTaskListInCalendar) {
        await prefs.setBool("calendarScreen", true);
      }
      
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
