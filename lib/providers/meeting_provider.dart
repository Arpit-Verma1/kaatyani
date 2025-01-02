import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meeting_request_model.dart';

final meetingRequestsProvider = StateNotifierProvider<MeetingRequestsNotifier, List<MeetingRequestModel>>(
      (ref) => MeetingRequestsNotifier(),
);

class MeetingRequestsNotifier extends StateNotifier<List<MeetingRequestModel>> {
  MeetingRequestsNotifier() : super([]);

  void addRequest(MeetingRequestModel request) {
    state = [...state, request];
  }

  void updateRequestStatus(String id, String status) {
    state = state.map((req) {
      if (req.id == id) return req.copyWith(status: status);
      return req;
    }).toList();
  }
}
