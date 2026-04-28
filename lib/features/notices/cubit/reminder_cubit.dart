import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/reminder_model.dart';

class ReminderCubit extends Cubit<List<Reminder>> {
  ReminderCubit() : super([]);

  void loadReminders() async {
    await Future.delayed(const Duration(seconds: 1));

    emit([
      Reminder(
        tenantName: "Ravi Kumar",
        roomNumber: "A-101",
        type: "rent",
        message: "Rent ₹5000 pending",
        date: "Due: Apr 30",
      ),
      Reminder(
        tenantName: "Anil Reddy",
        roomNumber: "B-202",
        type: "maintenance",
        message: "Maintenance pending",
        date: "Today",
      ),
      Reminder(
        tenantName: "All Tenants",
        roomNumber: "-",
        type: "water",
        message: "Water supply will be off from 10AM–2PM",
        date: "Today",
      ),
    ]);
  }
}