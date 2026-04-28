

import 'package:hostelops_owner/features/auth/model/owner_model.dart';

class LoginState {
  final bool isLoading;
  final bool otpSent;
  final bool isVerified;
  final String? error;
  final int timer;

  final Owner? owner; // 🔥 ADD THIS

  LoginState({
    this.isLoading = false,
    this.otpSent = false,
    this.isVerified = false,
    this.error,
    this.timer = 30,
    this.owner,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? otpSent,
    bool? isVerified,
    String? error,
    int? timer,
    Owner? owner,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      otpSent: otpSent ?? this.otpSent,
      isVerified: isVerified ?? this.isVerified,
      error: error,
      timer: timer ?? this.timer,
      owner: owner ?? this.owner,
    );
  }
}