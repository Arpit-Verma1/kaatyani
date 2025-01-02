import 'package:flutter/material.dart';

class DateTimePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Date and Time"),
        ElevatedButton(
          onPressed: () async {
            DateTime? dateTime = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            // Handle date selection
          },
          child: Text("Pick Date"),
        ),
      ],
    );
  }
}
