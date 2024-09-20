import 'package:camusat_report/models/BuildingReport.dart';
import 'package:camusat_report/pages/PdfPreviewer.dart';
import 'package:flutter/material.dart';
import 'package:camusat_report/models/schema.dart';
import 'package:camusat_report/utils/SchemaGenerator.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class GenerateSchema extends StatefulWidget {
  const GenerateSchema({super.key});

  @override
  _GenerateSchemaState createState() => _GenerateSchemaState();
}

class _GenerateSchemaState extends State<GenerateSchema> {
  final List<String> _b2bLocations = [];

  final List<String> _b2b = ['RDC', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  final List<String> _pbiOptions = ['Sous-sol', 'Facade'];
  final List<String> _pboOptions = ['RDC', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Générer Schéma",
            style: TextStyle(color: Theme.of(context).indicatorColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Nombre d'étages
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nombre d\'étages:'),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (Schema.nbrEtages > 1) Schema.nbrEtages--;
                          });
                        },
                      ),
                      Text('${Schema.nbrEtages}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            Schema.nbrEtages++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text('Emplacement des B2B :'),
              const SizedBox(height: 16.0),
              Wrap(
                children: _b2b.map((option) {
                  bool isSelected = _b2bLocations.contains(option);
                  return ChoiceChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (isSelected) {
                          _b2bLocations.remove(option);
                        } else {
                          _b2bLocations.add(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 17.0),
              const Text('Emplacement PBO :'),
              const SizedBox(height: 16.0),
              Wrap(
                children: _pboOptions.map((option) {
                  bool isSelected = Schema.pboLocations.contains(option == "RDC" ? 0 : int.parse(option));
                  return ChoiceChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (isSelected) {
                          Schema.pboLocations.remove(option == "RDC" ? 0 : int.parse(option));
                        } else {
                          Schema.pboLocations.add(option == "RDC" ? 0 : int.parse(option));
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              const Text('Emplacement PBI:'),

              const SizedBox(height: 16.0),

              DropdownButton<String>(
                hint: const Text('Sélectionner emplacement PBI '),
                value: Schema.pbiLocation,
                items: _pbiOptions.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    Schema.pbiLocation = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Nombre de câbles PBO:'),
              const SizedBox(height: 16.0),
              TextField(
                decoration: const InputDecoration(labelText: 'Câbles pbo'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    Schema.nbrCablesPbo = int.parse(value);
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                ),
                onPressed: () async {
                  Schema.b2bLocations = {for (int i = 0; i < _b2bLocations.length; i++) i + 1: _b2bLocations[i]};
                  // Schema.pboLocations = {for (int i = 0; i < _pboLocations.length; i++) i + 1: _pboLocations[i]};

                  BuildingReport.schema = await SchemaGenerator().generateSchema();

                  final schemaPage = pw.Document();
                  schemaPage.addPage(
                    pw.Page(
                      pageFormat: PdfPageFormat.a4,
                      build: (pw.Context context) {
                        return pw.Center(child: BuildingReport.schema!);
                      },
                    ),
                  );
                  final preview = await schemaPage.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfPreviewer(
                        pdfBytes: preview,
                        nomPlaque: BuildingReport.nomPlaque,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Aperçu schéma',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                  backgroundColor: Colors.green[400],
                ),
                onPressed: () async {
                  Schema.b2bLocations = {
                    for (var location in _b2bLocations) _b2b.indexOf(location): location
                  };

                  BuildingReport.schema = await SchemaGenerator().generateSchema();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Le schéma a été généré.')),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Générer schéma',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
