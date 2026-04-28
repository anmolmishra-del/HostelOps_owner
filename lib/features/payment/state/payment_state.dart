import 'package:hostelops_owner/features/payment/state/payment_model.dart';

class PaymentState {
  final bool isLoading;
  final List<PaymentModel> payments;
  final String? error;
  final int? expandedIndex;

  const PaymentState({
    this.isLoading = false,
    this.payments = const [],
    this.error,
    this.expandedIndex,
  });

  PaymentState copyWith({
    bool? isLoading,
    List<PaymentModel>? payments,
    String? error,
    int? expandedIndex,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      payments: payments ?? this.payments,
      error: error,
      expandedIndex: expandedIndex,
    );
  }
}