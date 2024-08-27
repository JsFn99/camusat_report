import 'package:camusat_report/models/building_report.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Reportgenerator {
  final pdf = pw.Document();

  Reportgenerator();

  void generate(BuildingReport reportData) async {
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

    // Building details
    pw.Widget BuildingDetails() {
      return pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 1),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(width: 1)),
              ),
              child: pw.Text(
                "NOM DE LA PLAQUE : ${reportData.nomPlaque}",
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(width: 1)),
              ),
              child: pw.Text(
                reportData.adresse,
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.red300),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(
                "Coordonnées de l'immeuble : ${reportData.coordonnees}",
                style: const pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget TitleBorder(String title) {
      return pw.Container(
        color: PdfColors.amber300,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 1),
        ),
        child: pw.Text(
          title,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
      );
    }

    pw.Widget Spacing(double _height) {
      return pw.SizedBox(height: _height);
    }

    // Report content
    pw.Widget Content() {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Text("Rapport de câblage en fibre optique par CAMUSAT"),
          pw.SizedBox(height: 10),
          reportData.imageImmeuble != null
              ? pw.Image(
                  pw.MemoryImage(reportData.imageImmeuble!.readAsBytesSync()),
                )
              : pw.Text("Image not found"),
          TitleBorder("SITUATION GEOGRAPHIQUE"),
          Spacing(10),
          reportData.screenSituationGeographique != null
              ? pw.Image(
                  pw.MemoryImage(reportData.imageImmeuble!.readAsBytesSync()),
                )
              : pw.Text("Image not found"),
        ],
      );
    }

    // Generating the pdf
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              Header(),
              Spacing(10),
              Title(),
              pw.Divider(),
              Spacing(20),
              BuildingDetails(),
              Spacing(20),
              // Content(),
            ],
          );
        }));
  }

  pw.Document getPdf() {
    return pdf;
  }
}
