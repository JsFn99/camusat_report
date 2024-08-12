import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class LoadImages extends StatefulWidget {
  @override
  _LoadImagesState createState() => _LoadImagesState();
}

class _LoadImagesState extends State<LoadImages> {
  File? _buildingImage;
  File? _verticalityImage;
  File? _signalTestImage;

  Future<void> _pickImage(ImageSource source, String section) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        switch (section) {
          case 'building':
            _buildingImage = File(image.path);
            break;
          case 'verticality':
            _verticalityImage = File(image.path);
            break;
          case 'signal':
            _signalTestImage = File(image.path);
            break;
        }
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
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Photo de l\'immeuble',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
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
            if (_buildingImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Image.file(_buildingImage!),
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
            if (_verticalityImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Image.file(_verticalityImage!),
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
            if (_signalTestImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Image.file(_signalTestImage!),
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