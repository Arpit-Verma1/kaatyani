import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingRequestModel {
  final String id;
  final String inviterId;
  final String inviteeId;
  final DateTime dateTime;
  final int duration;
  final String roomId;
  final String status; // e.g., "pending", "accepted", "declined"

  MeetingRequestModel({
    required this.id,
    required this.inviterId,
    required this.inviteeId,
    required this.dateTime,
    required this.duration,
    required this.roomId,
    required this.status,
  });

  MeetingRequestModel copyWith({
    String? id,
    String? inviterId,
    String? inviteeId,
    DateTime? dateTime,
    int? duration,
    String? roomId,
    String? status,
  }) {
    return MeetingRequestModel(
      id: id ?? this.id,
      inviterId: inviterId ?? this.inviterId,
      inviteeId: inviteeId ?? this.inviteeId,
      dateTime: dateTime ?? this.dateTime,
      duration: duration ?? this.duration,
      roomId: roomId ?? this.roomId,
      status: status ?? this.status,
    );
  }

  factory MeetingRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MeetingRequestModel(
      id: doc.id,
      inviterId: data['inviterId'],
      inviteeId: data['inviteeId'],
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      duration: data['duration'],
      roomId: data['roomId'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inviterId': inviterId,
      'inviteeId': inviteeId,
      'dateTime': dateTime,
      'duration': duration,
      'roomId': roomId,
      'status': status,
    };
  }
}
