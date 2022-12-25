import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';
import 'package:todo_vimigo_app/Models/task.dart';
import 'package:intl/intl.dart';
import 'package:todo_vimigo_app/utils.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _chosenDate;
  final _form = GlobalKey<FormState>();
  var _newTaskToAdd = Task(id: "", title: "");
  final _descriptionFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  var _isLoadingAdding = false;

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: kFirstDay,
            lastDate: kLastDay)
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
    setState(() {
      _isLoadingAdding = true;
    });

    if (!(_form.currentState?.validate())!) {
      return;
    }
    _form.currentState?.save();
    _newTaskToAdd = _newTaskToAdd.copyWith(
        id: DateTime.now().toString(), date: _chosenDate);
    TasksController().insertTask(context, 0, _newTaskToAdd).then((_) {
      showScaffold(context,
          text: "Task Added",
          bgColor: Theme.of(context).colorScheme.tertiary,
          textColor: Theme.of(context).colorScheme.onSecondary,
          duration: const Duration(seconds: 1));
      Navigator.of(context).pop();
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
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                _isLoadingAdding
                    ? LinearProgressIndicator(
                        color: Theme.of(context).colorScheme.tertiary,
                      )
                    : const SizedBox(
                        height: 1,
                      ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a valid title";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Title"),
                            Text(
                              "*",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            )
                          ]),
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _saveForm();
                        },
                      )),
                  autofocus: true,
                  controller: _titleController,
                  onFieldSubmitted: (_) => _saveForm(),
                  focusNode: _titleFocusNode,
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
                          : Text(
                              "Chosen Date: ${DateFormat("dd/MM/yyyy").format(_chosenDate!)}"),
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
                  onExpansionChanged: (val) {
                    if (val) {
                      _descriptionFocusNode.requestFocus();
                    }
                  },
                  children: [
                    TextFormField(
                      focusNode: _descriptionFocusNode,
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
