import 'package:camusat_report/models/building_report.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Reportgenerator {
  final pdf = pw.Document();

  Reportgenerator();

  bool isReportDataValide(BuildingReport reportData) {
    return true;
  }

  void generate(BuildingReport reportData) async {
    isReportDataValide(reportData);
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

    pw.Widget spacing(double height) {
      return pw.SizedBox(height: height);
    }

    // Report title
    pw.Widget Title() {
      return pw.Container(
        padding: const pw.EdgeInsets.all(10),
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

    // Title with border (smaller width and centered)
    pw.Widget titleBorder(
        {required String title, PdfColor? background, PdfColor? foreground}) {
      return pw.Center(
        child: pw.Container(
          width: 200,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: background ?? PdfColors.amber50,
            border: pw.Border.all(color: PdfColors.black, width: 1),
          ),
          child: pw.Text(
            title,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: foreground ?? PdfColors.black,
            ),
          ),
        ),
      );
    }

    // Building details (smaller width and centered)
    pw.Widget buildingDetails() {
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

    // Report content
    pw.Widget pageMeuble() {
      return pw.Container(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            titleBorder(
                title: "Rapport de câblage en fibre optique par CAMUSAT"),
            spacing(10),
            // pw.Image(pw.MemoryImage(reportData.screenSituationGeographique!.readAsBytesSync())),
          ],
        ),
      );
    }

    pw.Widget pageSituationGeo() {
      return pw.Container();
    }

    //SITUATION DE CABLAGE container
    pw.Widget pageCablage() {
      return pw.Container(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            titleBorder(title: "SITUATION DE CABLAGE"),
            // pw.Image(pw.MemoryImage(reportData.schema!.readAsBytesSync())),
          ],
        ),
      );
    }

    // VERTICALITE
    pw.Widget pageVerticalite() {
      return pw.Container(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            titleBorder(title: "VERTICALITE"),
            // pw.Image(pw.MemoryImage(reportData.schema!.readAsBytesSync())),
          ],
        ),
      );
    }

    // TEST DE RACCORDEMENT
    pw.Widget pageTestRaccordement() {
      return pw.Container(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            titleBorder(title: "TEST DE RACCORDEMENT"),
            spacing(10),
            titleBorder(
              title: "TEST DE SIGNAL",
              background: PdfColors.grey300,
            ),
            spacing(10),
          ],
        ),
      );
    }

    // Page 1: Header, Title, BuildingDetails, and Building Page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              Header(),
              spacing(20),
              Title(),
              spacing(20),
              buildingDetails(),
              spacing(20),
              pageMeuble(),
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
            child: pageCablage(),
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
            child: pageVerticalite(),
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
            child: pageTestRaccordement(),
          );
        },
      ),
    );
  }

  pw.Document getPdf() {
    return pdf;
  }
}
