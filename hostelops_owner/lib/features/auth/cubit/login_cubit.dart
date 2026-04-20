import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/core/constants/auth_storage.dart';
import 'package:hostelops_owner/features/auth/data/auth_service.dart';
import 'package:hostelops_owner/features/auth/state/login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  Timer? _timer;
String? phone;
  LoginCubit() : super(LoginState());

 void sendOtp(String phone) async {
  try {
    phone = phone;

    emit(state.copyWith(isLoading: true, error: null));

    final success = await AuthService.sendOtp(phone);

    if (success) {
      emit(state.copyWith(
        isLoading: false,
        otpSent: true,
        timer: 30,
      ));
      startTimer();
    } else {
      emit(state.copyWith(
        isLoading: false,
        error: "Failed to send OTP",
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      isLoading: false,
      error: e.toString(),
    ));
  }
}
Future<void> loadUser() async {
  final user = await AuthStorage.getOwner();

  if (user != null) {
    emit(state.copyWith(
      owner: user,
      isVerified: true,
    ));
  }
}
void verifyOtp(String otp ,String phone) async {
   try {
  //   if (phone == null) {
  //     emit(state.copyWith(error: "Phone missing"));
  //     return;
  //   }

    emit(state.copyWith(isLoading: true, error: null));

    final res = await AuthService.verifyOtp(phone, otp);

    if (res != null) {
      final token = res["token"];
      final owner = res["owner"];

      // 🔥 SAVE TOKEN + PROFILE
      await AuthStorage.saveAuth(token, owner);
print(token);
print(owner);
      emit(state.copyWith(
        isLoading: false,
        isVerified: true,
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        error: "Invalid OTP",
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      isLoading: false,
      error: "Something went wrong",
    ));
  
}}
  void resendOtp(String phone) {
    sendOtp(phone);
  }

  // ⏱ TIMER
  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timer == 0) {
        timer.cancel();
      } else {
        emit(state.copyWith(timer: state.timer - 1));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}