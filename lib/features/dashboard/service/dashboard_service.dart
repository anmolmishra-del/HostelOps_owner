import 'dart:convert';
import 'package:hostelops_owner/core/network/api_client.dart';
import 'package:hostelops_owner/core/constants/api_urls.dart';

class DashboardService {
  static Future<Map<String, dynamic>> getDashboard({int? hostelId}) async {
    final url = hostelId == null
        ? "${ApiUrls.ownerBase}/dashboard"
        : "${ApiUrls.ownerBase}/dashboard?hostel_id=$hostelId";

    final res = await ApiClient.get(url, requireAuth: true);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load dashboard");
    }
  }
}