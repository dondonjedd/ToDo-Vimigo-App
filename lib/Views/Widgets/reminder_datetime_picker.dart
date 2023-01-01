import 'package:flutter/material.dart';

class ReminderDateTimePicker extends StatelessWidget {
  final chosenDate;
  final chosenTime;
  final timeController;
  final presentDateTimePicker;
  final clearReminder;
  const ReminderDateTimePicker(
      {super.key,
      required this.chosenDate,
      required this.chosenTime,
      required this.timeController,
      required this.presentDateTimePicker,
      required this.clearReminder});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
              readOnly: true,
              controller: timeController,
              onTap: presentDateTimePicker,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                // prefixIcon: const Icon(Icons.calendar_month),
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
              )),
        ),
      ],
    );
  }
}
