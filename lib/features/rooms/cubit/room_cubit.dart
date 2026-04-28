import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/room_service.dart';
import '../state/room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  RoomCubit() : super(RoomState());



  void addRoom() {
    final updated = List<Map<String, dynamic>>.from(state.rooms);

    updated.add({
      "room_number": "",
      "room_type_id": null,
      "no_of_beds": 0,
      "no_of_occupied_beds": 0,
    });

    emit(state.copyWith(rooms: updated));
  }

  void removeRoom(int index) {
    final updated = List<Map<String, dynamic>>.from(state.rooms);
    updated.removeAt(index);

    emit(state.copyWith(rooms: updated));
  }

  void updateField(int index, String key, dynamic value) {
    final updated = List<Map<String, dynamic>>.from(state.rooms);
    updated[index][key] = value;

    emit(state.copyWith(rooms: updated));
  }


  Future<void> fetchRooms(int hostelId) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final data = await RoomService.getRooms(hostelId);

      final rooms = List<Map<String, dynamic>>.from(data);

      emit(state.copyWith(
        isLoading: false,
        roomList: rooms,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "Failed to load rooms",
      ));
    }
  }


  void removeRoomLocally(int id) {
    final updated =
        state.roomList.where((r) => r["id"] != id).toList();

    emit(state.copyWith(roomList: updated));
  }

  void restoreRoom(Map<String, dynamic> room, int index) {
    final updated = List<Map<String, dynamic>>.from(state.roomList);
    updated.insert(index, room);

    emit(state.copyWith(roomList: updated));
  }

 Future<void> deleteRoom(int id) async {
  try {
    final success = await RoomService.deleteRoom(id);

    if (success) {
     
      final updatedList =
          state.roomList.where((room) => room["id"] != id).toList();

      emit(state.copyWith(roomList: updatedList)); 
    } else {
      emit(state.copyWith(error: "Failed to delete room"));
    }
  } catch (e) {
    emit(state.copyWith(error: e.toString()));
  }
}
 
  Future<void> loadRoomTypes() async {
    try {
      final types = await RoomService.getRoomTypes();

      emit(state.copyWith(roomTypes: types));
    } catch (e) {
      emit(state.copyWith(error: "Failed to load room types"));
    }
  }


Future<void> createRooms(int hostelId) async {
  emit(state.copyWith(isLoading: true, clearError: true));

  try {
    for (var room in state.rooms) {
      final res = await RoomService.createRoom(
        hostelId: hostelId,
        data: {
          ...room,
          "hostel_id": hostelId,
        },
      );

      if (!res.success) {
        emit(state.copyWith(
          isLoading: false,
          error: res.message ?? "Room creation failed",
        ));
        return; // 🔥 stop on first failure
      }
    }

    emit(state.copyWith(
      isLoading: false,
      isSuccess: true,
    ));

  } catch (e) {
    emit(state.copyWith(
      isLoading: false,
      error: e.toString(),
    ));
  }
}
  void resetStatus() {
    emit(state.copyWith(
      clearError: true,
      clearSuccess: true,
    ));
  }
}