import 'package:flutter/material.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String title;
  final IconData icon;

  const StatCard(this.value, this.title, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12), // reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          // 🔷 Icon Box
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),

          const SizedBox(width: 8),

          // ✅ FIX: Expanded prevents overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis, // ✅ safety
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 11),
                  overflow: TextOverflow.ellipsis, // ✅ safety
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}