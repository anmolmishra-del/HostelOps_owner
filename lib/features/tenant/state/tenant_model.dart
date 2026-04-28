import 'package:hostelops_owner/features/rooms/state/room_model.dart';

class TenantModel {
  final int id;
  final String name;
  final String phone;
  final String email;

  final int rent;
  final int deposit;

  final RoomModel room;

  TenantModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.rent,
    required this.deposit,
    required this.room,
  });

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      rent: json['rent'] ?? 0,
      deposit: json['security_deposit'] ?? 0,
      room: RoomModel.fromJson(json['room'] ?? {}),
    );
  }
}