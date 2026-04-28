import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:hostelops_owner/features/rooms/service/room_service.dart';
import '../service/tenant_service.dart';
import '../state/tenant_state.dart';

class TenantCubit extends Cubit<TenantState> {
  TenantCubit() : super(const TenantState());

  // 🔥 LOAD ROOMS
  Future<void> loadRooms(int hostelId) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final data = await RoomService.getRooms(hostelId);

      final rooms = data.map<Map<String, dynamic>>((e) {
        return Map<String, dynamic>.from(e);
      }).toList();

      // sort available first
      rooms.sort((a, b) {
        final aFull =
            (a["no_of_occupied_beds"] ?? 0) >= (a["no_of_beds"] ?? 0);
        final bFull =
            (b["no_of_occupied_beds"] ?? 0) >= (b["no_of_beds"] ?? 0);
        return aFull ? 1 : -1;
      });

      emit(state.copyWith(isLoading: false, rooms: rooms));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "Failed to load rooms",
      ));
    }
  }

  void selectRoom(int? id) {
    emit(state.copyWith(selectedRoomId: id));
  }

  void changeGender(String gender) {
    emit(state.copyWith(gender: gender));
  }


  Future<void> createTenant(Map<String, dynamic> data) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final success = await TenantService.createTenant(data);

    if (success) {
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } else {
      emit(state.copyWith(
        isLoading: false,
        error: "Failed to add tenant",
      ));
    }
  }

 
  void removeTenantLocally(int id) {
    final updated =
        state.tenants.where((t) => t["id"] != id).toList();

    emit(state.copyWith(tenants: updated));
  }

  // 🔥 🔥 RESTORE (UNDO)
  void restoreTenant(Map<String, dynamic> tenant, int index) {
    final updated = List<Map<String, dynamic>>.from(state.tenants);
    updated.insert(index, tenant);

    emit(state.copyWith(tenants: updated));
  }
Future<void> updateTenant(int id, Map<String, dynamic> data) async {
  emit(state.copyWith(isLoading: true, clearError: true));

  final success = await TenantService.updateTenant(id, data);

  if (success) {
    emit(state.copyWith(isLoading: false, isSuccess: true));
  } else {
    emit(state.copyWith(
      isLoading: false,
      error: "Failed to update tenant",
    ));
  }
}
  
Future<void> deleteTenant(int id) async {
  try {
    final success = await TenantService.deleteTenant(id);

    if (success) {
      // 🔥 REMOVE FROM CURRENT LIST
      final updatedList = List<Map<String, dynamic>>.from(state.tenants)
        ..removeWhere((t) => t["id"] == id);

      emit(state.copyWith(tenants: updatedList)); 
    } else {
      emit(state.copyWith(error: "Delete failed"));
    }
  } catch (e) {
    emit(state.copyWith(error: e.toString()));
  }
}
  // 🔥 FETCH TENANTS
  Future<void> fetchTenants(int hostelId) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final data = await TenantService.getTenants(hostelId);

      emit(state.copyWith(
        isLoading: false,
        tenants: data,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "Failed to load tenants",
      ));
    }
  }

  // 🔥 SCAN AADHAAR
  Future<void> scanAadhaar({
    required String frontPath,
    required String backPath,
  }) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      clearAadhaar: true,
    ));

    try {
      final uri = Uri.parse(
        "https://suppositionless-geralyn-jovially.ngrok-free.dev/owner/aadhaar-extract",
      );

      final request = http.MultipartRequest("POST", uri);

      request.files.add(
        await http.MultipartFile.fromPath("front", frontPath),
      );

      request.files.add(
        await http.MultipartFile.fromPath("back", backPath),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = jsonDecode(res.body);

        emit(state.copyWith(
          isLoading: false,
          aadhaarData: data,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: "Aadhaar scan failed",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "Something went wrong",
      ));
    }
  }

  // 🔥 RESET
  void resetStatus() {
    emit(state.copyWith(
      clearError: true,
      clearSuccess: true,
      clearAadhaar: true,
    ));
  }
}