import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';
import 'package:intl/intl.dart';
import '../../Models/task.dart';
import '../../utils.dart';
import '../Widgets/check_box.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

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
  final _timeController = TextEditingController();
  TimeOfDay? _time;
  final _datePickerNode = FocusNode();
  late int _taskIndex;
  var _initValue = Task(id: "", title: "");
  var _isLoadingEdit = false;

  @override
  void dispose() {
    _datePickerNode.dispose();
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
      if (_time == null) {
        _timeController.text = "No Reminder Set";
      } else {
        _timeController.text = "${_time!.hour}:${_time!.minute}";
      }
    }
    _isInit = true;

    super.didChangeDependencies();
  }

  void _saveForm() {
    if (!(_form.currentState?.validate())!) {
      return;
    }

    setState(() {
      _isLoadingEdit = true;
    });
    _form.currentState?.save();

    if (_chosenDate != null && _time != null) {
      var reminder = DateTime(
        _chosenDate!.year,
        _chosenDate!.month,
        _chosenDate!.day,
        _time!.hour,
        _time!.minute,
      );

      print("id : ${getUniqueNotifIdFromDateStr(_taskToEdit.id)}");
      notifApi.showScheduledNotification(
          // id: (DateTime.parse(_taskToEdit.id)).millisecondsSinceEpoch,
          id: getUniqueNotifIdFromDateStr(_taskToEdit.id),
          title: _taskToEdit.title,
          body: _taskToEdit.description,
          payload: _taskToEdit.id,
          scheduledDate: reminder);
    }

    _taskToEdit = _taskToEdit.copyWith(
        id: _taskToEdit.id,
        date: _chosenDate,
        isCompleted:
            TasksController().getTasks(context)[_taskIndex].isCompleted);
    TasksController()
        .updateTask(context, _taskToEdit.id, _taskToEdit)
        .then((_) {
      Navigator.of(context).pop(_initValue.title == _taskToEdit.title &&
              _initValue.date == _taskToEdit.date &&
              _initValue.description == _taskToEdit.description
          ? argumentsEditToTodo.none
          : argumentsEditToTodo.edited);
    });
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

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      // print("${_time.hour}:${_time.minute}");
      _timeController.text =
          "${_time!.hour}:${_time!.minute.toString().padLeft(2, "0")}";
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

          return false;
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Form(
              key: _form,
              child: ListView(
                children: [
                  _isLoadingEdit
                      ? LinearProgressIndicator(
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                      : const SizedBox(
                          height: 1,
                        ),
                  TextFormField(
                    maxLength: 60,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    textAlign: TextAlign.center,
                    initialValue: _taskToEdit.title,
                    decoration: InputDecoration(
                      prefixIcon: TaskCheckBox(
                        index: _taskIndex,
                      ),
                      suffixIcon: const Text(""),
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
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a valid title";
                      }
                      return null;
                    },
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
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        // prefixIcon: const Icon(Icons.calendar_month),
                        prefixIconConstraints:
                            const BoxConstraints.tightForFinite(),
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Date"),
                            Icon(
                              Icons.calendar_month,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          ],
                        ),
                        border: InputBorder.none,
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      )),
                  TextFormField(
                      readOnly: true,
                      controller: _timeController,
                      onTap: () => Navigator.of(context).push(
                            showPicker(
                              context: context,
                              value: _time != null
                                  ? _time!
                                  : _chosenDate != null
                                      ? TimeOfDay.fromDateTime(_chosenDate!)
                                          .replacing(
                                              hour: TimeOfDay.now().hour,
                                              minute:
                                                  TimeOfDay.now().minute + 1)
                                      : TimeOfDay.now().replacing(
                                          minute: TimeOfDay.now().minute + 1),
                              onChange: onTimeChanged,
                            ),
                          ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        // prefixIcon: const Icon(Icons.calendar_month),
                        prefixIconConstraints:
                            const BoxConstraints.tightForFinite(),
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Reminder"),
                            Icon(
                              Icons.timelapse,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          ],
                        ),
                        border: InputBorder.none,
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLength: 250,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    initialValue: _taskToEdit.description,
                    decoration: InputDecoration(
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Description"),
                        ],
                      ),
                      border: InputBorder.none,
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      alignLabelWithHint: false,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary)),
                    ),
                    minLines: 1,
                    maxLines: 15,
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
