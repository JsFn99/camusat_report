import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class Building extends StatefulWidget {
  @override
  _BuildingState createState() => _BuildingState();
}

class _BuildingState extends State<Building> {
  late Map<String, String> buildingData;
  bool isPBOToggled = false;
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

  Future<void> _openMap() async {
    final latitude = buildingData['lat']!;
    final longitude = buildingData['long']!;

    final Map<String, String> mapUrls = {
      'Google Maps': 'comgooglemaps://?q=$latitude,$longitude',
      'Maps': 'maps://?q=$latitude,$longitude',
      'Waze': 'waze://?ll=$latitude,$longitude&navigate=yes',
      'Google Earth': 'googleearth://?ll=$latitude,$longitude',
    };

    final choice = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Open Map With'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: mapUrls.keys.map((app) {
              return ListTile(
                title: Text(app),
                onTap: () {
                  Navigator.of(context).pop(mapUrls[app]);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (choice != null) {
      if (await canLaunch(choice)) {
        await launch(choice);
      } else {
        final webUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
        await launch(webUrl);
      }
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
              onPressed: _openMap,
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
