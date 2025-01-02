import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:katyani/models/meeting_request_model.dart';
import 'package:katyani/services/firebase_service.dart';

class DashboardProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Meeting> _acceptedMeetings = [];
  bool _isLoading = false;

  List<Meeting> get acceptedMeetings => _acceptedMeetings;

  bool get isLoading => _isLoading;

  Future<void> fetchAcceptedMeetings() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Map<String, dynamic>> allMeetings =
          await FirebaseService().getAcceptedMeetings();
      _acceptedMeetings = allMeetings.map((meeting) {
        return Meeting.fromJson(meeting);
      }).toList();
      print("accepted meetings are $_acceptedMeetings");
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching accepted meetings: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addMeeting(Meeting newMeeting)async {
    _acceptedMeetings.add(newMeeting);
    notifyListeners();
  }
}
