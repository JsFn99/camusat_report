import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Building extends StatefulWidget {
  @override
  _BuildingState createState() => _BuildingState();
}

class _BuildingState extends State<Building> {
  late Map<String, String> buildingData;
  bool isPBOToggled = false; // State variable to track the toggle switch
  File? _takenImage;
  File? _loadedImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    buildingData = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
  }

  Future<void> _pickImage(ImageSource source, bool isForTakenImage) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        if (isForTakenImage) {
          _takenImage = File(image.path);
        } else {
          _loadedImage = File(image.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Details de l immeuble',
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Immeuble: ${buildingData['name']}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Nom de Plaque: ${buildingData['nomPlaque']}'),
            SizedBox(height: 8.0),
            Text('Adresse: ${buildingData['adresse']}'),
            SizedBox(height: 8.0),
            Text('Coordonnées: ${buildingData['lat']} , ${buildingData['long']}'),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/loadImages');
              },
              icon: Icon(Icons.add_a_photo),
              label: Text('Ajouter Photos'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // Open map functionality
              },
              icon: Icon(Icons.map),
              label: Text('Ouvrir Plan'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/generateSchema');
              },
              icon: Icon(Icons.view_agenda),
              label: Text('Generer Schema'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PBO:'),
                Switch(
                  value: isPBOToggled,
                  onChanged: (value) {
                    setState(() {
                      isPBOToggled = value;
                    });
                  },
                ),
              ],
            ),
            // Conditionally show the DropdownButton and camera/gallery buttons
            if (isPBOToggled) ...[
              DropdownButton<String>(
                value: 'RDC',
                items: ['RDC', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    // Handle floor selection
                  });
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _pickImage(ImageSource.camera, true);
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Prendre Photo'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _pickImage(ImageSource.gallery, false);
                    },
                    icon: Icon(Icons.photo_library),
                    label: Text('Charger Image'),
                  ),
                ],
              ),
              if (_takenImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Taken Photo:'),
                      Image.file(_takenImage!),
                    ],
                  ),
                ),
              if (_loadedImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Loaded Image:'),
                      Image.file(_loadedImage!),
                    ],
                  ),
                ),
            ],
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Splitere'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Handle splitter input
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Validate functionality
              },
              child: Text('Validate'),
            ),
          ],
        ),
      ),
    );
  }
}