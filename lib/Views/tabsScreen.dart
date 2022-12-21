import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Views/calendarScreen.dart';
import 'package:todo_vimigo_app/Views/todoScreen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, Object>> _pages = [
    {"page": const CalendarScreen(), "title": "Calendar"},
    {"page": const TodoScreen(), "title": "Taks"},
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(_pages[_selectedPageIndex]["title"] as String)),
      body: _pages[_selectedPageIndex]["page"] as Widget,
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
    );
  }
}
