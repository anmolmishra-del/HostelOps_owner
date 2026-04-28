import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/features/payment/service/payment_service.dart';
import 'package:hostelops_owner/features/payment/state/payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(const PaymentState());

  Future<void> fetchPayments(int hostelId) async {
    emit(state.copyWith(isLoading: true));

    try {
      final data = await PaymentService.getPayments(hostelId);

      emit(state.copyWith(
        isLoading: false,
        payments: data,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "Failed to load payments",
      ));
    }
  }

  void toggleExpand(int index) {
    if (state.expandedIndex == index) {
      emit(state.copyWith(expandedIndex: null));
    } else {
      emit(state.copyWith(expandedIndex: index));
    }
  }
}