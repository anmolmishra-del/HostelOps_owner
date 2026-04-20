import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<int?> {
  DashboardCubit() : super(null);

  void selectPg(int id) {
    emit(id);
  }
}
class SelectedPgState {
  final int? id;
  final String name;

  SelectedPgState({this.id, this.name = "Select PG"});
}

class SelectedPgCubit extends Cubit<SelectedPgState> {
  SelectedPgCubit() : super(SelectedPgState());

  void selectPg(int id, String name) {
    emit(SelectedPgState(id: id, name: name));
  }

}