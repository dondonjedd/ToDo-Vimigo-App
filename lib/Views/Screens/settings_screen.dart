import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils.dart';
import '../Widgets/main_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static const routeName = "/settings-screen";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _tutorialDone = false;
  late bool _init = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    final prefs = await SharedPreferences.getInstance();
    bool tabsScreen = prefs.getBool("tabsScreen") ?? false;
    bool todoScreen1 = prefs.getBool("todoScreen1") ?? false;
    bool todoScreen2 = prefs.getBool("todoScreen2") ?? false;
    bool addTaskSheet = prefs.getBool("addTaskSheet") ?? false;
    bool calendarScreen = prefs.getBool("calendarScreen") ?? false;

    setState(() {
      _tutorialDone = (tabsScreen &&
          todoScreen1 &&
          todoScreen2 &&
          addTaskSheet &&
          calendarScreen);
      _init = true;
    });
  }

  Widget builSwitchListTile(Widget title, Widget subtitle, bool currentValue,
      Function(bool) updateValue) {
    return SwitchListTile(
        title: title,
        subtitle: subtitle,
        value: currentValue,
        onChanged: updateValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
            ),
            Text(
              "General",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
                child: ListView(
              children: [
                builSwitchListTile(
                    const Text("Tutorial status"),
                    _tutorialDone
                        ? const Text("Tutorial done - Uncheck to restart")
                        : const Text("Tutorial in progress"),
                    _tutorialDone, (newValue) {
                  if (newValue == false) {
                    setState(() {
                      _tutorialDone = false;
                    });
                    resetTutorial(false);
                  } else {
                    setState(() {
                      _tutorialDone = true;
                    });
                    resetTutorial(true);
                  }
                }),
              ],
            ))
          ],
        ));
  }
}
