import 'package:camusat_report/models/building_report.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Reportgenerator {
  final pdf = pw.Document();
  BuildingReport? buildingData;

  Reportgenerator({this.buildingData});

  void generate() async {
    final ByteData camusatLogoData =
        await rootBundle.load('images/camusat.png');
    final ByteData orangeLogoData = await rootBundle.load('images/orange.png');
    final camusatLogo = pw.MemoryImage(camusatLogoData.buffer.asUint8List());
    final orangeLogo = pw.MemoryImage(orangeLogoData.buffer.asUint8List());

    // Report header
    pw.Widget Header() {
      return pw.Container(
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Image(camusatLogo, width: 50, height: 50),
            pw.Image(orangeLogo, width: 50, height: 50),
          ],
        ),
      );
    }

    // Report title
    pw.Widget Title() {
      return pw.Container(
        padding: pw.EdgeInsets.all(10),
        color: PdfColors.blueGrey, // Custom background color
        width: double.infinity,
        child: pw.Text(
          'DOSSIER FIN DES TRAVAUX',
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white, // Text color
          ),
          textAlign: pw.TextAlign.center,
        ),
      );
    }
    // Report content
    // pw.Widget Content() {

    // }

    // Generating the pdf
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              Header(),
              pw.SizedBox(height: 10), // spacing
              Title(),
              pw.Divider(),
            ],
          );
        }));
  }

  pw.Document getPdf() {
    return pdf;
  }
}
