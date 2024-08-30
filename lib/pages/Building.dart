import 'dart:io';
import 'package:camusat_report/utils/ReportGenerator.dart';
import 'package:camusat_report/pages/PdfPreviewer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../models/building_report.dart';

class Building extends StatefulWidget {
  const Building({super.key});

  @override
  _BuildingState createState() => _BuildingState();
}

class _BuildingState extends State<Building> {
  Reportgenerator reportGenerator = Reportgenerator();
  bool isPBOToggled = false;
  String selectedPBI = 'Sous-sol';
  Map<String, List<File>> pboImages = {};
  Map<String, bool> imageLoaded = {
    'plan': false,
    'schema': false,
    'pbi': false,
    'signal': false,
  };

  final ImagePicker _picker = ImagePicker();
  List<String> selectedFloors = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final buildingData = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    BuildingReport.coordonnees = '${buildingData['lat']}, ${buildingData['long']}';
    BuildingReport.nomPlaque = buildingData['nomPlaque']!;
    BuildingReport.adresse = buildingData['adresse']!;
  }

  void previewPdf() async {
    if (reportGenerator.isReportDataValid()) {
      await reportGenerator.generate();
      var data = await reportGenerator.getPdf();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfPreviewer(
            pdfBytes: data, nomPlaque: '${BuildingReport.nomPlaque}',
          ),
        ),
      );
    }
  }

  Future<File> _pickImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source);
    final directory = await getApplicationDocumentsDirectory();
    final imagePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    if (image != null) {
      return File(image.path).copySync(imagePath);
    }
    throw Null;
  }

  Future<File > _pickPBOImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source);
    final directory = await getApplicationDocumentsDirectory();
    final imagePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    if (image != null) {
      return File(image.path).copySync(imagePath);
    }
    throw Null;
  }

  Future<void> _openMap() async {
    final latitude = BuildingReport.coordonnees.split(', ')[0];
    final longitude = BuildingReport.coordonnees.split(', ')[1];

    launchUrlString(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Details de l\'immeuble',
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Immeuble: ${BuildingReport.nomPlaque}',
              style: const TextStyle(
                  fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Nom de Plaque: ${BuildingReport.nomPlaque}'),
            const SizedBox(height: 8.0),
            Text('Adresse: ${BuildingReport.adresse}'),
            const SizedBox(height: 8.0),
            Text('Coordonnées: ${BuildingReport.coordonnees}'),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/loadImages');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColorLight),
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Ajouter Photos'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _openMap,
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColorLight),
              icon: const Icon(Icons.location_on),
              label: const Text('Ouvrir Plan'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                BuildingReport.screenSituationGeographique =
                await _pickImage(ImageSource.gallery);
                setState(() {
                  imageLoaded['plan'] = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: (imageLoaded['plan'] ?? false)
                    ? Colors.green
                    : Theme.of(context).primaryColorLight,
              ),
              icon: const Icon(Icons.photo_library),
              label: const Text('Charger Image plan'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/generateSchema');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: (imageLoaded['schema'] ?? false)
                    ? Colors.green
                    : Theme.of(context).primaryColorLight,
              ),
              icon: const Icon(Icons.draw),
              label: const Text('Generer Schema'),
            ),
            const SizedBox(height: 16.0),

            // PBI Dropdown Menu
            const Text('PBI:'),
            DropdownButton<String>(
              value: selectedPBI,
              items: [
                'Sous-sol',
                'Facade',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPBI = newValue!;
                  BuildingReport.pbiLocation = selectedPBI;
                  imageLoaded['pbi'] = true;
                });
              },
            ),

            const SizedBox(height: 16.0),

            // PBO Toggle Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('PBO:'),
                Switch(
                  value: isPBOToggled,
                  onChanged: (value) {
                    setState(() {
                      isPBOToggled = value;
                      if (!value) {
                        pboImages.clear();
                        selectedFloors.clear();
                      }
                    });
                  },
                ),
              ],
            ),

            if (isPBOToggled) ...[
              const Text('Sélectionnez les étages:'),
              DropdownButtonFormField<String>(
                value: null,
                hint: const Text("Choisir les étages"),
                items: [
                  'Sous-sol',
                  'RDC',
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  '10'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null && !selectedFloors.contains(newValue)) {
                    setState(() {
                      selectedFloors.add(newValue);
                    });
                  }
                },
                onSaved: (value) {
                  if (value != null && !selectedFloors.contains(value)) {
                    setState(() {
                      selectedFloors.add(value);
                    });
                  }
                },
              ),
              const SizedBox(height: 16.0),
              for (var floor in selectedFloors)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Étage: $floor'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            BuildingReport.imagesPBO[floor] = await _pickPBOImage(ImageSource.camera);
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Prendre Photo'),
                        ),
                        const Text(
                          'OU',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () async {
                            BuildingReport.imagesPBO[floor] = await _pickPBOImage(ImageSource.gallery);
                          },
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Charger Image'),
                        ),
                      ],
                    ),
                  ],
                ),
            ],

            const SizedBox(height: 16.0),

            TextField(
              decoration: const InputDecoration(labelText: 'Splitere'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  BuildingReport.splitere = int.parse(value);
                });
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async => previewPdf(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).badgeTheme.backgroundColor,
                  ),
                  child: const Text('Generer Rapport'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
