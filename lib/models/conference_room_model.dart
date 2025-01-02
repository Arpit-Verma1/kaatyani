class ConferenceRoomModel {
  final String id;
  final String name;

  ConferenceRoomModel({required this.id, required this.name});

  factory ConferenceRoomModel.fromJson(Map<String, dynamic> json) => ConferenceRoomModel(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
