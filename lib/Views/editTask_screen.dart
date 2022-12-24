import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';
import 'package:intl/intl.dart';
import '../Models/task.dart';
import '../utils.dart';

class EditTask extends StatefulWidget {
  const EditTask({super.key});
  static const routeName = "/edit-task";
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  DateTime? _chosenDate;
  final _form = GlobalKey<FormState>();
  var _newTaskToAdd = Task(id: "", title: "");
  final _descriptionFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  var _isInit = false;
  late Task _taskToEdit;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (!_isInit) {
      final taskIndex = ModalRoute.of(context)?.settings.arguments as int;
      _taskToEdit = TasksController().getTaskAtIndex(context, taskIndex);
      _chosenDate = _taskToEdit.date;
    }
    _isInit = true;

    super.didChangeDependencies();
  }

  void _saveForm() {
    if (!(_form.currentState?.validate())!) {
      return;
    }
    _form.currentState?.save();
    _newTaskToAdd = _newTaskToAdd.copyWith(
        id: DateTime.now().toString(), date: _chosenDate);
    TasksController().insertTask(context, 0, _newTaskToAdd);

    Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_taskToEdit.title)),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Form(
            child: Column(children: [
          TextFormField(
            initialValue: _taskToEdit.title,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter a valid title";
              }
              return null;
            },
            autofocus: true,
            onFieldSubmitted: (_) => _saveForm(),
            focusNode: _titleFocusNode,
            onSaved: (newValue) =>
                {_newTaskToAdd = _newTaskToAdd.copyWith(title: newValue)},
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
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
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: _taskToEdit.description,
            focusNode: _descriptionFocusNode,
            decoration: const InputDecoration(
                hintText: "Description", hintStyle: TextStyle(fontSize: 13)),
            onFieldSubmitted: (_) => _saveForm(),
            onSaved: (newValue) =>
                {_newTaskToAdd = _newTaskToAdd.copyWith(description: newValue)},
          ),
          const Spacer(),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.primary)),
            onPressed: () {
              _saveForm();
            },
            child: const Icon(Icons.edit),
          )
        ])),
      ),
    );
  }
}