import 'dart:convert';
import 'package:hostelops_owner/core/network/api_client.dart';
import 'package:hostelops_owner/core/constants/api_urls.dart';
import 'package:hostelops_owner/features/payment/state/payment_model.dart';

class PaymentService {
static Future<Map<String, dynamic>> verifyOtp({
  required int billId,
  required String otp,
}) async {
  final res = await ApiClient.post(
    ApiUrls.otpverify(billId),
    body: {"otp": otp},
    requireAuth: true,
  );

  final data = jsonDecode(res.body);

  return {
    "success": res.statusCode == 200,
    "message": data["message"] ?? "Something went wrong",
  };
}
static Future<List<PaymentModel>> getPayments(int hostelId) async {
  final res = await ApiClient.get(
    ApiUrls.payments(hostelId),
    requireAuth: true,
  );

  if (res.statusCode == 200) {
    final List data = jsonDecode(res.body);

    return data.map((e) => PaymentModel.fromJson(e)).toList();
  } else {
    throw Exception("Failed");
  }
}
  static Future<bool> markAsPaid(int paymentId) async {
    try {
      final res = await ApiClient.post(
        "${ApiUrls.ownerBase}/payments/$paymentId/pay", // adjust API
        requireAuth: true,
      );

      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}