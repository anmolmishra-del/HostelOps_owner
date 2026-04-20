import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/features/rooms/state/room_state.dart';
import '../cubit/room_cubit.dart';


class RoomsScreen extends StatefulWidget {
  final int hostelId;

  const RoomsScreen({super.key, required this.hostelId});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  List<Map<String, dynamic>> rooms = [];

  @override
  void initState() {
    super.initState();
    _addRoom();
  }

  void _addRoom() {
    setState(() {
      rooms.add({
        "room_number": "",
        "room_type": "",
        "no_of_beds": 0,
        "no_of_occupied_beds": 0,
      });
    });
  }

  void _removeRoom(int index) {
    setState(() => rooms.removeAt(index));
  }

  void _submit() {
    context.read<RoomCubit>().createRooms(
      hostelId: widget.hostelId,
      rooms: rooms,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoomCubit(),

      child: BlocListener<RoomCubit, RoomState>(
        listener: (context, state) {

          if (state.isLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state.isSuccess) {
            Navigator.pop(context); // loader
            Navigator.pop(context); // screen

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Rooms added")),
            );
          }

          if (state.error != null) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },

        child: Scaffold(
          appBar: AppBar(title: const Text("Add Rooms")),

          floatingActionButton: FloatingActionButton(
            onPressed: _addRoom,
            child: const Icon(Icons.add),
          ),

          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [

                      TextField(
                        decoration:
                            const InputDecoration(labelText: "Room Number"),
                        onChanged: (v) => room["room_number"] = v,
                      ),

                      TextField(
                        decoration:
                            const InputDecoration(labelText: "Room Type"),
                        onChanged: (v) => room["room_type"] = v,
                      ),

                      TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: "Beds"),
                        onChanged: (v) =>
                            room["no_of_beds"] = int.tryParse(v) ?? 0,
                      ),

                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: "Occupied Beds"),
                        onChanged: (v) =>
                            room["no_of_occupied_beds"] =
                                int.tryParse(v) ?? 0,
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeRoom(index),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _submit,
              child: const Text("Save Rooms"),
            ),
          ),
        ),
      ),
    );
  }
}