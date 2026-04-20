import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';
import 'package:hostelops_owner/features/create_pg/state/add_pg_state.dart';
import '../cubit/add_pg_cubit.dart';


class AddPgScreen extends StatelessWidget {
  const AddPgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddPgCubit>();

    final name = TextEditingController();
    final description = TextEditingController();
    final address = TextEditingController();
    final city = TextEditingController();
    final stateCtrl = TextEditingController();
    final country = TextEditingController();
    final zipcode = TextEditingController();

    final bankName = TextEditingController();
    final accountNumber = TextEditingController();
    final ifsc = TextEditingController();
    final holderName = TextEditingController();
    final upi = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    final allFacilities = ["WiFi", "AC", "Food", "Parking"];

    Widget input(String label, TextEditingController c) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: c,
          validator: (v) => v!.isEmpty ? "$label required" : null,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Add PG")),

      body: BlocListener<AddPgCubit, AddPgState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("PG Created Successfully")),
            );
            Navigator.pop(context);
          }

          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Form(
            key: _formKey,
            child: Column(
              children: [

                input("PG Name", name),
                input("Description", description),

                input("Address", address),
                input("City", city),
                input("State", stateCtrl),
                input("Country", country),
                input("Zipcode", zipcode),

                input("Bank Name", bankName),
                input("Account Number", accountNumber),
                input("IFSC Code", ifsc),
                input("Account Holder", holderName),

                input("UPI ID", upi),

                // 🔥 CASH TOGGLE (Cubit controlled)
                BlocBuilder<AddPgCubit, AddPgState>(
                  builder: (context, state) {
                    return SwitchListTile(
                      value: state.isCash,
                      onChanged: cubit.toggleCash,
                      title: const Text("Accept Cash"),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // 🔥 FACILITIES (Cubit controlled)
                BlocBuilder<AddPgCubit, AddPgState>(
                  builder: (context, state) {
                    return Wrap(
                      spacing: 8,
                      children: allFacilities.map((f) {
                        final selected = state.facilities.contains(f);

                        return FilterChip(
                          label: Text(f),
                          selected: selected,
                          onSelected: (_) => cubit.toggleFacility(f),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // 🔥 BUTTON
                BlocBuilder<AddPgCubit, AddPgState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        onPressed: state.isLoading
                            ? null
                            : () {
                                if (!_formKey.currentState!.validate()) return;

                                final data = {
                                  "name": name.text,
                                  "description": description.text,
                                  "address": address.text,
                                  "city": city.text,
                                  "state": stateCtrl.text,
                                  "country": country.text,
                                  "zipcode": zipcode.text,
                                  "photos_urls": [],
                                  "bank_account_number": accountNumber.text,
                                  "bank_ifsc_code": ifsc.text,
                                  "bank_name": bankName.text,
                                  "category": "PG",
                                  "bank_account_holder_name": holderName.text,
                                  "upi_id": upi.text,
                                  "is_cash": state.isCash,
                                  "facilities": state.facilities,
                                };

                                cubit.createPg(data);
                              },
                        child: state.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Create PG"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}