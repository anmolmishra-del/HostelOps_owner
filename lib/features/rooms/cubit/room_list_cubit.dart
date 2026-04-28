// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../service/room_service.dart';

// class RoomListCubit extends Cubit<List<Map<String, dynamic>>> {
//   RoomListCubit() : super([]);

//   Future<void> fetchRooms(int hostelId) async {
//     try {
//       final data = await RoomService.getRooms(hostelId);

//       // 🔥 FIX: CAST DATA
//       final rooms = List<Map<String, dynamic>>.from(data);

//       emit(rooms);
//     } catch (e) {
//       emit([]);
//     }
//   }
// }