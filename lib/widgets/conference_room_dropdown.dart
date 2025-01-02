import 'package:flutter/material.dart';

class ConferenceRoomDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text("Select Room"),
      items: [
        DropdownMenuItem(value: "room1", child: Text("Conference Room 1")),
        DropdownMenuItem(value: "room2", child: Text("Conference Room 2")),
      ],
      onChanged: (value) {
        // Handle room selection
      },
    );
  }
}
