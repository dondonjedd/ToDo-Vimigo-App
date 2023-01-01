import 'package:flutter/material.dart';

class ReminderDateTimePicker extends StatelessWidget {
  final DateTime? chosenReminderDateTime;
  final reminderDateTimeController;
  final presentDateTimePicker;
  final clearReminder;
  const ReminderDateTimePicker(
      {super.key,
      required this.chosenReminderDateTime,
      required this.reminderDateTimeController,
      required this.presentDateTimePicker,
      required this.clearReminder});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: (_) {
          if (chosenReminderDateTime == null) {
            return null;
          }
          if (chosenReminderDateTime!.isBefore(DateTime.now())) {
            return "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tReminder needs to be in the future";
          }
          return null;
        },
        readOnly: true,
        controller: reminderDateTimeController,
        onTap: presentDateTimePicker,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: clearReminder,
          ),
          prefixIcon: const Text(""),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Reminder Date"),
              Icon(
                Icons.timelapse,
                color: Theme.of(context).colorScheme.primary,
              )
            ],
          ),
          border: InputBorder.none,
          floatingLabelAlignment: FloatingLabelAlignment.center,
        ));
  }
}
