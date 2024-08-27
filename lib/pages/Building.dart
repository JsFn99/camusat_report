import 'package:camusat_report/utils/ReportGenerator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher_string.dart';
import '../../models/building_report.dart';

class Building extends StatefulWidget {
  @override
  _BuildingState createState() => _BuildingState();
}

class _BuildingState extends State<Building> {
  BuildingReport buildingReport = BuildingReport();
  Reportgenerator reportGenerator = Reportgenerator();
  bool isPBOToggled = false;
  String selectedPBI = 'RDC';
  Map<String, List<File>> pboImages = {};

  final ImagePicker _picker = ImagePicker();
  List<String> selectedFloors = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final buildingData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    buildingReport.coordonnees =
        '${buildingData['lat']}, ${buildingData['long']}';
    buildingReport.nomPlaque = buildingData['nomPlaque']!;
    buildingReport.adresse = buildingData['adresse']!;

    reportGenerator.buildingData = buildingReport;
  }

  Future<void> _pickImage(ImageSource source, String floor) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        if (!pboImages.containsKey(floor)) {
          pboImages[floor] = [];
        }
        pboImages[floor]!.add(File(image.path));
      });
    }
  }

  Future<void> _openMap() async {
    final latitude = buildingReport.coordonnees!.split(', ')[0];
    final longitude = buildingReport.coordonnees!.split(', ')[1];

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
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Immeuble: ${buildingReport.nomPlaque}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Nom de Plaque: ${buildingReport.nomPlaque}'),
            SizedBox(height: 8.0),
            Text('Adresse: ${buildingReport.adresse}'),
            SizedBox(height: 8.0),
            Text('Coordonnées: ${buildingReport.coordonnees}'),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/loadImages',
                    arguments: buildingReport);
              },
              icon: Icon(Icons.add_a_photo),
              label: Text('Ajouter Photos'),
            ),
            Center(
                child: buildingReport.imageImmeuble != null
                    ? Image.file(buildingReport.imageImmeuble!)
                    : const Text("")),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _openMap,
              icon: Icon(Icons.location_on),
              label: Text('Ouvrir Plan'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                _pickImage(ImageSource.gallery, 'Plan');
              },
              icon: Icon(Icons.photo_library),
              label: Text('Charger Image plan'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/generateSchema');
              },
              icon: Icon(Icons.draw),
              label: Text('Generer Schema'),
            ),
            SizedBox(height: 16.0),

            // PBI Dropdown Menu
            Text('PBI:'),
            DropdownButton<String>(
              value: selectedPBI,
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
                setState(() {
                  selectedPBI = newValue!;
                  buildingReport.pbiLocation = selectedPBI;
                });
              },
            ),

            SizedBox(height: 16.0),

            // PBO Toggle Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PBO:'),
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
              Text('Sélectionnez les étages:'),
              DropdownButtonFormField<String>(
                value: null,
                hint: Text("Choisir les étages"),
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
              SizedBox(height: 16.0),
              for (var floor in selectedFloors)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Étage: $floor'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _pickImage(ImageSource.camera, floor);
                          },
                          icon: Icon(Icons.camera_alt),
                          label: Text('Prendre Photo'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            _pickImage(ImageSource.gallery, floor);
                          },
                          icon: Icon(Icons.photo_library),
                          label: Text('Charger Image'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    if (pboImages[floor] != null &&
                        pboImages[floor]!.isNotEmpty)
                      Wrap(
                        children: pboImages[floor]!
                            .map((imageFile) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.file(imageFile,
                                      width: 100, height: 100),
                                ))
                            .toList(),
                      ),
                  ],
                ),
            ],

            SizedBox(height: 16.0),

            TextField(
              decoration: InputDecoration(labelText: 'Splitere'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  buildingReport.splitere = int.parse(value);
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Validate and save the report
                reportGenerator.generate();
                Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => reportGenerator.getPdf().save(),
                );
              },
              child: Text('Validate'),
            ),
          ],
        ),
      ),
    );
  }
}
