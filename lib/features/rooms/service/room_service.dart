import 'dart:convert';

import 'package:hostelops_owner/core/network/api_client.dart';
import 'package:hostelops_owner/core/constants/api_urls.dart';

class RoomService {

  // 🔥 CREATE ROOM
  static Future<bool> createRoom({
    required int hostelId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final res = await ApiClient.post(
        "${ApiUrls.baseUrl}/owner/hostels/$hostelId/rooms",
        body: data,
        requireAuth: true,
      );

      return res.statusCode == 200 || res.statusCode == 201;

    } catch (e) {
      return false;
    }
  }

  // 🔥 GET ROOMS (OPTIONAL BUT IMPORTANT)
  static Future<List<dynamic>> getRooms(int hostelId) async {
    try {
      final res = await ApiClient.get(
        "${ApiUrls.baseUrl}/owner/hostels/$hostelId/rooms",
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