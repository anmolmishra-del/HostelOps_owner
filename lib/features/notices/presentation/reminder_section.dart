import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/widgets/house_loader.dart';
import '../cubit/reminder_cubit.dart';
import '../model/reminder_model.dart';
import 'reminder_card.dart';

class ReminderSection extends StatelessWidget {
  const ReminderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReminderCubit()..loadReminders(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Pending Reminders",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          BlocBuilder<ReminderCubit, List<Reminder>>(
            builder: (context, reminders) {
              if (reminders.isEmpty) {
                return const Center(child: HouseLoader());
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  return ReminderCard(
                    reminder: reminders[index],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}