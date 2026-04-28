import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/tenant_cubit.dart';
import '../state/tenant_state.dart';

class EditTenantScreen extends StatefulWidget {
  final Map<String, dynamic> tenant;

  const EditTenantScreen({super.key, required this.tenant});

  @override
  State<EditTenantScreen> createState() => _EditTenantScreenState();
}

class _EditTenantScreenState extends State<EditTenantScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController rentCtrl;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: widget.tenant["name"]);
    phoneCtrl = TextEditingController(text: widget.tenant["phone_number"]);
    rentCtrl = TextEditingController(
      text: widget.tenant["rent"]?.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Tenant")),

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

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Form(
            key: formKey,
            child: Column(
              children: [

                TextFormField(
                  controller: nameCtrl,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                  decoration: const InputDecoration(labelText: "Name"),
                ),

                TextFormField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: "Phone"),
                ),

                TextFormField(
                  controller: rentCtrl,
                  decoration: const InputDecoration(labelText: "Rent"),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _update,
                    child: const Text("Update"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _update() {
    if (!formKey.currentState!.validate()) return;

    context.read<TenantCubit>().updateTenant(
      widget.tenant["id"],
      {
        "name": nameCtrl.text,
        "phone_number": phoneCtrl.text,
        "rent": int.tryParse(rentCtrl.text) ?? 0,
      },
    );
  }
}