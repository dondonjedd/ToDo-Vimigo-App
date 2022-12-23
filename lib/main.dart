import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_vimigo_app/Models/tasks.dart';
import 'package:todo_vimigo_app/Views/tabsScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                ),
          ),
          routes: {
            "/": (ctx) => const TabsScreen(),
          },

          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (ctx) => const TabsScreen());
          },
          ),
    );
  }
}
