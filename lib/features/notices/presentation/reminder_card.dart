import 'package:flutter/material.dart';
import '../model/reminder_model.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;

  const ReminderCard({super.key, required this.reminder});

  Color getColor() {
    switch (reminder.type) {
      case "rent":
        return Colors.red.shade100;
      case "maintenance":
        return Colors.orange.shade100;
      case "water":
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  IconData getIcon() {
    switch (reminder.type) {
      case "rent":
        return Icons.currency_rupee;
      case "maintenance":
        return Icons.build;
      case "water":
        return Icons.water_drop;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ❌ removed width
      margin: const EdgeInsets.only(bottom: 12), // ✅ vertical spacing
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: getColor(),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Icon(getIcon(), size: 18),
              const SizedBox(width: 6),
              Text(
                reminder.type.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            reminder.tenantName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),

          if (reminder.roomNumber != "-")
            Text(
              "Room ${reminder.roomNumber}",
              style: const TextStyle(color: Colors.black54),
            ),

          const SizedBox(height: 8),

          Text(
            reminder.message,
            style: const TextStyle(fontSize: 13),
          ),

          const SizedBox(height: 10), // ❌ replaced Spacer

          Text(
            reminder.date,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}