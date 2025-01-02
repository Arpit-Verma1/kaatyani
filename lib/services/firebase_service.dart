import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:katyani/models/meeting_request_model.dart';

import '../models/user_model.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final userDoc = await firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return userDoc.data(); // Returns user data as a Map
      } else {
        return null; // User not found
      }
    } catch (e) {
      print('Error fetching user by ID: $e');
      return null;
    }
  }

  Future<List<UserModel>> getUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
  }

  Future<List<Map<String, dynamic>>> getAcceptedMeetings() async {
    final snapshot = await _firestore
        .collection('meetings')
        .where('status', isEqualTo: 'accepted')
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future< List<Map<String, dynamic>>> getPendingRequests() async {
    final snapshot = await _firestore
        .collection('meetings')
        .where('status', isEqualTo: 'pending')
        .get();


    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<bool> scheduleMeeting({
    required UserModel invitee,
    required String date,
    required String time,
    required String room,
  }) async {
    try {
      await _firestore.collection('meetings').add({
        'inviteeName': invitee.name,
        'date': date,
        'time': time,
        'room': room,
        'status': 'pending',
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateMeetingStatus(String id, String status) async {
    await _firestore.collection('meetings').doc(id).update({'status': status});
  }
}
