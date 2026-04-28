class ReportData {
  final int totalRevenue;
  final int pendingRent;
  final int occupiedRooms;
  final int vacantRooms;
  final int totalTenants;

  final List<double> revenueData;
  final List<double> expenseData;

  ReportData({
    required this.totalRevenue,
    required this.pendingRent,
    required this.occupiedRooms,
    required this.vacantRooms,
    required this.totalTenants,
    required this.revenueData,
    required this.expenseData,
  });
}