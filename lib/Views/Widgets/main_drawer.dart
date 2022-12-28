import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Views/Screens/settings_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget buildListTile(String title, Icon icon, VoidCallback tapHandler) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 160,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.bottomLeft,
            color: Theme.of(context).colorScheme.primary,
            child: const FittedBox(
              child: Center(
                child: Text(
                  "Vimigo\nTo Do App",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          buildListTile("To Dos", const Icon(Icons.list), () {
            Navigator.of(context).pushReplacementNamed("/");
          }),
          buildListTile("Settings", const Icon(Icons.settings), () {
            Navigator.of(context)
                .pushReplacementNamed(SettingsScreen.routeName);
          }),
        ],
      ),
    );
  }
}
