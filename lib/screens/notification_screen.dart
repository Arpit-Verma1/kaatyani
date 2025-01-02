import 'package:flutter/material.dart';
import 'package:katyani/providers/dashBoard_provider.dart';
import 'package:katyani/providers/meeting_provider.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import '../utils/date_time_util.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the pending meetings on screen load
    Provider.of<NotificationProvider>(context, listen: false)
        .fetchPendingMeetings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Consumer<NotificationProvider>(
        builder: (context, notifPrv, child) {
          if (notifPrv.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: notifPrv.pendingMeetings.length,
              itemBuilder: (context, index) {
                final meeting = notifPrv.pendingMeetings[index];
                return Card(
                  elevation: 10,
                  margin: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Meeting Title
                        Text(
                          'Meeting with ${meeting.inviteeName}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Meeting Details
                        Text(
                          'Date: ${meeting.date} | Time: ${meeting
                              .date} | Room: ${meeting.date}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Action Buttons (Accept / Decline)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Accept Button
                            SizedBox(
                              height: 40,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.4, // Set width proportionally
                              child: ElevatedButton(
                                onPressed: () async {
                                  await FirebaseService().updateMeetingStatus(
                                      meeting.id, 'accepted');
                                  Provider.of<DashboardProvider>(
                                      context, listen: false).addMeeting(
                                      meeting);
                                  notifPrv.removeMeeting(index);
                                  setState(() {

                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  // Green for accepted
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  'Accept',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Decline Button
                            SizedBox(
                              height: 40,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.4, // Set width proportionally
                              child: ElevatedButton(
                                onPressed: () async {
                                  await FirebaseService().updateMeetingStatus(
                                      meeting.id, 'declined');
                                  notifPrv.removeMeeting(index);
                                  setState(() {

                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF44336),
                                  // Red for declined
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  'Decline',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
