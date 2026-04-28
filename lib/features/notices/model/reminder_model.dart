class Reminder {
  final String tenantName;
  final String roomNumber;
  final String type; // rent / maintenance / water
  final String message;
  final String date;

  Reminder({
    required this.tenantName,
    required this.roomNumber,
    required this.type,
    required this.message,
    required this.date,
  });
}