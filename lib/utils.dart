// Available dates in the calendar
import 'package:flutter/material.dart';
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

TutorialCoachMark createTutorial(BuildContext ctx, targets) {
  return TutorialCoachMark(
    targets: targets(),
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
