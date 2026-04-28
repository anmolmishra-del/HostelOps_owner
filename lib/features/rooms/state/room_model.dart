class RoomModel {
  final String roomNumber;
  final int totalBeds;
  final int occupiedBeds;

  RoomModel({
    required this.roomNumber,
    required this.totalBeds,
    required this.occupiedBeds,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomNumber: json['room_number'] ?? '',
      totalBeds: json['no_of_beds'] ?? 0,
      occupiedBeds: json['no_of_occupied_beds'] ?? 0,
    );
  }
}