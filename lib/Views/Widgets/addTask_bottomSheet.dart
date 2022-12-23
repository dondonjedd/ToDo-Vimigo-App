import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';
import 'package:todo_vimigo_app/Models/task.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final _titleController = TextEditingController();
  DateTime? _chosenDate;

  submitData(BuildContext ctx) {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty) {
      return;
    }
    Task newTask = Task(
        id: DateTime.now().toString(),
        title: _titleController.text,
        date: _chosenDate);
    TasksController().insertTask(context, 0, newTask);
    Navigator.of(context).pop();
  }

  _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _chosenDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Card(
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              decoration: InputDecoration(
                  labelText: "Title",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {},
                  )),
              autofocus: true,
              controller: _titleController,
              onSubmitted: (_) => submitData(context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _chosenDate == null
                    ? const Text("No date chosen")
                    : Text(DateFormat("dd/MM/yyyy").format(_chosenDate!)),
                TextButton(
                    onPressed: _presentDatePicker,
                    child: Text(
                      "Choose a date",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    )),
                TextButton(
                    onPressed: () {}, child: const Text("Add Description"))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
