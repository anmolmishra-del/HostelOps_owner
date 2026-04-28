import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 🔥 ADDED
import 'package:hostelops_owner/core/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/tenant_cubit.dart'; // 🔥 ADDED
import 'edit_tenant_screen.dart'; // 🔥 ADDED

class TenantDetailScreen extends StatelessWidget {
  final Map<String, dynamic> tenant;

  const TenantDetailScreen({super.key, required this.tenant});

  @override
  Widget build(BuildContext context) {
    final room = tenant["room"] ?? {};

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔥 HEADER WITH EDIT BUTTON
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 30),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade500, Colors.blue.shade300],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),

              child: Column(
                children: [
                  // 🔥 UPDATED HEADER ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // LEFT SIDE
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          const Text(
                            "Tenant Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      // 🔥 EDIT BUTTON
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () async {
                           final result = await Navigator.pushNamed(
  context,
  AppRoutes.edit_tenant, // ✅ CORRECT ROUTE
  arguments: {
    "tenant": tenant,
    "cubit": context.read<TenantCubit>(), // 🔥 VERY IMPORTANT
  },
);

                            if (result == true) {
                              Navigator.pop(context, true);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔥 AVATAR
                  _buildAvatar(),

                  const SizedBox(height: 12),

                  Text(
                    tenant["name"] ?? "",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    tenant["phone_number"] ?? "",
                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 14),

                  // 🔥 CALL BUTTON
                  GestureDetector(
                    onTap: () => _call(tenant["phone_number"]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.call, color: Colors.blue),
                          SizedBox(width: 6),
                          Text(
                            "Call",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔥 CONTENT (UNCHANGED)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _cardSection("Room Details", [
                    _infoTile("Room No", room["room_number"]),
                    _infoTile("Type", room["room_type_name"] ?? "General"),
                    _infoTile(
                      "Beds",
                      "${room["no_of_occupied_beds"]}/${room["no_of_beds"]}",
                    ),
                  ]),

                  _cardSection("Payment", [
                    _infoTile("Rent", "₹${tenant["rent"]}"),
                    _infoTile("Deposit", "₹${tenant["security_deposit"]}"),
                  ]),

                  _cardSection("Personal Info", [
                    _infoTile("Email", tenant["email"]),
                    _infoTile("Gender", tenant["gender"]),
                    _infoTile("Aadhaar", tenant["aadhaar_number"]),
                  ]),

                  _cardSection("Address", [
                    _infoTile("Address", tenant["address"]),
                    _infoTile("City", tenant["city"]),
                    _infoTile("State", tenant["state"]),
                  ]),

                  _cardSection("Emergency Contact", [
                    _infoTile("Name", tenant["emergency_contact_name"]),
                    _infoTile("Phone", tenant["emergency_contact_phone"]),
                    _infoTile(
                      "Relation",
                      tenant["emergency_contact_relationship"],
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 SAME CODE BELOW (UNCHANGED)

  Widget _buildAvatar() {
    final name = tenant["name"] ?? "";
    final photo = tenant["photo_url"];

    return CircleAvatar(
      radius: 42,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: photo != null && photo.isNotEmpty
            ? Image.network(
                photo,
                width: 84,
                height: 84,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(name),
              )
            : _fallback(name),
      ),
    );
  }

  Widget _fallback(String name) {
    return Container(
      width: 84,
      height: 84,
      color: Colors.blue.shade100,
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : "?",
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Future<void> _call(String? phone) async {
    if (phone == null) return;
    final Uri url = Uri(scheme: 'tel', path: phone);
    await launchUrl(url);
  }

  Widget _cardSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _infoTile(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const Spacer(),
          Text(
            value?.toString() ?? "-",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
