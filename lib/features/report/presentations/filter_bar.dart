import 'package:flutter/material.dart';
import 'package:hostelops_owner/features/report/cubit/report_cubit.dart';


class ReportFilterBar extends StatelessWidget {
  final ReportFilter selected;
  final Function(ReportFilter) onChanged;

  const ReportFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ReportFilter.values.map((filter) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(filter.name.toUpperCase()),
            selected: filter == selected,
            onSelected: (_) => onChanged(filter),
          ),
        );
      }).toList(),
    );
  }
}