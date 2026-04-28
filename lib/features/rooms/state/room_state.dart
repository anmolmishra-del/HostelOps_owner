class RoomState {
  final List<Map<String, dynamic>> rooms; // form rooms
  final List<Map<String, dynamic>> roomList; // fetched rooms
  final List<dynamic> roomTypes;

  final bool isLoading;
  final bool isSuccess;
  final String? error;

  RoomState({
    this.rooms = const [],
    this.roomList = const [],
    this.roomTypes = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  RoomState copyWith({
    List<Map<String, dynamic>>? rooms,
    List<Map<String, dynamic>>? roomList,
    List<dynamic>? roomTypes,
    bool? isLoading,
    bool? isSuccess,
    String? error,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return RoomState(
      rooms: rooms ?? this.rooms,
      roomList: roomList ?? this.roomList,
      roomTypes: roomTypes ?? this.roomTypes,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: clearSuccess ? false : (isSuccess ?? this.isSuccess),
      error: clearError ? null : (error ?? this.error),
    );
  }
}