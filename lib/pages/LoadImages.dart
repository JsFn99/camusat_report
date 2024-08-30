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
  Map<String, bool> imageLoaded = {
    'building': false,
    'verticality': false,
    'signal': false,
  };

  Future<void> _pickImage(ImageSource source, String section) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      switch (section) {
        case 'building':
          BuildingReport.imageImmeuble = File(image.path).copySync(imagePath);
          break;
        case 'verticality':
          BuildingReport.imagePBI = File(image.path).copySync(imagePath);
          break;
        case 'signal':
          BuildingReport.imageTestDeSignal = File(image.path).copySync(imagePath);
          break;
      }
      setState(() {
        imageLoaded[section] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajouter des Photos',
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: imageLoaded['building'] ?? false
                        ? Colors.green
                        : Theme.of(context).primaryColorLight,
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Prendre Photo'),
                ),
                Text(
                  'OU',
                  style: TextStyle(fontSize: 14.0),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.gallery, 'building');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: imageLoaded['building'] ?? false
                        ? Colors.green
                        : Theme.of(context).primaryColorLight,
                  ),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Charger Image'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Verticalité PBI',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.camera, 'verticality');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: imageLoaded['verticality'] ?? false
                        ? Colors.green
                        : Theme.of(context).primaryColorLight,
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Prendre Photo'),
                ),
                Text(
                  'OU',
                  style: TextStyle(fontSize: 14.0),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.gallery, 'verticality');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: imageLoaded['verticality'] ?? false
                        ? Colors.green
                        : Theme.of(context).primaryColorLight,
                  ),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Charger Image'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Test de signal',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.camera, 'signal');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: imageLoaded['signal'] ?? false
                        ? Colors.green
                        : Theme.of(context).primaryColorLight,
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Prendre Photo'),
                ),
                Text(
                  'OU',
                  style: TextStyle(fontSize: 14.0),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.gallery, 'signal');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: imageLoaded['signal'] ?? false
                        ? Colors.green
                        : Theme.of(context).primaryColorLight,
                  ),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Charger Image'),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, BuildingReport);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }
}
