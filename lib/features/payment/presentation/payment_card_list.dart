import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/features/payment/service/payment_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hostelops_owner/core/theme/app_colours.dart';
import 'package:hostelops_owner/features/payment/cubit/payment_cubit.dart';
import 'package:hostelops_owner/features/payment/state/payment_state.dart';
import 'package:hostelops_owner/widgets/house_loader.dart';

class PaymentListScreen extends StatelessWidget {
  final int hostelId;

  const PaymentListScreen({super.key, required this.hostelId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentCubit()..fetchPayments(hostelId),
      child: Scaffold(
        appBar: AppBar(title: const Text("Payments")),

        body: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: HouseLoader());
            }

            if (state.payments.isEmpty) {
              return const Center(child: Text("No Payments"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.payments.length,
              itemBuilder: (context, index) {
                final item = state.payments[index];
                final tenant = item.tenant;
                final room = tenant.room;

                final isPending = item.status == "pending";
                final isPaid = item.status == "paid";
                final isExpanded = state.expandedIndex == index;

                final color = isPending ? Colors.red : Colors.green;

                return GestureDetector(
                  onTap: () {
                    context.read<PaymentCubit>().toggleExpand(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        /// 🔥 TOP ROW
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: color.withOpacity(0.2),
                              child: Text(
                                tenant.name.isNotEmpty
                                    ? tenant.name[0].toUpperCase()
                                    : "U",
                              ),
                            ),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tenant.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Room ${room.roomNumber}"),
                                  Text(
                                    tenant.phone,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item.status.toUpperCase(),
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        /// 🔥 EXPANDED
                        if (isExpanded) ...[
                          const SizedBox(height: 12),
                          const Divider(),

                          _row("Rent", "₹${item.amount}"),
                          // _row("Deposit", "₹${tenant.deposit}"),

                          _row(
                            "Total",
                            "₹${item.amount }",
                            bold: true,
                          ),

                          _row(
                            "Due Date",
                            item.dueDate.toString().split(" ")[0],
                          ),

                          const SizedBox(height: 10),

                          /// 🟢 PAID UI
                          if (isPaid) ...[
                            const Divider(),

                            _row(
                              "Transaction ID",
                              item.transactionId ?? "N/A",
                            ),

                            _row(
                              "Payment Mode",
                              item.paymentMethod ?? "N/A",
                            ),

                            const SizedBox(height: 10),

                            /// 🔥 DOWNLOAD BUTTON
                            if (item.billPdfUrl != null)
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final uri = Uri.parse(item.billPdfUrl!);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.download),
                                label: const Text("Download Receipt"),
                              ),

                            const SizedBox(height: 8),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "Payment Completed",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],

                          /// 🔴 PENDING UI
                          if (isPending)
                            ElevatedButton(
                              onPressed: () {
                                _showOtpDialog(context,(item.id));
                              },
                              child: const Text("Mark as Paid"),
                            ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
void _showOtpDialog(BuildContext context, int billId) {
  final controllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());

  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  "Verify OTP",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// OTP BOXES
                Row(
                  children: List.generate(6, (index) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: TextField(
                            controller: controllers[index],
                            focusNode: focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                FocusScope.of(dialogContext)
                                    .requestFocus(focusNodes[index + 1]);
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(dialogContext)
                                    .requestFocus(focusNodes[index - 1]);
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 28),

                /// VERIFY BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final otp =
                                controllers.map((c) => c.text).join();

                            if (otp.length < 6) {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                const SnackBar(
                                    content: Text("Enter full OTP")),
                              );
                              return;
                            }

                            setState(() => isLoading = true);

                            final res = await PaymentService.verifyOtp(
                              billId: billId,
                              otp: otp,
                            );

                            setState(() => isLoading = false);

                            if (res["success"]) {
                              Navigator.pop(dialogContext);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Payment Successful"),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              /// 🔥 REFRESH LIST
                              context.read<PaymentCubit>().fetchPayments(hostelId);
                            } else {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(
                                  content: Text(res["message"]),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Verify & Continue",
                            style:
                                TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
  Widget _row(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}