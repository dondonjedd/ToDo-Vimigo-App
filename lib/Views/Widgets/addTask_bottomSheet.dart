import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';
import 'package:todo_vimigo_app/Models/task.dart';
import 'package:intl/intl.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _chosenDate;
  final _form = GlobalKey<FormState>();
  var _newTaskToAdd = Task(id: "", title: "");

  submitData(BuildContext ctx) {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty) {
      return;
    }
    Task newTask = Task(
        id: DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        date: _chosenDate);
    TasksController().insertTask(context, 0, newTask);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
      content: Text(
        "Task Added",
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2),
    ));
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

  void _saveForm() {
    if (!(_form.currentState?.validate())!) {
      return;
    }
    _form.currentState?.save();
    _newTaskToAdd = _newTaskToAdd.copyWith(
        id: DateTime.now().toString(), date: _chosenDate);
    TasksController().insertTask(context, 0, _newTaskToAdd);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      content: Text(
        "Task Added",
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      ),
      duration: const Duration(seconds: 2),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Card(
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a valid title";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Title",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _saveForm();
                        },
                      )),
                  autofocus: true,
                  controller: _titleController,
                  onFieldSubmitted: (_) => _saveForm(),
                  onSaved: (newValue) =>
                      {_newTaskToAdd = _newTaskToAdd.copyWith(title: newValue)},
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _chosenDate == null
                          ? const Text("No Date Chosen")
                          : Text(DateFormat("dd/MM/yyyy").format(_chosenDate!)),
                      ElevatedButton(
                          onPressed: _presentDatePicker,
                          child: const Text(
                            "Choose a date",
                          )),
                    ],
                  ),
                ),
                ExpansionTile(
                  title: const Text(
                    "Add Description",
                    style: TextStyle(fontSize: 14),
                  ),
                  children: [
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          hintText: "Description",
                          hintStyle: TextStyle(fontSize: 13)),
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (newValue) => {
                        _newTaskToAdd =
                            _newTaskToAdd.copyWith(description: newValue)
                      },
                    )
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
