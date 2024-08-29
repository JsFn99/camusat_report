import 'dart:io';

import 'package:camusat_report/models/building_report.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Reportgenerator {
  late pw.Document pdf;

  bool isReportDataValid(BuildingReport reportData) {
    bool isImageValid(File image) {
      return image.existsSync();
    }

    // Check if the images are not null
    if (isImageValid(reportData.imageImmeuble) &&
        isImageValid(reportData.imagePBI) &&
        isImageValid(reportData.screenSituationGeographique) &&
        isImageValid(reportData.imageTestDeSignal)) return true;

    return false;
  }

  void generate(BuildingReport reportData) async {
    pdf = pw.Document();
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

    pw.Widget placeImage(File img) {
      return pw.Center(
        child: pw.Container(
          padding: const pw.EdgeInsets.all(10),
          height: 300,
          decoration: pw.BoxDecoration(
            color: PdfColors.amber50,
            border: pw.Border.all(color: PdfColors.black, width: 1),
          ),
          child: pw.Image(
            pw.MemoryImage(img.readAsBytesSync()),
            ),
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
        {required String title,
        PdfColor? background,
        PdfColor? foreground,
        double? width}) {
      return pw.Center(
        child: pw.Container(
          width: width ?? 200,
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
              title: "Rapport de câblage en fibre optique par CAMUSAT",
              background: PdfColors.white,
              foreground: PdfColors.blue900,
              width: 800,
            ),
            spacing(20),
            placeImage(reportData.imageImmeuble),
          ],
        ),
      );
    }

    pw.Widget pageSituationGeo() {
      return pw.Container(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            titleBorder(title: "SITUATION GEOGRAPHIQUE"),
            spacing(20),
            placeImage(reportData.screenSituationGeographique),
          ],
        ),
      );
    }

    //SITUATION DE CABLAGE container
    pw.Widget pageCablage() {
      return pw.Container(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            titleBorder(title: "SITUATION DE CABLAGE"),
            spacing(20),
            // TODO : Render schema ;
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
            spacing(20),
            titleBorder(
              title: reportData.pbiLocation == "Sous-sol" ? "PBI \"Sous-sol\"" : "PBI \"FACADE\"",
              background: PdfColors.grey300,
            ),
            spacing(20),
             placeImage(reportData.imagePBI),
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
            spacing(20),
            titleBorder(
              title: "TEST DE SIGNAL",
              background: PdfColors.grey300,
            ),
            spacing(20),
            placeImage(reportData.imageTestDeSignal),
            spacing(20),
            titleBorder(
              title: reportData.splitere > 32 ? "SPLITERE 2 (1*8)" : "SPLITERE (1*8)",
              background: PdfColors.grey300,
            ),
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

    // Page 2: Situation geographique
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pageSituationGeo(),
          );
        },
      ),
    );

    // Page 3: Cablage
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

    // Page 4: VERTICALITE
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

    // Page 5: TEST DE RACCORDEMENT
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

  Uint8List getPdf() {
    Uint8List data = Uint8List(0);
    pdf.save().then((result) => data = result);
    return data;
  }
}
