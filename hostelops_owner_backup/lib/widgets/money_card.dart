import 'package:flutter/material.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';

class MoneyCard extends StatelessWidget {
  final String amount;
  final String title;
  final bool isPositive;

  const MoneyCard(this.amount, this.title, this.isPositive, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isPositive
            ? AppColors.lightGreen
            : AppColors.lightRed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(amount,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isPositive
                    ? AppColors.success
                    : AppColors.danger,
              )),
          Text(title,
              style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}