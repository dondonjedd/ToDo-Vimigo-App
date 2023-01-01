import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';
import 'package:intl/intl.dart';
import 'package:todo_vimigo_app/Views/Widgets/duedate_picker.dart';
import 'package:todo_vimigo_app/Views/Widgets/reminder_datetime_picker.dart';
import 'package:todo_vimigo_app/api/notification_api.dart';
import '../../Models/task.dart';
import '../../utils.dart';
import '../Widgets/check_box.dart';

class EditTask extends StatefulWidget {
  const EditTask({super.key});
  static const routeName = "/edit-task";
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  //Due Date Variable
  DateTime? _chosenDate;
  final _dateController = TextEditingController();

  //Reminder Date Time Variable
  DateTime? _chosenReminderDateTime;
  final _reminderDateTimeController = TextEditingController();

  final _form = GlobalKey<FormState>();
  var _taskToEdit = Task(id: "", title: "");
  var _isInit = false;
  late int _taskIndex;
  var _initValue = Task(id: "", title: "");
  var _isLoadingEdit = false;

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _reminderDateTimeController.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _taskIndex = ModalRoute.of(context)?.settings.arguments as int;
      _initValue = TasksController().getTaskAtIndex(context, _taskIndex);
      _taskToEdit = TasksController().getTaskAtIndex(context, _taskIndex);
      _chosenDate = _taskToEdit.date;
      _chosenReminderDateTime = _taskToEdit.reminderDateTime;
      if (_chosenDate == null) {
        _dateController.text = "No Date Chosen";
      } else {
        _dateController.text = DateFormat("dd/MM/yyyy").format(_chosenDate!);
      }
      if (_chosenReminderDateTime == null) {
        _reminderDateTimeController.text = "No Reminder Set";
      } else if(_chosenReminderDateTime!.isBefore(DateTime.now())){
        _reminderDateTimeController.text = "Reminder has passed";
      }else{
        _reminderDateTimeController.text =
            showReminderDateTime(_chosenReminderDateTime!);
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

    if (_chosenReminderDateTime != null) {
      print(
          "Notif added with id : ${getUniqueNotifIdFromDateStr(_taskToEdit.id)}");
      notifApi.showScheduledNotification(
          // id: (DateTime.parse(_taskToEdit.id)).millisecondsSinceEpoch,
          id: getUniqueNotifIdFromDateStr(_taskToEdit.id),
          title: _taskToEdit.title,
          body: _taskToEdit.description,
          payload: _taskToEdit.id,
          scheduledDate: _chosenReminderDateTime!);
    }

    _taskToEdit = _taskToEdit.copyWith(
        date: _chosenDate,
        reminderDateTime: _chosenReminderDateTime,
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

  //Due Date methods
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

  void _clearDueDate() {
    setState(() {
      _chosenDate = null;
      _dateController.text = "No Date Chosen";
    });
  }

  //reminder methods
  _presentDateTimePicker() {
    DatePicker.showDateTimePicker(context, currentTime: _chosenDate)
        .then((value) {
      print(value);
      if (value == null) {
        return;
      }
      setState(() {
        _chosenReminderDateTime = value;
        _reminderDateTimeController.text =
            showReminderDateTime(_chosenReminderDateTime!);
      });
    });
  }

  String showReminderDateTime(DateTime date) {
    return "${DateFormat("dd/MM/yyyy").format(date)} at ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}";
  }

  void _clearReminderDateTime() {
    setState(() {
      _chosenReminderDateTime = null;
      _reminderDateTimeController.text = "No Reminder Set";
      NotificationApi()
          .removeNotif(getUniqueNotifIdFromDateStr(_taskToEdit.id));
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
                  DueDatePicker(
                    presentDatePicker: _presentDatePicker,
                    dateController: _dateController,
                    clearDueDate: _clearDueDate,
                  ),
                  ReminderDateTimePicker(
                    chosenDate: _chosenReminderDateTime,
                    chosenTime: _chosenReminderDateTime,
                    timeController: _reminderDateTimeController,
                    presentDateTimePicker: _presentDateTimePicker,
                    clearReminder: _clearReminderDateTime,
                  ),
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
