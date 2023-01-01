import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DueDatePicker extends StatelessWidget {
  final presentDatePicker;
  final dateController;
  const DueDatePicker(
      {super.key,
      required this.presentDatePicker,
      required this.dateController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        readOnly: true,
        controller: dateController,
        onTap: presentDatePicker,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          // prefixIcon: const Icon(Icons.calendar_month),
          prefixIconConstraints: const BoxConstraints.tightForFinite(),
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
        ));
  }
}
