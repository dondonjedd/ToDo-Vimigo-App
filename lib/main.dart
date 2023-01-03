import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:provider/provider.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final bool showHome = true;

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
              showHome ? const OnBoardingScreen() : const TabsScreen(),
          EditTask.routeName: (ctx) => const EditTask(),
          SettingsScreen.routeName: (ctx) => const SettingsScreen(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
              builder: (ctx) =>
                  showHome ? const OnBoardingScreen() : const TabsScreen());
        },
      ),
    );
  }
}
