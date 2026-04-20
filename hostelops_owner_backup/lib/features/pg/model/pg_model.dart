class PgModel {
  final int id;
  final int ownerId;

  final String name;
  final String description;

  final String address;
  final String city;
  final String state;
  final String country;
  final String zipcode;

  final List<String> photosUrls;

  final String bankName;
  final String accountNumber;
  final String ifsc;
  final String holderName;

  final String upi;
  final bool isCash;

  final String ?category;

  final List<String> facilities;

  final List<dynamic> rooms;
  final List<dynamic> tenants;

  final DateTime createdAt;
  final DateTime updatedAt;

  PgModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.zipcode,
    required this.photosUrls,
    required this.bankName,
    required this.accountNumber,
    required this.ifsc,
    required this.holderName,
    required this.upi,
    required this.isCash,
    required this.category,
    required this.facilities,
    required this.rooms,
    required this.tenants,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PgModel.fromJson(Map<String, dynamic> json) {
    return PgModel(
      id: json['id'] ?? 0,
      ownerId: json['owner_id'] ?? 0,

      name: json['name'] ?? '',
      description: json['description'] ?? '',

      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zipcode: json['zipcode'] ?? '',

      photosUrls: (json['photos_urls'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],

      bankName: json['bank_name'] ?? '',
      accountNumber: json['bank_account_number'] ?? '',
      ifsc: json['bank_ifsc_code'] ?? '',
      holderName: json['bank_account_holder_name'] ?? '',

      upi: json['upi_id'] ?? '',
      isCash: json['is_cash'] ?? false,

      category: json['category'] ?? '',

      facilities: (json['facilities'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],

      rooms: json['rooms'] ?? [],
      tenants: json['tenants'] ?? [],

      createdAt: DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ??
          DateTime.now(),
    );
  }

  // 🔥 OPTIONAL: TO JSON (for update API)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "address": address,
      "city": city,
      "state": state,
      "country": country,
      "zipcode": zipcode,
      "photos_urls": photosUrls,
      "bank_account_number": accountNumber,
      "bank_ifsc_code": ifsc,
      "bank_name": bankName,
      "category": category,
      "bank_account_holder_name": holderName,
      "upi_id": upi,
      "is_cash": isCash,
      "facilities": facilities,
    };
  }
}