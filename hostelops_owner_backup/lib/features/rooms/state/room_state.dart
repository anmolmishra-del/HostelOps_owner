class RoomState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  RoomState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  RoomState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return RoomState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}