import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hostelops_owner/features/rooms/cubit/room_cubit.dart';
import 'package:hostelops_owner/widgets/house_loader.dart';
import '../presentation/rooms_screen.dart';
import '../state/room_state.dart';

class RoomsListScreen extends StatelessWidget {
  final int hostelId;

  const RoomsListScreen({super.key, required this.hostelId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoomCubit()..fetchRooms(hostelId),

      child: Builder(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, true); // 🔥 RETURN TRUE
              return false;
            },

            child: Scaffold(
              appBar: AppBar(
                title: const Text("Rooms"),

                /// 🔥 ALSO HANDLE APPBAR BACK
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context, true); // 🔥 RETURN TRUE
                  },
                ),
              ),

              /// ➕ ADD ROOM
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoomsScreen(hostelId: hostelId),
                    ),
                  );

                  if (!context.mounted) return;

                  if (result == true) {
                    context.read<RoomCubit>().fetchRooms(hostelId);
                  }
                },
                child: const Icon(Icons.add),
              ),

              /// 📋 ROOM LIST
              body: BlocBuilder<RoomCubit, RoomState>(
                builder: (context, state) {
                  final rooms = state.roomList;

                  if (state.isLoading) {
                    return const Center(child: HouseLoader());
                  }

                  if (rooms.isEmpty) {
                    return const Center(child: Text("No Rooms Found"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final room = rooms[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),

                        child: Slidable(
                          key: Key(room["id"].toString()),

                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),

                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  context
                                      .read<RoomCubit>()
                                      .deleteRoom(room["id"]);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),

                          child: _roomCard(room),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _roomCard(Map<String, dynamic> room) {
    final beds = room["no_of_beds"] ?? 0;
    final occupied = room["no_of_occupied_beds"] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Room ${room["room_number"]}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                room["room_type_name"] ?? "General",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                "$occupied / $beds Occupied",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          Icon(
            occupied == beds
                ? Icons.warning
                : Icons.check_circle,
            color: occupied == beds ? Colors.red : Colors.green,
          ),
        ],
      ),
    );
  }
}