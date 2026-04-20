import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';

class OccupancyChart extends StatelessWidget {
  const OccupancyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            value: 42, // occupied
            color: AppColors.primary,
            title: "42",
            radius: 50,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          PieChartSectionData(
            value: 8, // vacant
            color: Colors.grey.shade300,
            title: "8",
            radius: 50,
            titleStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}