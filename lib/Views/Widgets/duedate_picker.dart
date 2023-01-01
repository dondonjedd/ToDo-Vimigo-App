import 'package:flutter/material.dart';

class DueDatePicker extends StatelessWidget {
  final presentDatePicker;
  final dateController;
  final clearDueDate;
  const DueDatePicker(
      {super.key,
      required this.presentDatePicker,
      required this.dateController,
      required this.clearDueDate});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        readOnly: true,
        controller: dateController,
        onTap: presentDatePicker,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: clearDueDate, icon: const Icon(Icons.clear)),
          // suffixIconConstraints: const BoxConstraints.tightForFinite(),
          prefixIcon: const Text(""),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Due Date"),
              Icon(
                Icons.calendar_month,
                color: Theme.of(context).colorScheme.primary,
              )
            ],
          ),
          border: InputBorder.none,
          floatingLabelAlignment: FloatingLabelAlignment.center,
        ));
  }
}
