import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onAdd;

  const UserCard({super.key, required this.user, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: IconButton(
          icon: const Icon(Icons.add, color: Colors.blue),
          onPressed: onAdd,
        ),
      ),
    );
  }
}
