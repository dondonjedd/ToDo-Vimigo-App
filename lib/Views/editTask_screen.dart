import 'package:flutter/material.dart';

import '../Controllers/tasksController.dart';
import '../Models/task.dart';
import '../utils.dart';

class EditTask extends StatefulWidget {
  const EditTask({super.key});
  static const routeName = "/edit-task";
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  // final _titleController = TextEditingController();
  // final _descriptionController = TextEditingController();
  // DateTime? _chosenDate;
  // final _form = GlobalKey<FormState>();
  // var _newTaskToAdd = Task(id: "", title: "");
  // final _descriptionFocusNode = FocusNode();
  // final _titleFocusNode = FocusNode();

  // void _saveForm() {
  //   if (!(_form.currentState?.validate())!) {
  //     return;
  //   }
  //   _form.currentState?.save();
  //   _newTaskToAdd = _newTaskToAdd.copyWith(
  //       id: DateTime.now().toString(), date: _chosenDate);
  //   TasksController().insertTask(context, 0, _newTaskToAdd);

  //   showScaffold(context,
  //       text: "Task Edited",
  //       bgColor: Theme.of(context).colorScheme.tertiary,
  //       textColor: Theme.of(context).colorScheme.onSecondary,
  //       duration: const Duration(seconds: 1));

  //   Navigator.of(context).pop();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("test")),
    );
    // return Form(
    //     child: SingleChildScrollView(
    //   child: Column(mainAxisSize: MainAxisSize.min, children: [
    //             TextFormField(
    //               validator: (value) {
    //                 if (value!.isEmpty) {
    //                   return "Please enter a valid title";
    //                 }
    //                 return null;
    //               },
    //               decoration: InputDecoration(
    //                   labelText: "Title",
    //                   suffixIcon: IconButton(
    //                     icon: const Icon(Icons.add),
    //                     onPressed: () {
    //                       _saveForm();
    //                     },
    //                   )),
    //               autofocus: true,
    //               controller: _titleController,
    //               onFieldSubmitted: (_) => _saveForm(),
    //               focusNode: _titleFocusNode,
    //               onSaved: (newValue) =>
    //                   {_newTaskToAdd = _newTaskToAdd.copyWith(title: newValue)},
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 15),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   _chosenDate == null
    //                       ? const Text("No Date Chosen")
    //                       : Text(DateFormat("dd/MM/yyyy").format(_chosenDate!)),
    //                   ElevatedButton(
    //                       onPressed: _presentDatePicker,
    //                       child: const Text(
    //                         "Choose a date",
    //                       )),
    //                 ],
    //               ),
    //             ),
    //             ExpansionTile(
    //               title: const Text(
    //                 "Add Description",
    //                 style: TextStyle(fontSize: 14),
    //               ),
    //               onExpansionChanged: (val) {
    //                 if (val) {
    //                   _descriptionFocusNode.requestFocus();
    //                 }
    //               },
    //               children: [
    //                 TextFormField(
    //                   focusNode: _descriptionFocusNode,
    //                   controller: _descriptionController,
    //                   decoration: const InputDecoration(
    //                       hintText: "Description",
    //                       hintStyle: TextStyle(fontSize: 13)),
    //                   onFieldSubmitted: (_) => _saveForm(),
    //                   onSaved: (newValue) => {
    //                     _newTaskToAdd =
    //                         _newTaskToAdd.copyWith(description: newValue)
    //                   },
    //                 )
    //               ],
    //             ),
    //           ]),
    // ));
  }
}
