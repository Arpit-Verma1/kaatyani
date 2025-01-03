import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:katyani/models/meeting_request_model.dart';
import 'package:katyani/services/firebase_service.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Meeting> _pendingMeetings = [];
  bool _isLoading = false;

  List<Meeting> get pendingMeetings => _pendingMeetings;

  bool get isLoading => _isLoading;

  Future<void> fetchPendingMeetings() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Map<String, dynamic>> allMeetings =await  FirebaseService().getPendingRequests();
      print("all meeting are $allMeetings");
      _pendingMeetings = allMeetings.map((meeting) {
        return Meeting.fromJson(meeting);
      }).toList();
      print("pending meetings are ${pendingMeetings.length}");
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching accepted meetings: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeMeeting(int index){
    pendingMeetings.removeAt(index);
    notifyListeners();
  }
}
