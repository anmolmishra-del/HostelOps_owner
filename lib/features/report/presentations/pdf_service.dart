import 'package:hostelops_owner/features/report/model/report_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


Future<void> exportReportPdf(ReportData report) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (_) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text("Hostel Report"),
          pw.Text("Revenue: ₹${report.totalRevenue}"),
          pw.Text("Pending: ₹${report.pendingRent}"),
        ],
      ),
    ),
  );

  await Printing.layoutPdf(onLayout: (_) async => pdf.save());
}