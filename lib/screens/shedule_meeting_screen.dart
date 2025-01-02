import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:katyani/models/user_model.dart';
import 'package:katyani/services/firebase_service.dart';

import '../services/fcm_service.dart';
import '../services/shared_pref_service.dart';

class ScheduleMeetingScreen extends StatefulWidget {
  final String selectedUserId;

  const ScheduleMeetingScreen({Key? key, required this.selectedUserId})
      : super(key: key);

  @override
  State<ScheduleMeetingScreen> createState() => _ScheduleMeetingScreenState();
}

class _ScheduleMeetingScreenState extends State<ScheduleMeetingScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedRoom;
  List<String> availableRooms = ['Conference Room 1', 'Conference Room 2'];

  Future<bool> _isTimeSlotAvailable(String userId, DateTime date,
      TimeOfDay start, TimeOfDay end) async {
    final query = await _firestore
        .collection('meetings')
        .where('inviteeId', isEqualTo: userId)
        .where('date', isEqualTo: date
        .toIso8601String()
        .split('T')
        .first)
        .get();

    for (var doc in query.docs) {
      final meetingData = doc.data();
      final existingStart = TimeOfDay.fromDateTime(
          DateTime.parse(meetingData['startTime']));
      final existingEnd = TimeOfDay.fromDateTime(
          DateTime.parse(meetingData['endTime']));

      if (!(end.hour < existingStart.hour ||
          (end.hour == existingStart.hour &&
              end.minute <= existingStart.minute) ||
          start.hour > existingEnd.hour ||
          (start.hour == existingEnd.hour &&
              start.minute >= existingEnd.minute))) {
        return false;
      }
    }
    return true;
  }

  Future<bool> _isRoomAvailable(String room, DateTime date, TimeOfDay start,
      TimeOfDay end) async {
    final query = await _firestore
        .collection('meetings')
        .where('room', isEqualTo: room)
        .where('date', isEqualTo: date
        .toIso8601String()
        .split('T')
        .first)
        .get();

    for (var doc in query.docs) {
      final meetingData = doc.data();
      final existingStart = TimeOfDay.fromDateTime(
          DateTime.parse(meetingData['startTime']));
      final existingEnd = TimeOfDay.fromDateTime(
          DateTime.parse(meetingData['endTime']));

      if (!(end.hour < existingStart.hour ||
          (end.hour == existingStart.hour &&
              end.minute <= existingStart.minute) ||
          start.hour > existingEnd.hour ||
          (start.hour == existingEnd.hour &&
              start.minute >= existingEnd.minute))) {
        return false;
      }
    }
    return true;
  }

  Future<void> _scheduleMeeting() async {
    String? currentUserId = await SharedPrefService.getUser();
    Map<String, dynamic>? userData = await FirebaseService().getUserById(
        currentUserId!);
    UserModel currUser = UserModel.fromMap(userData!);
    if (_formKey.currentState!.validate()) {
      if (selectedDate == null || startTime == null || endTime == null ||
          selectedRoom == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date, time, and room.')),
        );
        return;
      }

      final isUserSlotAvailable = await _isTimeSlotAvailable(
          widget.selectedUserId, selectedDate!, startTime!, endTime!);

      final isRoomSlotAvailable = await _isRoomAvailable(
          selectedRoom!, selectedDate!, startTime!, endTime!);

      if (!isUserSlotAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('The user is unavailable at this time slot.')),
        );
        return;
      }

      if (!isRoomSlotAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'The selected conference room is occupied during this time.')),
        );
        return;
      }

      // Schedule meeting in Firestore
      final meetingId = _firestore.collection('meetings').doc().id;

      await _firestore.collection('meetings').doc(meetingId).set({
        'id': meetingId, // Store the meeting ID
        'inviteeId': widget.selectedUserId,
        'inviteeName': currUser.name,
        'date': selectedDate!
            .toIso8601String()
            .split('T')
            .first,
        'startTime': DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          startTime!.hour,
          startTime!.minute,
        ).toIso8601String(),
        'endTime': DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          endTime!.hour,
          endTime!.minute,
        ).toIso8601String(),
        'room': selectedRoom,
        'status': 'pending',
        'createdBy': currUser.id, // Replace with the logged-in user's ID
      });


      // Send notification to invitee
      final inviteeToken = await _getUserFCMToken(widget.selectedUserId);
      if (inviteeToken != null) {
        await FCMService().sendNotification(
          fcmToken: inviteeToken,
          title: 'Meeting Request',
          body:
          'You have a new meeting request on ${selectedDate!
              .toString()} in $selectedRoom from ${startTime!.format(
              context)} to ${endTime!.format(context)}.',
          data: {
            'type': 'meeting_request',
            'date': selectedDate!
                .toIso8601String()
                .split('T')
                .first,
            'startTime': startTime!.format(context),
            'endTime': endTime!.format(context),
            'room': selectedRoom,
          },
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting scheduled successfully!')),
      );

      Navigator.pop(context);
    }
  }

  Future<String?> _getUserFCMToken(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.data()?['fcmToken'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Meeting'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text(
                    selectedDate == null ? 'Pick a Date' : selectedDate
                        .toString()),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      startTime = pickedTime;
                    });
                  }
                },
                child: Text(startTime == null
                    ? 'Select Start Time'
                    : startTime!.format(context)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      endTime = pickedTime;
                    });
                  }
                },
                child: Text(endTime == null
                    ? 'Select End Time'
                    : endTime!.format(context)),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedRoom,
                hint: const Text('Select a Conference Room'),
                items: availableRooms.map((room) {
                  return DropdownMenuItem<String>(
                    value: room,
                    child: Text(room),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRoom = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a room.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _scheduleMeeting,
                child: const Text('Schedule Meeting'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
