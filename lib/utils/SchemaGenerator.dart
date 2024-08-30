import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/schema.dart';

class SchemaGenerator {
  Future<pw.Widget> generateSchema(Schema schema) async {
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

    final pdf = pw.Document();

    final pdfFormat = PdfPageFormat.a5.landscape;

    int totalFloors = schema.nbrEtages! + 1;

    String getOrdinalSuffix(int number) {
      if (number == 0) return 'RDC';
      if (number == 1) return '1er';
      return '$numberème';
    }

    // Create the table
    return pw.Stack(
      alignment: pw.Alignment.center,
      children: [
        // Red line spanning the entire height of the table
        pw.Positioned(
          left: PdfPageFormat.a5.width / 4,
          // Position the line in the second column
          child: pw.Container(
            width: 2, // Width of the red line
            height: totalFloors * 40, // Height to cover the full table
            color: PdfColors.red, // Line color
          ),
        ),

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
            // Iterate over the floors from top to bottom
            for (int i = totalFloors - 1; i >= 0; i--)
              pw.TableRow(
                children: [
                  // First column: Floor number with ordinal suffix
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      getOrdinalSuffix(i),
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ),

                  // Second column: Nature of the floor (B2B or House)
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Image(
                      schema.b2bLocations.containsKey(i)
                          ? companyImg
                          : houseImg,
                      width: 40,
                      height: 40,
                    ),
                  ),

                  // Third column: Grey background with circle and triangle images
                  pw.Container(
                    height: 40,
                    color: PdfColors.grey,
                    child: pw.Stack(
                      alignment: pw.Alignment.center,
                      children: [
                        if (schema.pbiLocation == i)
                          pw.Image(
                            circleImg,
                            width: 20,
                            height: 20,
                          ),
                        if (schema.pboLocations.containsKey(i))
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
                    child: pw.Image(
                      schema.b2bLocations.containsKey(i)
                          ? companyImg
                          : houseImg,
                      width: 40,
                      height: 40,
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