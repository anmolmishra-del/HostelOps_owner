class Owner {
  final int id;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String email;
  final String status;

  Owner({
    required this.id,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.status,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      phoneNumber: json['phone_number'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "phone_number": phoneNumber,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "status": status,
    };
  }
}