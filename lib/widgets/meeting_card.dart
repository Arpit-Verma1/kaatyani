import 'package:flutter/material.dart';

import '../utils/date_time_util.dart';

class MeetingCard extends StatelessWidget {
  final Map<String, dynamic> meeting;

  const MeetingCard({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meeting with ${meeting['inviteeName']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Date: ${meeting['date']}'),
            Text('Time: ${DateTimeUtil.formatTimestampToTime(meeting['startTime'])}'),
            Text('Room: ${meeting['room']}'),
          ],
        ),
      ),
    );
  }
}
