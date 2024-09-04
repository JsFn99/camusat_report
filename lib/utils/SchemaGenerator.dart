import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/schema.dart';

class SchemaGenerator {
  Future<pw.Widget> generateSchema() async {
    final companyImg = pw.MemoryImage(
      (await rootBundle.load('images/company.png')).buffer.asUint8List(),
    );

    final houseImg = pw.MemoryImage(
      (await rootBundle.load('images/house.png')).buffer.asUint8List(),
    );

    final circleImg = pw.MemoryImage(
      (await rootBundle.load('images/circle.png')).buffer.asUint8List(),
    );

    final triangleImg = pw.MemoryImage(
      (await rootBundle.load('images/triangle.png')).buffer.asUint8List(),
    );

    final redLineImg = pw.MemoryImage(
      (await rootBundle.load('images/redLine.png')).buffer.asUint8List(),
    );

    int totalFloors = Schema.nbrEtages + 1;
    int maxPboFloor = Schema.pboLocations.reduce((a, b) => a > b ? a : b);

    String getOrdinalSuffix(int number) {
      if (number == 0) return 'RDC';
      if (number == 1) return '1er';
      return '$numberème';
    }

    // Create the table
    return pw.Stack(
      alignment: pw.Alignment.center,
      children: [
        // Table with rows and content
        pw.Table(
          border: pw.TableBorder.all(width: 0),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(1),
            3: const pw.FlexColumnWidth(2),
          },
          children: [
            // Iterate over the floors from top (highest) to bottom (RDC)
            for (int i = totalFloors - 1; i >= 0 ; i--)
              pw.TableRow(
                children: [
                  // First column: Floor number with ordinal suffix
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Center(
                      child: pw.Text(
                        // getOrdinalSuffix(i),
                        getOrdinalSuffix(i),
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.red,
                        ),
                      ),
                    ),
                  ),

                  // Second column: Nature of the floor (B2B or House)
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Center(
                      child: pw.Image(
                        Schema.b2bLocations.containsKey(i)
                            ? companyImg
                            : houseImg,
                        width: Schema.b2bLocations.containsKey(i) ? 25 : 35,
                        height: Schema.b2bLocations.containsKey(i) ? 25 : 35,
                      ),
                    ),
                  ),

                  // Third column: Grey background with circle and triangle images
                  pw.Container(
                    height: 40,
                    color: PdfColors.grey,
                    child: pw.Stack(
                      alignment: pw.Alignment.center,
                      children: [
                        if (maxPboFloor >= i)
                          pw.Image(
                            redLineImg,
                          ),
                        if (Schema.pbiLocation == 'Facade' && i == 0)
                          pw.Image(
                            circleImg,
                            width: 15,
                            height: 15,
                          ),
                        if (Schema.pboLocations.contains(i))
                          pw.Image(
                            triangleImg,
                            width: 20,
                            height: 20,
                          ),
                      ],
                    ),
                  ),

                  // Fourth column: Same as second, includes B2B or House location
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Center(
                      child: pw.Image(
                        Schema.b2bLocations.containsKey(i)
                            ? companyImg
                            : houseImg,
                        width: Schema.b2bLocations.containsKey(i) ? 25 : 35,
                        height: Schema.b2bLocations.containsKey(i) ? 25 : 35,
                      ),
                    ),
                  ),
                ],
              ),
            if (Schema.pbiLocation == "Sous-sol")
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Center(
                      child: pw.Text(
                        'Sous-sol',
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.red,
                        ),
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Center(
                      child: pw.Text(""),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Center(
                      child: pw.Image(
                        circleImg,
                        width: 15,
                        height: 15,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

// cables pbo if cable pbo == 1 => 12FO else == 2 => 24FO else >= 3 => 48FO
