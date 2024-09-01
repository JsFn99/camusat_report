import 'dart:io';

import 'package:camusat_report/models/BuildingReport.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Reportgenerator {
  late pw.Document pdf;

  bool isReportDataValid() {
    bool isImageValid(File? image) {
      return image != null && image.existsSync();
    }

    if (isImageValid(BuildingReport.imageImmeuble) &&
        isImageValid(BuildingReport.imagePBI) &&
        isImageValid(BuildingReport.screenSituationGeographique) &&
        BuildingReport.schema != null &&
        isImageValid(BuildingReport.imageTestDeSignal)) return true;

    return false;
  }

  Future<void> generate() async {
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

    pw.Widget placeImage(File img, {double? width, double? height}) {
      return pw.Center(
        child: pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.amber50,
            border: pw.Border.all(color: PdfColors.black, width: 1),
          ),
          child: pw.FittedBox(
            fit: pw.BoxFit.contain,
            child: pw.Image(
              pw.MemoryImage(img.readAsBytesSync()),
              // fit: pw.BoxFit.scaleDown,
              width: width ?? 200,
              height: height ?? 300,
            ),
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
          double? padding,
          double? width}) {
      return pw.Center(
        child: pw.Container(
          width: width ?? 200,
          padding: pw.EdgeInsets.all(padding ?? 10),
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
                "NOM DE LA PLAQUE : ${BuildingReport.nomPlaque}",
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(width: 1)),
              ),
              child: pw.Text(
                BuildingReport.adresse,
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
                "Coordonnées de l'immeuble : ${BuildingReport.coordonnees}",
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
            placeImage(BuildingReport.imageImmeuble!),
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
            placeImage(BuildingReport.screenSituationGeographique!),
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
            BuildingReport.schema!,
            // TODO : Render schema ;
          ],
        ),
      );
    }

    pw.Widget widgetListPBO() {
      var listPbo = BuildingReport.imagesPBO.entries;

      String getPboLabel(int key) {
        switch (key) {
          case 0:
            return 'PBO "RDC"';
          case 1:
            return 'PBO "1er"';
          case 2:
            return 'PBO "2eme"';
          case 3:
            return 'PBO "3eme"';
          case 4:
            return 'PBO "4eme"';
          case 5:
            return 'PBO "5eme"';
          case 6:
            return 'PBO "6eme"';
          default:
            return 'PBO "${key}eme"';
        }
      }

      return pw.GridView(
        crossAxisCount: BuildingReport.imagesPBO.length > 3 ? 3 : BuildingReport.imagesPBO.length,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1,
        children: listPbo.map((entry) {
          // Use the function to get the PBO label
          final label = getPboLabel(int.parse(entry.key));

          return pw.Container(
            alignment: pw.Alignment.center,
            padding: const pw.EdgeInsets.all(4),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                titleBorder(
                    title: label,
                    padding: 2,
                    width: 100,
                    background: PdfColors.grey300
                ),
                spacing(10),
                placeImage(entry.value, width: 100, height: 120),
              ],
            ),
          );
        }).toList(),
      );
    }


    // VERTICALITE
    pw.Widget pageVerticalite() {
      return pw.Container(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            titleBorder(title: "VERTICALITE"),
            spacing(10),
            titleBorder(
              title: BuildingReport.pbiLocation == "Sous-sol" ? "PBI \"Sous-sol\"" : "PBI \"FACADE\"",
              background: PdfColors.grey300,
              padding: 2,
            ),
            spacing(10),
            placeImage(BuildingReport.imagePBI!, width: 100, height: 120),
            spacing(10),
            pw.Center(child: widgetListPBO()),
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
            placeImage(BuildingReport.imageTestDeSignal!),
            spacing(20),
            titleBorder(
              title: BuildingReport.splitere > 32 ? "SPLITERE 2 (1*8)" : "SPLITERE (1*8)",
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

Future<Uint8List >getPdf() async {
    Uint8List data = await pdf.save();
    return data;
  }
}