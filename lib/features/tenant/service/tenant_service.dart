import 'dart:convert';
import 'package:hostelops_owner/core/network/api_client.dart';
import 'package:hostelops_owner/core/constants/api_urls.dart';

class TenantService {

 static Future<bool> createTenant(Map<String, dynamic> data) async {
    try {
      final res = await ApiClient.post(
        "${ApiUrls.ownerBase}/tenants",
        body: data,
        requireAuth: true,
      );

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
 
  static Future<List<Map<String, dynamic>>> getTenants(int hostelId) async {
    try {
      final res = await ApiClient.get(
        "${ApiUrls.ownerBase}/hostels/$hostelId/tenants",
        requireAuth: true,
      );

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);

        // ✅ SAFE CAST
        return data.map<Map<String, dynamic>>((e) {
          return Map<String, dynamic>.from(e);
        }).toList();
      } else {
        throw Exception("Failed to load tenants");
      }

    } catch (e) {
      throw Exception(e.toString());
    }
  }

static Future<bool> updateRoom(int id, Map<String, dynamic> data) async {
  try {
    final res = await ApiClient.put(
      "/owner/rooms/$id",
      body: data,
      requireAuth: true,
    );

    return res.statusCode == 200;
  } catch (e) {
    return false;
  }
}

static Future<bool> updateTenant(int id, Map<String, dynamic> data) async {
  try {
    final res = await ApiClient.put(
      "${ApiUrls.ownerBase}/tenants/$id",
      body: data,
      requireAuth: true,
    );

    return res.statusCode == 200;
  } catch (e) {
    return false;
  }
}
  static Future<bool> deleteTenant(int id) async {
  try {
    final res = await ApiClient.delete(
      "${ApiUrls.ownerBase}/tenants/$id",
      requireAuth: true,
    );

    return res.statusCode == 200 || res.statusCode == 204;
  } catch (e) {
    return false;
  }
}
}