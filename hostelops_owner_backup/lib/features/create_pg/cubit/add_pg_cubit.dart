import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/features/create_pg/pg_service/pg_service.dart';
import 'package:hostelops_owner/features/create_pg/state/add_pg_state.dart';


class AddPgCubit extends Cubit<AddPgState> {
  AddPgCubit() : super(AddPgState());

  Future<void> createPg(Map<String, dynamic> data) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final success = await PgService.createPg(data);

      if (success) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: "Failed to create PG",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "Something went wrong",
      ));
    }

  }
  void toggleCash(bool value) {
  emit(state.copyWith(isCash: value));
}

void toggleFacility(String f) {
  final updated = List<String>.from(state.facilities);

  if (updated.contains(f)) {
    updated.remove(f);
  } else {
    updated.add(f);
  }

  emit(state.copyWith(facilities: updated));
}
}
