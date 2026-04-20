import 'package:hostelops_owner/features/pg/model/pg_model.dart';

class PgListState {
  final bool isLoading;
  final List<PgModel> pgs;
  final String? error;

  PgListState({
    this.isLoading = false,
    this.pgs = const [],
    this.error,
  });

  PgListState copyWith({
    bool? isLoading,
    List<PgModel>? pgs,
    String? error,
  }) {
    return PgListState(
      isLoading: isLoading ?? this.isLoading,
      pgs: pgs ?? this.pgs,
      error: error,
    );
  }
}