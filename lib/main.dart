import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_vimigo_app/Models/task.dart';
import 'package:todo_vimigo_app/Models/tasks.dart';
import 'package:todo_vimigo_app/Views/Screens/editTask_screen.dart';
import 'package:todo_vimigo_app/Views/Screens/onboarding_screen.dart';
import 'package:todo_vimigo_app/Views/Screens/settings_screen.dart';
import 'package:todo_vimigo_app/Views/Screens/tabsScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool("showHome") ?? false;
  runApp(MyApp(
    showHome: showHome,
  ));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  const MyApp({super.key, required this.showHome});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Tasks(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.blue,
              secondary: Colors.lightBlue[50],
              tertiary: Colors.green),
        ),
        routes: {
          "/": (ctx) =>
              showHome ? const TabsScreen() : const OnBoardingScreen(),
          TabsScreen.routeName: (ctx) => const TabsScreen(),
          EditTask.routeName: (ctx) => const EditTask(),
          SettingsScreen.routeName: (ctx) => const SettingsScreen(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
              builder: (ctx) =>
                  showHome ? const TabsScreen() : const OnBoardingScreen());
        },
      ),
    );
  }
}
