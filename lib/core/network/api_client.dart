import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hostelops_owner/core/constants/auth_storage.dart';

class ApiClient {

  static Future<Map<String, String>> _headers(bool requireAuth) async {
    String? token;

    if (requireAuth) {
      token = await AuthStorage.getToken();
    }

    return {
      "Content-Type": "application/json",
      if (requireAuth && token != null)
        "Authorization": "Bearer $token",
    };
  }

  
  static Future<http.Response> get(
    String url, {
    bool requireAuth = false,
  }) async {
    return await http.get(
      Uri.parse(url),
      headers: await _headers(requireAuth),
    );
  }

  
  static Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    return await http.post(
      Uri.parse(url),
      headers: await _headers(requireAuth),
      body: jsonEncode(body),
    );
  }


  static Future<http.Response> put(
    String url, {
      Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    return await http.put(
      Uri.parse(url),
      headers: await _headers(requireAuth),
      body: jsonEncode(body),
    );
  }


  static Future<http.Response> patch(
    String url, {
      Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    return await http.patch(
      Uri.parse(url),
      headers: await _headers(requireAuth),
      body: jsonEncode(body),
    );
  }


  static Future<http.Response> delete(
    String url, {
    bool requireAuth = false,
  }) async {
    return await http.delete(
      Uri.parse(url),
      headers: await _headers(requireAuth),
    );
  }
}