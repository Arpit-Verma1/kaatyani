import 'package:flutter/material.dart';
import '../models/meeting_request_model.dart';

class MeetingRequestCard extends StatelessWidget {
  final Meeting request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const MeetingRequestCard({
    Key? key,
    required this.request,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text("Meeting with ${request.inviteeId}"),
        subtitle: Text(
          "Room: ${request.room}\nDate: ${request.date}\n Stat On: ${request.startTime} mins",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: onAccept,
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: onDecline,
            ),
          ],
        ),
      ),
    );
  }
}
