class TenantState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  // 🔥 LIST DATA
  final List<Map<String, dynamic>> tenants;

  // 🔥 ROOM DATA
  final List<Map<String, dynamic>> rooms;

  // 🔥 FORM STATE
  final int? selectedRoomId;
  final String gender;

  // 🔥 NEW → AADHAAR DATA
  final Map<String, dynamic>? aadhaarData;

  const TenantState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.tenants = const [],
    this.rooms = const [],
    this.selectedRoomId,
    this.gender = "Male",
    this.aadhaarData,
  });

  TenantState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    List<Map<String, dynamic>>? tenants,
    List<Map<String, dynamic>>? rooms,
    int? selectedRoomId,
    String? gender,
    Map<String, dynamic>? aadhaarData,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearAadhaar = false,
  }) {
    return TenantState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: clearSuccess ? false : (isSuccess ?? this.isSuccess),
      error: clearError ? null : (error ?? this.error),
      tenants: tenants ?? this.tenants,
      rooms: rooms ?? this.rooms,
      selectedRoomId: selectedRoomId ?? this.selectedRoomId,
      gender: gender ?? this.gender,
      aadhaarData: clearAadhaar ? null : (aadhaarData ?? this.aadhaarData),
    );
  }
}