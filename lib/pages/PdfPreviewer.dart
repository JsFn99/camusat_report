import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfPreviewer extends StatelessWidget {
  final Uint8List pdfBytes;

  const PdfPreviewer({super.key, required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pdf Preview"),
      ),
      body: PDFView(
       pdfData: pdfBytes,
      )
    );
  }
}