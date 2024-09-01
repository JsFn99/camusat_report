import 'package:camusat_report/models/BuildingReport.dart';
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
    bool allDataLoaded = imageLoaded.values.every((loaded) => loaded);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter des Photos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildSection(
              title: 'Photo de l\'immeuble',
              section: 'building',
              imageLoaded: imageLoaded['building']!,
            ),
            buildSection(
              title: 'Verticalité PBI',
              section: 'verticality',
              imageLoaded: imageLoaded['verticality']!,
            ),
            buildSection(
              title: 'Test de signal',
              section: 'signal',
              imageLoaded: imageLoaded['signal']!,
            ),
            SizedBox.fromSize(size: const Size.fromHeight(16.0)),
            if (allDataLoaded)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, BuildingReport);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  ),
                  child: const Text('Valider'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required String section,
    required bool imageLoaded,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _pickImage(ImageSource.camera, section);
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Prendre Photo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: imageLoaded ? Colors.greenAccent : Colors.blueAccent,
                ),
              ),
              const Text('OU', style: TextStyle(fontSize: 14.0)),
              ElevatedButton.icon(
                onPressed: () {
                  _pickImage(ImageSource.gallery, section);
                },
                icon: const Icon(Icons.photo_library),
                label: const Text('Charger Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: imageLoaded ? Colors.greenAccent : Colors.blueAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
