class Meeting {
  final String id;
  final String inviteeId;
  final String inviteeName;
  final String date;
  final String startTime;
  final String endTime;
  final String room;
  final String status;
  final String createdBy;

  Meeting({
    required this.id,
    required this.inviteeId,
    required this.inviteeName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.status,
    required this.createdBy,
  });

  // Factory method to create a Meeting from a JSON map
  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'] as String,
      inviteeId: json['inviteeId'] as String,
      inviteeName: json['inviteeName'] as String,
      date: json['date'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      room: json['room'] as String,
      status: json['status'] as String,
      createdBy: json['createdBy'] as String,
    );
  }

  // Convert a Meeting instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inviteeId': inviteeId,
      'inviteeName': inviteeName,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'status': status,
      'createdBy': createdBy,
    };
  }
}
