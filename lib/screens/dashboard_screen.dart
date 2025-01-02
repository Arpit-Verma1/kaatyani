import 'package:flutter/material.dart';
import 'package:katyani/providers/dashBoard_provider.dart';
import 'package:katyani/screens/user_list_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/meeting_card.dart';
import 'notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});


  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<DashboardProvider>(context,listen: false).fetchAcceptedMeetings();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sheduled Meetings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UsersListScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, dashPrv, child) {
          if (dashPrv.isLoading == true)
            return Center(
              child: CircularProgressIndicator(),
            );
          else
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: dashPrv.acceptedMeetings.length,
              itemBuilder: (context, index) {
                return MeetingCard(meeting: dashPrv.acceptedMeetings[index]);
              },
            );
        },
      ),
    );
  }
}
