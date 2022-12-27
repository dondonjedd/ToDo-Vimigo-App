import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';
import 'package:todo_vimigo_app/Models/task.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../utils.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Task>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .disabled; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late TutorialCoachMark tutorialCoachMark;
  @override
  void didChangeDependencies() async {
    final prefs = await SharedPreferences.getInstance();
    final isShown = prefs.getBool("calendarScreen") ?? false;
    print("Calendar screen $isShown");
    if (!isShown) {
      tutorialCoachMark = createTutorial(context, _createTargets);
      Future.delayed(Duration.zero, showTutorial);
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    super.initState();
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "AddTaskBtn",
        keyTarget: keyCalendar,
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
                        "Swipe up to minimize Calendar",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Center(
                      child: Lottie.asset("assets/lf30_editor_lxwrh7u5.json",
                          height: 150.0),
                    )
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
        keyTarget: keyTaskListInCalendar,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Lottie.asset(
                        "assets/lf30_editor_qehuqg5k.json",
                      ),
                    ),
                    const FittedBox(
                      child: Text(
                        textAlign: TextAlign.center,
                        "List of tasks for the selected day\nwill be shown here",
                        style: TextStyle(color: Colors.blue, fontSize: 30),
                      ),
                    ),
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

  List<Task> _getEventsForDay(DateTime date) {
    // Implementation example
    return TasksController().getIncompleteTasksForDay(context, date);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        // _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var calendarStyling = CalendarStyle(
      // Use `CalendarStyle` to customize the UI
      outsideDaysVisible: false,
      selectedDecoration:
          (const CalendarStyle().selectedDecoration as BoxDecoration)
              .copyWith(color: Theme.of(context).colorScheme.primary),

      todayDecoration: (const CalendarStyle().todayDecoration as BoxDecoration)
          .copyWith(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
    );

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20)),
          child: TableCalendar<Task>(
            headerStyle: HeaderStyle(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            ),
            // shouldFillViewport: true,
            key: keyCalendar,
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            weekNumbersVisible: true,
            calendarStyle: calendarStyling,
            onDaySelected: _onDaySelected,
            // onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week',
            },
          ),
        ),
      ),
      const SizedBox(height: 8.0),
      Expanded(
        child: ValueListenableBuilder<List<Task>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            return ListView.builder(
              key: keyTaskListInCalendar,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    onTap: () => print('${value[index]}'),
                    title: Text('${value[index]}'),
                  ),
                );
              },
            );
          },
        ),
      )
    ]);
  }
}
