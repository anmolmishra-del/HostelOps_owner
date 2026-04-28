import 'dart:convert';

import 'package:hostelops_owner/core/network/api_client.dart';
import 'package:hostelops_owner/core/constants/api_urls.dart';
import 'package:hostelops_owner/core/network/api_response.dart';

class RoomService {

static Future<ApiResponse<void>> createRoom({
  required int hostelId,
  required Map<String, dynamic> data,
}) async {
  try {
    final res = await ApiClient.post(
      ApiUrls.rooms(hostelId),
      body: data,
      requireAuth: true,
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return ApiResponse.success();
    } else {
      final body = jsonDecode(res.body);

      return ApiResponse.failure(
        body["message"] ?? "Failed to create room",
      );
    }
  } catch (e) {
    return ApiResponse.failure(e.toString());
  }
}  static Future<bool> deleteRoom(int id) async {
  try {
    final res = await ApiClient.delete(
       ApiUrls.drooms(id), // 👈 adjust URL if needed
      requireAuth: true,
    );

    return res.statusCode == 200 || res.statusCode == 204;
  } catch (e) {
    return false;
  }
}
  static Future<List<Map<String, dynamic>>> getRoomTypes() async {
  try {
    final res = await ApiClient.get(
      ApiUrls.roomTypes,
      requireAuth: true,
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);

      // 🔥 CLEAN PARSE
      return data.map((e) {
        return {
          "id": int.tryParse(e["id"].toString()) ?? 0,
          "name": e["name"] ?? "",
        };
      }).toList();
    } else {
      throw Exception("Failed to load room types");
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}
static Future<List<dynamic>> getRooms(int hostelId) async {
    try {
      final res = await ApiClient.get(
        ApiUrls.rooms(hostelId), // ✅ CLEAN
        requireAuth: true,
      );

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data;
      } else {
        throw Exception("Failed to load rooms");
      }

    } catch (e) {
      throw Exception(e.toString());
    }
  }
}