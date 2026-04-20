import 'dart:convert';
import 'package:hostelops_owner/features/auth/model/owner_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthStorage {
  static Future<void> saveAuth(String token, Owner owner) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", token);
    await prefs.setString("owner", jsonEncode(owner.toJson()));
  }
static Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");

  return token != null && token.isNotEmpty;
}
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<Owner?> getOwner() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("owner");

    if (data != null) {
      return Owner.fromJson(jsonDecode(data));
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}