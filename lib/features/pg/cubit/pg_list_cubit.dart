import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/features/create_pg/pg_service/pg_service.dart';
import 'package:hostelops_owner/features/pg/state/pg_list_state.dart';

class PgListCubit extends Cubit<PgListState> {
  PgListCubit() : super(PgListState());

  Future<void> fetchPgs() async {
    emit(state.copyWith(isLoading: true));

    try {
      final data = await PgService.getPgs(); // API

      emit(state.copyWith(
        isLoading: false,
        pgs: data,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "Failed to load PGs",
      ));
    }
  }
}