import 'dart:convert';
import 'package:hostelops_owner/core/constants/api_urls.dart';
import 'package:hostelops_owner/core/network/api_client.dart';
import 'package:hostelops_owner/features/auth/model/owner_model.dart';
class AuthResponse {
  final bool success;
  final String? token;
  final String? message;

  AuthResponse({required this.success, this.token, this.message});
}
class AuthService {

  // 📲 SEND OTP
  static Future<bool> sendOtp(String phone) async {
    final res = await ApiClient.post(
      ApiUrls.sendOtp,
      body: {"phone_number": phone},
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }static Future<Map<String, dynamic>?> verifyOtp(
      String phone, String otp) async {
    try {
      final res = await ApiClient.post(
        ApiUrls.verifyOtp,
        body: {
          "phone_number": phone,
          "otp": otp,
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        return {
          "token": data["access_token"],
          "owner": Owner.fromJson(data["owner"]),
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }}