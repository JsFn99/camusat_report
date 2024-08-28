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
            pw.Image(camusatLogo, width: 100, height: 100),
            pw.Image(orangeLogo, width: 50, height: 50),
          ],
        ),
      );
    }

    // Report title
    pw.Widget Title() {
      return pw.Container(
        padding: pw.EdgeInsets.all(10),
        color: PdfColors.amber100,
        width: 400,
        child: pw.Text(
          'DOSSIER FIN DES TRAVAUX',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
          textAlign: pw.TextAlign.center,
        ),
      );
    }

    // Building details (smaller width and centered)
    pw.Widget BuildingDetails() {
      return pw.Container(
        width: 400,
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
    // pw.Image(pw.MemoryImage(reportData.imageImmeuble!.readAsBytesSync())),

    // Title with border (smaller width and centered)
    pw.Widget TitleBorder(String title) {
      return pw.Center(
        child: pw.Container(
          width: 200,
          padding: const pw.EdgeInsets.all(5),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1),
            color: title == "SITUATION GEOGRAPHIQUE"
                ? PdfColors.amber50
                : PdfColors.white,
          ),
          child: pw.Text(
            title,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        ),
      );
    }

    pw.Widget Spacing(double _height) {
      return pw.SizedBox(height: _height);
    }

    // Report content
    pw.Widget Content() {
      return pw.Container(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Center(
              child: pw.Container(
                width: 600,
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black, width: 1),
                ),
                child: pw.Text(
                  "Rapport de câblage en fibre optique par CAMUSAT",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
              ),
            ),
            Spacing(10),
            TitleBorder("SITUATION GEOGRAPHIQUE"),
            Spacing(10),
            // pw.Image(pw.MemoryImage(reportData.screenSituationGeographique!.readAsBytesSync())),
          ],
        ),
      );
    }

    //SITUATION DE CABLAGE container
    pw.Widget Cablage() {
      return pw.Container(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Center(
              child: pw.Container(
                width: 200,
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.amber50,
                  border: pw.Border.all(color: PdfColors.black, width: 1),
                ),
                child: pw.Text(
                  "SITUATION DE CABLAGE",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ),
            ),
            // pw.Image(pw.MemoryImage(reportData.schema!.readAsBytesSync())),
          ],
        ),
      );
    }

    // VERTICALITE
    pw.Widget VERTICALITE() {
      return pw.Container(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Center(
              child: pw.Container(
                width: 200,
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.amber50,
                  border: pw.Border.all(color: PdfColors.black, width: 1),
                ),
                child: pw.Text(
                  "VERTICALITE",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ),
            ),
            // pw.Image(pw.MemoryImage(reportData.schema!.readAsBytesSync())),
          ],
        ),
      );
    }

    // TEST DE RACCORDEMENT
    pw.Widget test() {
      return pw.Container(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Container(
                width: 200,
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.amber50,
                  border: pw.Border.all(color: PdfColors.black, width: 1),
                ),
                child: pw.Text(
                  "TEST DE RACCORDEMENT",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ),
            ),
            Spacing(10),

            pw.Center(
              child: pw.Container(
                width: 200,
                padding: pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                    color: PdfColors.grey300,
                    border: pw.Border.all(color: PdfColors.black, width: 1)
                ),
                child: pw.Text(
                  "TEST DE SIGNAL",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ),
            ),
            Spacing(10),
          ],
        ),
      );
    }

    // Page 1: Header, Title, BuildingDetails, and Content
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              Header(),
              Spacing(20),
              Title(),
              Spacing(20),
              BuildingDetails(),
              Spacing(20),
              Content(),
            ],
          );
        },
      ),
    );

    // Page 2: Cablage
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: Cablage(),
          );
        },
      ),
    );

    // Page 3: VERTICALITE
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: VERTICALITE(),
          );
        },
      ),
    );

    // Page 4: TEST DE RACCORDEMENT
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: test(),
          );
        },
      ),
    );
  }

  pw.Document getPdf() {
    return pdf;
  }
}
