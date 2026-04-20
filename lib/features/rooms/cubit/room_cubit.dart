import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/features/rooms/service/room_service.dart';
import 'package:hostelops_owner/features/rooms/state/room_state.dart';


class RoomCubit extends Cubit<RoomState> {
  RoomCubit() : super(RoomState());

  Future<void> createRooms({
    required int hostelId,
    required List<Map<String, dynamic>> rooms,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      for (var room in rooms) {
        await RoomService.createRoom(
          hostelId: hostelId,
          data: {
            ...room,
            "hostel_id": hostelId,
          },
        );
      }

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "Failed to add rooms",
      ));
    }
  }
}