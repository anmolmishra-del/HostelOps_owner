import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/features/report/cubit/report_cubit.dart';
import 'package:hostelops_owner/features/report/model/report_model.dart';
import 'package:hostelops_owner/widgets/house_loader.dart';

import 'stat_card.dart';
import 'filter_bar.dart';
import 'expense_chart.dart';
import 'pdf_service.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  Future<void> pickDateRange(BuildContext context) async {
    final cubit = context.read<ReportCubit>();

    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (range != null) {
      cubit.setCustomRange(range);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportCubit()..loadReport(ReportFilter.month),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reports"),
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () {
                final report = context.read<ReportCubit>().state;
                if (report != null) exportReportPdf(report);
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<ReportCubit, ReportData?>(
            builder: (context, report) {
              final cubit = context.read<ReportCubit>();

              if (report == null) {
                return const Center(child: HouseLoader());
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 📅 Filter
                    ReportFilterBar(
                      selected: cubit.currentFilter,
                      onChanged: (filter) {
                        if (filter == ReportFilter.custom) {
                          pickDateRange(context);
                        } else {
                          cubit.loadReport(filter);
                        }
                      },
                    ),

                    /// 📆 Selected range
                    if (cubit.selectedRange != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "${cubit.selectedRange!.start.toString().split(' ')[0]} → ${cubit.selectedRange!.end.toString().split(' ')[0]}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),

                    const SizedBox(height: 16),

                    /// 📊 Stats
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        StatCard(
                          title: "Revenue",
                          value: "₹${report.totalRevenue}",
                          icon: Icons.currency_rupee,
                          color: Colors.green,
                        ),
                        StatCard(
                          title: "Pending",
                          value: "₹${report.pendingRent}",
                          icon: Icons.warning,
                          color: Colors.red,
                        ),
                        StatCard(
                          title: "Occupied",
                          value: "${report.occupiedRooms}",
                          icon: Icons.home,
                          color: Colors.blue,
                        ),
                        StatCard(
                          title: "Vacant",
                          value: "${report.vacantRooms}",
                          icon: Icons.meeting_room,
                          color: Colors.orange,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// 📈 Chart
                    ExpenseRevenueChart(
                      revenue: report.revenueData,
                      expense: report.expenseData,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}