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

    final legendImg = pw.MemoryImage(
      (await rootBundle.load('images/legend.png')).buffer.asUint8List(),
    );

    final triangleImg = pw.MemoryImage(
      (await rootBundle.load('images/triangle.png')).buffer.asUint8List(),
    );

    final redLineImg = pw.MemoryImage(
      (await rootBundle.load('images/redLine.png')).buffer.asUint8List(),
    );

    final blackLineImg = pw.MemoryImage(
      (await rootBundle.load('images/blackLine.png')).buffer.asUint8List(),
    );

    final cableImg = pw.MemoryImage(
      (await rootBundle.load('images/cable.png')).buffer.asUint8List(),
    );

    int totalFloors = Schema.nbrEtages + 1;
    int maxPboFloor = Schema.pboLocations.reduce((a, b) => a > b ? a : b);

    String getOrdinalSuffix(int number) {
      if (number == 0) return 'RDC';
      if (number == 1) return '1er';
      return '${number}ème';
    }

    // Create the table
    return pw.Column(
      children: [
        pw.Stack(
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
                for (int i = totalFloors - 1; i >= 0; i--)
                  pw.TableRow(
                    children: [
                      // First column: Floor number with ordinal suffix
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Center(
                          child: pw.Column(
                            children: [
                              pw.Text(
                                getOrdinalSuffix(i),
                                style: const pw.TextStyle(
                                  fontSize: 10,
                                  color: PdfColors.red,
                                ),
                              ),
                              if (getOrdinalSuffix(i) == 'RDC')
                                pw.Image(
                                  cableImg,
                                  width: 25,
                                  height: 25,
                                  fit: pw.BoxFit.contain,
                                ),
                            ],
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
                            width:
                            Schema.b2bLocations.containsKey(i) ? 25 : 35,
                            height:
                            Schema.b2bLocations.containsKey(i) ? 25 : 35,
                            fit: pw.BoxFit.contain,
                          ),
                        ),
                      ),

                      // Third column: Grey background with circle and triangle images
                      pw.Container(
                        height: 50,
                        color: PdfColors.grey,
                        child: pw.Stack(
                          alignment: pw.Alignment.center,
                          children: [
                            if (maxPboFloor >= i)
                              pw.Image(
                                redLineImg,
                                fit: pw.BoxFit.contain,
                              ),
                            if (Schema.pboLocations.contains(i))
                              pw.Image(
                                triangleImg,
                                width: 20,
                                height: 20,
                                fit: pw.BoxFit.contain,
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
                            width:
                            Schema.b2bLocations.containsKey(i) ? 25 : 35,
                            height:
                            Schema.b2bLocations.containsKey(i) ? 25 : 35,
                            fit: pw.BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Center(
                        child: pw.Text(
                          '',
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.red,
                          ),
                        ),
                      ),
                    ),
                    pw.Container(
                      height: 40,
                      color: PdfColors.grey,
                      child: pw.Center(
                        child: pw.Image(
                          blackLineImg,
                          fit: pw.BoxFit.contain,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Center(
                        child: Schema.pbiLocation == "Facade"
                            ? pw.Image(
                          circleImg,
                          width: 20,
                          height: 20,
                          fit: pw.BoxFit.contain,
                        )
                            : pw.SizedBox.shrink(),
                      ),
                    ),
                    pw.SizedBox.shrink(),
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
                      pw.SizedBox.shrink(),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Center(
                          child: pw.Image(
                            circleImg,
                            width: 15,
                            height: 15,
                            fit: pw.BoxFit.contain,
                          ),
                        ),
                      ),
                      pw.SizedBox.shrink(),
                    ],
                  ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 15),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (Schema.nbrCablesPbo > 0)
              pw.Container(
                padding: const pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                  color: PdfColors.amber50,
                  border: pw.Border.all(color: PdfColors.black, width: 1),
                ),
                child: pw.Text(
                  Schema.nbrCablesPbo >= 3 ? "Cable 48FO" : "Cable ${Schema.nbrCablesPbo * 12}FO",
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.black,
                  ),
                ),
              ),
            pw.SizedBox(width: 15),
            pw.Image(
              legendImg,
              width: 200,
              height: 150,
              fit: pw.BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }
}
