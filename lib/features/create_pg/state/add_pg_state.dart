class AddPgState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  final bool isCash;
  final List<String> facilities;

  AddPgState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.isCash = false,
    this.facilities = const [],
  });

  AddPgState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    bool? isCash,
    List<String>? facilities,
  }) {
    return AddPgState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      isCash: isCash ?? this.isCash,
      facilities: facilities ?? this.facilities,
    );
  }
}