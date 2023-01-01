import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';

class ReminderDateTimePicker extends StatelessWidget {
  final Function(TimeOfDay) onTimeChanged;
  final chosenDate;
  final chosenTime;
  final timeController;
  const ReminderDateTimePicker(
      {super.key,
      required this.onTimeChanged,
      required this.chosenDate,
      required this.chosenTime,
      required this.timeController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        readOnly: true,
        controller: timeController,
        onTap: () => Navigator.of(context).push(
              showPicker(
                context: context,
                value: chosenTime != null
                    ? chosenTime!
                    : chosenDate != null
                        ? TimeOfDay.fromDateTime(chosenDate!).replacing(
                            hour: TimeOfDay.now().hour,
                            minute: TimeOfDay.now().minute + 1)
                        : TimeOfDay.now()
                            .replacing(minute: TimeOfDay.now().minute + 1),
                onChange: onTimeChanged,
              ),
            ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          // prefixIcon: const Icon(Icons.calendar_month),
          prefixIconConstraints: const BoxConstraints.tightForFinite(),
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
        ));
  }
}
