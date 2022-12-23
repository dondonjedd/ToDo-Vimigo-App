import 'package:flutter/material.dart';

class AddNewTask extends StatelessWidget {
  AddNewTask({super.key});

  final _titleController = TextEditingController();

  submitData() {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty) {
      return;
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            decoration: const InputDecoration(labelText: "Title"),
            autofocus: true,
            controller: _titleController,
            onSubmitted: (_) => submitData(),
          ),
        ]),
      ),
    );
  }
}
