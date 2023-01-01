import 'package:flutter/material.dart';

class ReminderDateTimePicker extends StatelessWidget {
  final chosenDate;
  final chosenTime;
  final timeController;
  final presentDateTimePicker;
  const ReminderDateTimePicker(
      {super.key,
      required this.chosenDate,
      required this.chosenTime,
      required this.timeController,
      required this.presentDateTimePicker});

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
                prefixIconConstraints: const BoxConstraints.tightForFinite(),
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
        // Expanded(
        //   child: TextFormField(
        //       readOnly: true,
        //       controller: timeController,
        //       onTap: () => Navigator.of(context).push(
        //             showPicker(
        //               context: context,
        //               value: chosenTime != null
        //                   ? chosenTime!
        //                   : chosenDate != null
        //                       ? TimeOfDay.fromDateTime(chosenDate!).replacing(
        //                           hour: TimeOfDay.now().hour,
        //                           minute: TimeOfDay.now().minute + 1)
        //                       : TimeOfDay.now().replacing(
        //                           minute: TimeOfDay.now().minute + 1),
        //               onChange: onTimeChanged,
        //             ),
        //           ),
        //       textAlign: TextAlign.center,
        //       decoration: InputDecoration(
        //         // prefixIcon: const Icon(Icons.calendar_month),
        //         prefixIconConstraints: const BoxConstraints.tightForFinite(),
        //         label: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             const Text("Reminder Time"),
        //             Icon(
        //               Icons.timelapse,
        //               color: Theme.of(context).colorScheme.primary,
        //             )
        //           ],
        //         ),
        //         border: InputBorder.none,
        //         floatingLabelAlignment: FloatingLabelAlignment.center,
        //       )),
        // ),
      ],
    );
  }
}
