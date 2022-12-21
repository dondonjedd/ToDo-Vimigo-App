import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Views/mainScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.blue,
                secondary: Colors.lightBlue[50],
              ),
        ),
        home: const MainScreen());
  }
}
