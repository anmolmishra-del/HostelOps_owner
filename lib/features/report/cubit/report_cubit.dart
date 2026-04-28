import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/features/report/model/report_model.dart';


enum ReportFilter { today, month, custom }

class ReportCubit extends Cubit<ReportData?> {
  ReportCubit() : super(null);

  ReportFilter currentFilter = ReportFilter.month;
  DateTimeRange? selectedRange;

  void loadReport(ReportFilter filter) async {
    currentFilter = filter;

    await Future.delayed(const Duration(milliseconds: 500));

    emit(
      ReportData(
        totalRevenue: filter == ReportFilter.today ? 5000 : 120000,
        pendingRent: 25000,
        occupiedRooms: 18,
        vacantRooms: 4,
        totalTenants: 22,
        revenueData: [10, 20, 15, 30, 25, 40],
        expenseData: [8, 15, 10, 20, 18, 25],
      ),
    );
  }

  void setCustomRange(DateTimeRange range) {
    selectedRange = range;
    loadReport(ReportFilter.custom);
  }
}