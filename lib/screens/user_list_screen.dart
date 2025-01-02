import 'package:flutter/material.dart';
import 'package:katyani/screens/shedule_meeting_screen.dart';
import '../widgets/user_card.dart';
import '../services/firebase_service.dart';
class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: FutureBuilder(
        future: FirebaseService().getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final users = snapshot.data ?? [];
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserCard(
                user: users[index],
                onAdd: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleMeetingScreen( selectedUserId: users[index].id,),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
