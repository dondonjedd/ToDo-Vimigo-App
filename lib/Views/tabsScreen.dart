import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Views/Widgets/addTask_bottomSheet.dart';
import 'package:todo_vimigo_app/Views/calendarScreen.dart';
import 'package:todo_vimigo_app/Views/todoScreen.dart';

import '../Controllers/tasksController.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  bool _init = false;
  @override
  void didChangeDependencies() {
    if (!_init) {
      TasksController().initTasks(context).then((_) {
        setState(() {
          _init = true;
        });
      });
      super.didChangeDependencies();
    }
  }

  final List<Map<String, Object>> _pages = [
    {"page": const TodoScreen(), "title": "Tasks"},
    {"page": const CalendarScreen(), "title": "Calendar"},
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
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
            _pages[_selectedPageIndex]["title"] as String,
            textAlign: TextAlign.center,
          ),
        )),
        body: !_init
            ? const Center(child: CircularProgressIndicator())
            : _pages[_selectedPageIndex]["page"] as Widget,
        bottomNavigationBar: BottomNavigationBar(
            onTap: _selectPage,
            backgroundColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.cyan,
            selectedItemColor: Colors.white,
            currentIndex: _selectedPageIndex,
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
        floatingActionButton: _selectedPageIndex == 0
            ? FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () => startAddTaskBottomSheet(context),
                child: const Icon(
                  Icons.add,
                ),
              )
            : null);
  }
}
