import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';
import 'package:hostelops_owner/widgets/custom_button.dart';
import 'package:hostelops_owner/widgets/house_loader.dart';

import '../cubit/room_cubit.dart';
import '../state/room_state.dart';

class RoomsScreen extends StatelessWidget {
  final int hostelId;

  const RoomsScreen({super.key, required this.hostelId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoomCubit()
        ..addRoom()
        ..loadRoomTypes(),

      // 🔥 FIX CONTEXT ISSUE
      child: Builder(
        builder: (context) {
          return BlocListener<RoomCubit, RoomState>(
            listener: (context, state) {

              // 🔄 LOADING DIALOG
              if (state.isLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: HouseLoader(),
                  ),
                );
              }

          if (state.isSuccess) {
  Navigator.pop(context); // loader

  Navigator.pop(context, true); // 🔥 VERY IMPORTANT

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Rooms added")),
  );
}

              // ❌ ERROR
              if (state.error != null) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error!)),
                );
              }
            },

            child: Scaffold(
              backgroundColor: Colors.grey.shade100,

              appBar: AppBar(
                title: const Text("Add Rooms"),
                elevation: 0,
              ),

              // ➕ ADD ROOM
              floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: () =>
                    context.read<RoomCubit>().addRoom(),
                child: const Icon(Icons.add),
              ),

              // 📱 BODY
              body: BlocBuilder<RoomCubit, RoomState>(
                builder: (context, state) {

                  if (state.roomTypes.isEmpty) {
                    return const Center(
                        child: HouseLoader());
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.rooms.length,
                    itemBuilder: (context, index) {
                      final room = state.rooms[index];

                      return _roomCard(context, state, room, index);
                    },
                  );
                },
              ),

              // 🔥 CUSTOM BUTTON
              bottomNavigationBar: BlocBuilder<RoomCubit, RoomState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: CustomButton(
                      text: "Save Rooms",
                      
                     // isLoading: state.isLoading,
                      onTap: () {
                        context
                            .read<RoomCubit>()
                            .createRooms(hostelId);
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔥 ROOM CARD UI
  Widget _roomCard(
    BuildContext context,
    RoomState state,
    Map<String, dynamic> room,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔹 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Room ${index + 1}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () =>
                    context.read<RoomCubit>().removeRoom(index),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 ROOM NUMBER
          TextField(
            decoration: _inputDecoration("Room Number"),
            onChanged: (v) => context
                .read<RoomCubit>()
                .updateField(index, "room_number", v),
          ),

          const SizedBox(height: 12),

          // 🔹 ROOM TYPE DROPDOWN
          DropdownButtonFormField<int>(
            isExpanded: true,
            decoration: _inputDecoration("Room Type"),

            value: room["room_type_id"],

            hint: const Text("Select Room Type"),

            items: state.roomTypes.map((type) {
              return DropdownMenuItem<int>(
                value: type["id"], // ✅ int
                child: Text(type["name"]), // ✅ only name
              );
            }).toList(),

            onChanged: (val) {
              context.read<RoomCubit>().updateField(
                  index, "room_type_id", val);
            },
          ),

          const SizedBox(height: 12),

          // 🔹 BEDS ROW
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("Beds"),
                  onChanged: (v) => context
                      .read<RoomCubit>()
                      .updateField(
                        index,
                        "no_of_beds",
                        int.tryParse(v) ?? 0,
                      ),
                ),
              ),

              const SizedBox(width: 10),

              // Expanded(
              //   child: TextField(
              //     keyboardType: TextInputType.number,
              //     decoration: _inputDecoration("Occupied"),
              //     onChanged: (v) => context
              //         .read<RoomCubit>()
              //         .updateField(
              //           index,
              //           "no_of_occupied_beds",
              //           int.tryParse(v) ?? 0,
              //         ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }


  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}