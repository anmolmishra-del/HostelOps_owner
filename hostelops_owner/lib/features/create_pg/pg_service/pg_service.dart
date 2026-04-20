
import 'dart:convert';

import 'package:hostelops_owner/core/network/api_client.dart';
import 'package:hostelops_owner/core/constants/api_urls.dart';
import 'package:hostelops_owner/features/pg/model/pg_model.dart';

class PgService {
   static Future<List<PgModel>> getPgs() async {
    try {
      final res = await ApiClient.get( 
        ApiUrls.createPg,
        requireAuth: true, 
      );

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);

        return data.map((e) => PgModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load PGs");
      }

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<bool> createPg(Map<String, dynamic> data) async {
    try {
      final res = await ApiClient.post(
        ApiUrls.createPg, 
        body: data,
        requireAuth: true,
      );

      return res.statusCode == 200 || res.statusCode == 201;

    } catch (e) {
      return false;
    }
  }
}