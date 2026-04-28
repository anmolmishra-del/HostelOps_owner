import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:hostelops_owner/features/tenant/presentation/TenantDetailScreen.dart';
import 'package:hostelops_owner/widgets/house_loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hostelops_owner/core/routes/app_routes.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';

import '../cubit/tenant_cubit.dart';
import '../state/tenant_state.dart';

class TenantListScreen extends StatelessWidget {
  final int hostelId;

  const TenantListScreen({super.key, required this.hostelId});

  /// 🔹 KYC Dialog
  void _showKycDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text("Add Tenant"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text("DigiLocker"),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Scan Aadhaar"),
              onTap: () {
                Navigator.pop(context);
                _captureAadhaar(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Capture Aadhaar
  Future<void> _captureAadhaar(BuildContext context) async {
    final picker = ImagePicker();

    final front = await picker.pickImage(source: ImageSource.camera);
    if (front == null) return;

    final back = await picker.pickImage(source: ImageSource.camera);
    if (back == null) return;

    context.read<TenantCubit>().scanAadhaar(
          frontPath: front.path,
          backPath: back.path,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TenantCubit()..fetchTenants(hostelId),

      child: BlocListener<TenantCubit, TenantState>(
        listener: (context, state) {
          if (state.aadhaarData != null) {
            Navigator.pushNamed(
              context,
              AppRoutes.add_tenant,
              arguments: {
                "hostelId": hostelId,
                "prefill": state.aadhaarData
              },
            );

            context.read<TenantCubit>().resetStatus();
          }

          if (state.error != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },

        child: Scaffold(
          backgroundColor: AppColors.background,
        appBar: AppBar(
  title: const Text("Tenants"),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pop(context, true); // 🔥 IMPORTANT
    },
  ),
),

          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add),
            onPressed: () => _showKycDialog(context),
          ),

          /// 🔥 TENANT LIST
          body: BlocBuilder<TenantCubit, TenantState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: HouseLoader());
              }

              if (state.tenants.isEmpty) {
                return const Center(child: Text("No Tenants Found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.tenants.length,
                itemBuilder: (context, index) {
                  final t = state.tenants[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),

                    /// 🔥 SLIDABLE (HOLD SWIPE)
                    child: Slidable(
                      key: Key(t["id"].toString()),

                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),

                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              context
                                  .read<TenantCubit>()
                                  .deleteTenant(t["id"]);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),

                      /// 🔵 CARD
                      child: _tenantCard(context, t),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /// 🔥 Tenant Card UI (UNCHANGED)
  Widget _tenantCard(
      BuildContext context, Map<String, dynamic> t) {
    final room = t["room"] ?? {};

    return GestureDetector(
     onTap: () => Navigator.pushNamed(
  context,
  AppRoutes.tenant_detail,
  arguments: {
    "tenant": t,
    "cubit": context.read<TenantCubit>(), // 🔥 FIX
  },
),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                (t["name"] ?? "N")[0],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    t["name"] ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t["phone_number"] ?? "",
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      _chip(
                          "Room ${room["room_number"] ?? "-"}"),
                      const SizedBox(width: 6),
                      _chip(
                          room["room_type_name"] ??
                              "General"),
                    ],
                  ),
                ],
              ),
            ),

            Icon(
              (room["no_of_occupied_beds"] ?? 0) ==
                      (room["no_of_beds"] ?? 0)
                  ? Icons.warning
                  : Icons.check_circle,
              color: (room["no_of_occupied_beds"] ?? 0) ==
                      (room["no_of_beds"] ?? 0)
                  ? Colors.red
                  : Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 11)),
    );
  }
}