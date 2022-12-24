import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  var _taskToEdit = Task(id: "", title: "");
  var _isInit = false;
  final _dateController = TextEditingController();
  final _datePickerNode = FocusNode();
  late int _taskIndex;
  var _initValue = Task(id: "", title: "");

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _taskIndex = ModalRoute.of(context)?.settings.arguments as int;
      _initValue = TasksController().getTaskAtIndex(context, _taskIndex);
      _taskToEdit = TasksController().getTaskAtIndex(context, _taskIndex);
      _chosenDate = _taskToEdit.date;
      if (_chosenDate == null) {
        _dateController.text = "No Date Chosen";
      } else {
        _dateController.text = DateFormat("dd/MM/yyyy").format(_chosenDate!);
      }
    }
    _isInit = true;

    super.didChangeDependencies();
  }

  void _saveForm() {
    // if (!(_form.currentState?.validate())!) {
    //   return;
    // }
    _form.currentState?.save();

    _taskToEdit = _taskToEdit.copyWith(id: _taskToEdit.id, date: _chosenDate);
    TasksController().updateTask(context, _taskToEdit.id, _taskToEdit);
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
        _dateController.text = DateFormat("dd/MM/yyyy").format(_chosenDate!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View/Edit Task"),
        actions: [
          IconButton(
              onPressed: () {
                TasksController().removeTask(context, _taskIndex);
                Navigator.of(context).pop(argumentsEditToTodo.deleted);
              },
              icon: const Icon(Icons.delete_forever_outlined)),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          _saveForm();

          Navigator.of(context).pop(_initValue.title == _taskToEdit.title &&
                  _initValue.date == _taskToEdit.date &&
                  _initValue.description == _taskToEdit.description
              ? argumentsEditToTodo.none
              : argumentsEditToTodo.edited);
          return true;
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Form(
              key: _form,
              child: ListView(
                children: [
                  TextFormField(
                    maxLength: 60,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    textAlign: TextAlign.center,
                    initialValue: _taskToEdit.title,
                    decoration: InputDecoration(
                      label: RichText(
                          text: const TextSpan(
                              style: TextStyle(color: Colors.black),
                              text: "Title",
                              children: [
                            TextSpan(
                                text: '*', style: TextStyle(color: Colors.red))
                          ])),
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a valid title";
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _saveForm(),
                    onSaved: (newValue) =>
                        {_taskToEdit = _taskToEdit.copyWith(title: newValue)},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      focusNode: _datePickerNode,
                      readOnly: true,
                      controller: _dateController,
                      onTap: _presentDatePicker,
                      decoration: const InputDecoration(
                        labelText: "Date",
                        border: InputBorder.none,
                        // suffixIconColor: Theme.of(context).colorScheme.primary,
                        prefixIcon: Icon(Icons.edit),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLength: 250,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    initialValue: _taskToEdit.description,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: InputBorder.none,
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    minLines: 1,
                    maxLines: 15,
                    onFieldSubmitted: (_) => _saveForm(),
                    onSaved: (newValue) => {
                      _taskToEdit = _taskToEdit.copyWith(description: newValue)
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
