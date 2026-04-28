import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../service/dashboard_service.dart';

class DashboardCubit extends Cubit<Map<String, dynamic>> {
  DashboardCubit() : super({});

  Future<void> loadDashboard({int? hostelId}) async {
    try {
      final data =
          await DashboardService.getDashboard(hostelId: hostelId);

      emit(data);
    } catch (e) {
      emit({});
    }
  }
}


class SelectedPgState {
  final int? id;
  final String name;

  SelectedPgState({this.id, this.name = "All PGs"});
}

class SelectedPgCubit extends Cubit<SelectedPgState> {
  SelectedPgCubit() : super(SelectedPgState());

  Future<void> selectPg(int id, String name) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("pg_id", id);
    await prefs.setString("pg_name", name);

    emit(SelectedPgState(id: id, name: name));
  }

  Future<void> loadSavedPg() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getInt("pg_id");
    final name = prefs.getString("pg_name");

    if (id != null && name != null) {
      emit(SelectedPgState(id: id, name: name));
    }
  }

  Future<void> clearPg() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("pg_id");
    await prefs.remove("pg_name");

    emit(SelectedPgState(id: null, name: "All PGs"));
  }
}