import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<bool> _isTimeSlotAvailable(
      String userId, DateTime date, TimeOfDay start, TimeOfDay end) async {
    final query = await _firestore
        .collection('meetings')
        .where('inviteeId', isEqualTo: userId)
        .where('date', isEqualTo: date.toIso8601String().split('T').first)
        .get();

    for (var doc in query.docs) {
      final meetingData = doc.data();
      final existingStart =
          TimeOfDay.fromDateTime(DateTime.parse(meetingData['startTime']));
      final existingEnd =
          TimeOfDay.fromDateTime(DateTime.parse(meetingData['endTime']));

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

  Future<bool> _isRoomAvailable(
      String room, DateTime date, TimeOfDay start, TimeOfDay end) async {
    final query = await _firestore
        .collection('meetings')
        .where('room', isEqualTo: room)
        .where('date', isEqualTo: date.toIso8601String().split('T').first)
        .get();

    for (var doc in query.docs) {
      final meetingData = doc.data();
      final existingStart =
          TimeOfDay.fromDateTime(DateTime.parse(meetingData['startTime']));
      final existingEnd =
          TimeOfDay.fromDateTime(DateTime.parse(meetingData['endTime']));

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
    Map<String, dynamic>? userData =
        await FirebaseService().getUserById(currentUserId!);
    UserModel currUser = UserModel.fromMap(userData!);
    if (_formKey.currentState!.validate()) {
      if (selectedDate == null ||
          startTime == null ||
          endTime == null ||
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
        'date': selectedDate!.toIso8601String().split('T').first,
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
              'You have a new meeting request on ${selectedDate!.toString()} in $selectedRoom from ${startTime!.format(context)} to ${endTime!.format(context)}.',
          data: {
            'type': 'meeting_request',
            'date': selectedDate!.toIso8601String().split('T').first,
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

  String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Meeting'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Picker
              Text(
                'Select Meeting Date',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade600, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate == null
                            ? 'Pick a Date'
                            : _formatDate(selectedDate!),
                        style: TextStyle(
                          color: selectedDate == null
                              ? Colors.grey.shade500
                              : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Start Time Picker
              Text(
                'Select Start Time',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      startTime = pickedTime;
                      endTime = null; // Reset end time if start time changes
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade600, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        startTime == null
                            ? 'Select Start Time'
                            : startTime!.format(context),
                        style: TextStyle(
                          color: startTime == null
                              ? Colors.grey.shade500
                              : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.access_time, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // End Time Picker
              Text(
                'Select End Time',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: startTime == null
                    ? null
                    : () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: startTime!.replacing(
                            minute: startTime!.minute + 1,
                          ),
                        );
                        if (pickedTime != null &&
                            (pickedTime.hour > startTime!.hour ||
                                (pickedTime.hour == startTime!.hour &&
                                    pickedTime.minute > startTime!.minute))) {
                          setState(() {
                            endTime = pickedTime;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'End time must be after the start time!'),
                            ),
                          );
                        }
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade600, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        endTime == null
                            ? 'Select End Time'
                            : endTime!.format(context),
                        style: TextStyle(
                          color: endTime == null
                              ? Colors.grey.shade500
                              : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.access_time, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Room Selection
              Text(
                'Select Conference Room',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedRoom,
                hint: const Text(
                  'Select a Room',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8A8A8A), // Subtle gray for hint
                  ),
                ),
                items: availableRooms.map((room) {
                  return DropdownMenuItem<String>(
                    value: room,
                    child: Text(
                      room,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333), // Dark gray for items
                      ),
                    ),
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
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),

                  // Light gray background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 1.5,
                    ),
                  ),
                ),
                dropdownColor: const Color(0xFFFFFFFF),
                // White background for dropdown
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF333333), // Matches with text color
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              Center(
                child: GestureDetector(
                  onTap: _scheduleMeeting,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF), // Professional blue
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          // Subtle shadow for depth
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Schedule Meeting',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            // Semi-bold for readability
                            fontFamily:
                                'Roboto', // Professional industry-standard font
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
