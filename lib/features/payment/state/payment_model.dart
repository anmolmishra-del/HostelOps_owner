import 'package:hostelops_owner/features/tenant/state/tenant_model.dart';

class PaymentModel {
  final int id;
  final int hostelId;
  final int tenantId;

  final double amount;
  final String status;
  final String description;

  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String billNumber;

  /// 🔥 NEW FIELDS
  final String? transactionId;
  final String? paymentMethod;
  final String? billPdfUrl;

  final TenantModel tenant;

  PaymentModel({
    required this.id,
    required this.hostelId,
    required this.tenantId,
    required this.amount,
    required this.status,
    required this.description,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    required this.billNumber,
    required this.tenant,

    /// 🔥 NEW
    this.transactionId,
    this.paymentMethod,
    this.billPdfUrl,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? 0,
      hostelId: json['hostel_id'] ?? 0,
      tenantId: json['tenant_id'] ?? 0,

      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      description: json['description'] ?? '',

      dueDate:
          DateTime.tryParse(json['due_date'] ?? '') ?? DateTime.now(),

      createdAt:
          DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),

      updatedAt:
          DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),

      billNumber: json['bill_number'] ?? '',

      /// 🔥 NEW PARSING
      transactionId: json['transaction_id'],
      paymentMethod: json['payment_method'],
      billPdfUrl: json['bill_pdf_url'],

      tenant: TenantModel.fromJson(json['tenant'] ?? {}),
    );
  }
}