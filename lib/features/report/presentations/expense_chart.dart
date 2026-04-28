import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseRevenueChart extends StatelessWidget {
  final List<double> revenue;
  final List<double> expense;

  const ExpenseRevenueChart({
    super.key,
    required this.revenue,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Revenue vs Expense",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [

                  LineChartBarData(
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    spots: List.generate(
                      revenue.length,
                      (i) => FlSpot(i.toDouble(), revenue[i]),
                    ),
                  ),

                  LineChartBarData(
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    spots: List.generate(
                      expense.length,
                      (i) => FlSpot(i.toDouble(), expense[i]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}