import 'package:flutter/material.dart';

class UserSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text("Select User"),
      items: [
        DropdownMenuItem(value: "user1", child: Text("User 1")),
        DropdownMenuItem(value: "user2", child: Text("User 2")),
      ],
      onChanged: (value) {
        // Handle user selection
      },
    );
  }
}
