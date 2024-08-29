import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class PdfPreviewer extends StatelessWidget {
  final Uint8List pdfBytes;

  const PdfPreviewer({super.key, required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Votre Pdf"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              await _savePdf(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.email),
            onPressed: () async {
              await _sendViaEmail(context);
            },
          ),
        ],
      ),
      body: PDFView(
        pdfData: pdfBytes,
      ),
    );
  }

  Future<void> _savePdf(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = "rapport_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(pdfBytes);

    // Save report details
    final prefs = await SharedPreferences.getInstance();
    List<String> reportTitles = prefs.getStringList('reportTitles') ?? [];
    List<String> reportDates = prefs.getStringList('reportDates') ?? [];

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    reportTitles.add(fileName);
    reportDates.add(formattedDate);

    await prefs.setStringList('reportTitles', reportTitles);
    await prefs.setStringList('reportDates', reportDates);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF enregistré avec succes !')),
    );
  }

  Future<void> _sendViaEmail(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = "rapport_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(pdfBytes);

    await Share.shareFiles([file.path], text: 'Voici votre rapport sous format pdf.');
  }
}
