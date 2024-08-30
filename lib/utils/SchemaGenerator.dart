import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/schema.dart';

class SchemaGenerator {
  Future<Uint8List> generateSchema(Schema schema) async {
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

    final pdfFormat = PdfPageFormat.a5.portrait;

    int totalFloors = schema.nbrEtages! + 1;

    String getOrdinalSuffix(int number) {
      if (number == 0) return 'RDC';
      if (number == 1) return '1er';
      return '${number}ème';
    }

    // Create the table
    pdf.addPage(
      pw.Page(
        pageFormat: pdfFormat,
        build: (pw.Context context) {
          return pw.Table(
            border: pw.TableBorder.all(width: 0),
            columnWidths: {
              0: pw.FlexColumnWidth(1),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(2),
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
                        style: pw.TextStyle(fontSize: 12),
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
                              width: 15,
                              height: 15,
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
          );
        },
      ),
    );
    return pdf.save();
  }
}
