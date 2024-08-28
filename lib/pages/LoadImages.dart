import 'package:camusat_report/models/building_report.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LoadImages extends StatefulWidget {
  @override
  _LoadImagesState createState() => _LoadImagesState();
}

class _LoadImagesState extends State<LoadImages> {
  late BuildingReport buildingReport;

  Future<void> _pickImage(ImageSource source, String section) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      switch (section) {
        case 'building':
          buildingReport.imageImmeuble = File(image.path).copySync(imagePath);
          break;
        case 'verticality':
          buildingReport.imagePBI = await File(image.path).copy(imagePath);
          break;
        case 'signal':
          buildingReport.imageTestDeSignal =
              await File(image.path).copy(imagePath);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    buildingReport =
        ModalRoute.of(context)!.settings.arguments as BuildingReport;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajouter des Photos',
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Photo de l\'immeuble',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.camera, 'building');
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Prendre Photo'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.gallery, 'building');
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text('Charger Image'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Verticalité PBI',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.camera, 'verticality');
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Prendre Photo'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.gallery, 'verticality');
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text('Charger Image'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Test de signal',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.camera, 'signal');
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Prendre Photo'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.gallery, 'signal');
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text('Charger Image'),
                ),
              ],
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Validate the selections and proceed
              },
              child: Text('Valider'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
