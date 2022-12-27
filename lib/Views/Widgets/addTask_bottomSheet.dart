import 'package:flutter/material.dart';
import 'package:todo_vimigo_app/Controllers/tasksController.dart';
import 'package:todo_vimigo_app/Models/task.dart';
import 'package:intl/intl.dart';
import 'package:todo_vimigo_app/utils.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
  late TutorialCoachMark tutorialCoachMark;

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  initState() {
    tutorialCoachMark = createTutorial(context, _createTargets);
    Future.delayed(const Duration(seconds: 1), showTutorial);
    super.initState();
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    targets.add(
      TargetFocus(
        shape: ShapeLightFocus.RRect,
        identify: "AddTaskBtn",
        keyTarget: keyNewTaskCalendarBtn,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FittedBox(
                      child: Text(
                        "• Tap this button to choose a date\n• This will show the task in Calendar View",
                        style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    return targets;
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
                  key: keyTitleTextForm,
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
                          key: keyNewTaskCalendarBtn,
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
