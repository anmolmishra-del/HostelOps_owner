import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/tenant_cubit.dart';
import '../state/tenant_state.dart';

class AddTenantScreen extends StatelessWidget {
  final int hostelId;

  AddTenantScreen({super.key, required this.hostelId});

  final formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final altPhoneCtrl = TextEditingController();

  final aadhaarCtrl = TextEditingController();
  final rentCtrl = TextEditingController();
  final depositCtrl = TextEditingController();

  final emergencyNameCtrl = TextEditingController();
  final emergencyPhoneCtrl = TextEditingController();
  final emergencyRelationCtrl = TextEditingController();

  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final zipCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TenantCubit>();

    // 🔥 load once safely
    Future.microtask(() => cubit.loadRooms(hostelId));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text("Add Tenant"),
        elevation: 0,
      ),

      body: BlocListener<TenantCubit, TenantState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pop(context, true);
          }

          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },

        child: BlocBuilder<TenantCubit, TenantState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Form(
                key: formKey,
                child: Column(
                  children: [

                    _section("Basic Info", [
                      _input("Name", nameCtrl),
                      _input("Email", emailCtrl),
                      _input("Phone", phoneCtrl),
                      _input("Alternate Phone", altPhoneCtrl),
                    ]),

                    _section("Room", [
                      DropdownButtonFormField<int>(
                        value: state.selectedRoomId,
                        decoration: _dec("Select Room"),

                        items: state.rooms.map((room) {
                          final total = room["no_of_beds"] ?? 0;
                          final occupied =
                              room["no_of_occupied_beds"] ?? 0;

                          final isFull = occupied >= total;

                          return DropdownMenuItem<int>(
                            value: room["id"],
                            enabled: !isFull,
                            child: Text(
                              "Room ${room["room_number"]} (${isFull ? "Full" : "$occupied/$total"})",
                            ),
                          );
                        }).toList(),

                        onChanged: cubit.selectRoom,
                        validator: (v) =>
                            v == null ? "Select room" : null,
                      ),
                    ]),

                    _section("Rent Info", [
                      _input("Rent", rentCtrl),
                      _input("Deposit", depositCtrl),
                    ]),

                    _section("Identity", [
                      _input("Aadhaar", aadhaarCtrl),
                    ]),

                    _section("Emergency Contact", [
                      _input("Name", emergencyNameCtrl),
                      _input("Phone", emergencyPhoneCtrl),
                      _input("Relation", emergencyRelationCtrl),
                    ]),

                    _section("Address", [
                      _input("Address", addressCtrl),
                      _input("City", cityCtrl),
                      _input("State", stateCtrl),
                      _input("Country", countryCtrl),
                      _input("Zip Code", zipCtrl),
                    ]),

                    const SizedBox(height: 20),

                    // 🔥 BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _submit(context, state),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Save Tenant",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 🔥 SUBMIT
  void _submit(BuildContext context, TenantState state) {
    if (!formKey.currentState!.validate()) return;

    final room = state.rooms.firstWhere(
      (r) => r["id"] == state.selectedRoomId,
    );

    final isFull =
        (room["no_of_occupied_beds"] ?? 0) >= (room["no_of_beds"] ?? 0);

    if (isFull) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Room is full")),
      );
      return;
    }

    final data = {
      "name": nameCtrl.text,
      "email": emailCtrl.text,
      "phone_number": phoneCtrl.text,
      "alternate_phone_number": altPhoneCtrl.text,

      "emergency_contact_name": emergencyNameCtrl.text,
      "emergency_contact_phone": emergencyPhoneCtrl.text,
      "emergency_contact_relationship": emergencyRelationCtrl.text,

      "gender": state.gender,
      "photo_url": "",
      "aadhaar_number": aadhaarCtrl.text,
      "identity_verified": false,

      "rent": int.tryParse(rentCtrl.text) ?? 0,
      "security_deposit": int.tryParse(depositCtrl.text) ?? 0,

      "join_date": DateTime.now().toIso8601String(),

      "address": addressCtrl.text,
      "city": cityCtrl.text,
      "state": stateCtrl.text,
      "country": countryCtrl.text,
      "zipcode": zipCtrl.text,

      "room_id": state.selectedRoomId,
      "hostel_id": hostelId,
    };

    context.read<TenantCubit>().createTenant(data);
  }

  // 🔥 UI

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: _dec(label),
      ),
    );
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      );
}