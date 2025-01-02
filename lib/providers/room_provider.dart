import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/conference_room_model.dart';

final roomProvider = Provider<List<ConferenceRoomModel>>((ref) => []);
