import 'dart:io';
import 'package:camusat_report/utils/ReportGenerator.dart';
import 'package:camusat_report/pages/PdfPreviewer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:camusat_report/models/BuildingReport.dart';
import 'LoadingPage.dart';

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
  String floor = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final buildingData = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    BuildingReport.coordonnees = '${buildingData['lat']}, ${buildingData['long']}';
    BuildingReport.nomPlaque = buildingData['name']!;
    BuildingReport.adresse = buildingData['adresse']!;
    BuildingReport.nom = buildingData['name']!;
  }

  void previewPdf() async {
    List<String> missingItems = [];

    if (BuildingReport.nomPlaque.isEmpty) {
      missingItems.add('Nom de Plaque');
    }
    if (BuildingReport.adresse.isEmpty) {
      missingItems.add('Adresse');
    }
    if (BuildingReport.coordonnees.isEmpty) {
      missingItems.add('Coordonnées');
    }
    if (BuildingReport.imageImmeuble == null) {
      missingItems.add('Image Immeuble');
    }
    if (BuildingReport.schema == null) {
      missingItems.add('Schema');
    }
    if (BuildingReport.screenSituationGeographique == null) {
      missingItems.add('Image Plan');
    }
    if (BuildingReport.imagePBI == null) {
      missingItems.add('Image PBI');
    }
    if (BuildingReport.pbiLocation!.isEmpty) {
      missingItems.add('PBI Location');
    }
    if (BuildingReport.imageTestDeSignal == null) {
      missingItems.add('Image Test de Signal');
    }
    if (BuildingReport.splitere == -1) {
      missingItems.add('Splitere');
    }

    if (missingItems.isNotEmpty) {
      String missingData = missingItems.join('\n- ');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Données manquantes'),
            content: Text('Veuillez fournir les informations suivantes:\n- $missingData'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Navigate to the loading page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoadingPageWait(),
        ),
      );

      // Generate the report
      await reportGenerator.generate();
      var data = await reportGenerator.getPdf();

      // Return to the previous page and show the PDF preview
      Navigator.pop(context); // Remove the loading page
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

  void _openMap() {
    final latitude = BuildingReport.coordonnees.split(', ')[0];
    final longitude = BuildingReport.coordonnees.split(', ')[1];

    launchUrlString(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
  }

  void showPboDialog(BuildContext context) {
    floor = "";
    File? img;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Ajouter un PBO"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: 300,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: const InputDecoration(labelText: 'PBO Etage : '),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                floor = ""; // Reset floor if input is empty
                              } else {
                                try {
                                  int floorNumber = int.parse(value);
                                  floor = floorNumber == 0 ? "RDC" : value;
                                } catch (e) {
                                  floor = ""; // Handle parsing error
                                }
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 16.0),
                        floor == "" ? const Text("Veuillez entrer un étage valide") :
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                            const SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
                                child: const Text("Confirmer"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
          }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Details de l'immeuble",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Immeuble: ${BuildingReport.nom}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            // Text(
            //   'Nom de Plaque: ${BuildingReport.nomPlaque}',
            //   style: const TextStyle(
            //     fontSize: 14,
            //   ),
            // ),
            const SizedBox(height: 8.0),
            Text(
              'Adresse: ${BuildingReport.adresse}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Coordonnées: ${BuildingReport.coordonnees}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8.0),
            const Divider(
              thickness: 2,
            ),
            const SizedBox(height: 8.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/loadImages');
              },
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Ajouter Photos (Immeuble, ...)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: (BuildingReport.areImagesLoaded() == true)
                    ? Colors.green[300]
                    : colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    onPressed: () => _openMap(),
                    icon: const Icon(Icons.location_on),
                    label: const Text('Ouvrir Plan'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child:
                  ElevatedButton.icon(
                    onPressed: () async {
                      BuildingReport.screenSituationGeographique =
                      await _pickImage(ImageSource.gallery);
                      setState(() {
                        imageLoaded['plan'] = true;
                      });
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Charger Image plan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (imageLoaded['plan'] ?? false ) ? Colors.green[300]: colorScheme.primary,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/generateSchema');
              },
              icon: const Icon(Icons.draw),
              label: const Text('Parametrage du schéma'),
              style: ElevatedButton.styleFrom(
                backgroundColor: (BuildingReport.schema != null) ? Colors.green[300]: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            const Divider(
              thickness: 2,
            ),
            const SizedBox(height: 8.0),
            // PBI Dropdown Menu
            const Text('PBI:'),
            const SizedBox(height: 4.0),
            DropdownButton<String>(
              hint: const Text('Sélectionner emplacement PBI '),
              value: selectedPBI,
              items: [
                'Sous-sol',
                'Facade',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
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
                const Text('Liste PBO:'),
                ElevatedButton(
                    onPressed: () => showPboDialog(context),
                    child: const Text('Ajouter PBO'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Column(
              children: [
                ...BuildingReport.imagesPBO.entries.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(item.key),
                    );
                }),
              ],
            ),
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
            const SizedBox(height: 36.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async => previewPdf(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
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
