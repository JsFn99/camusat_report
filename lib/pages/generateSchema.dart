import 'package:camusat_report/models/building_report.dart';
import 'package:flutter/material.dart';
import 'package:camusat_report/models/schema.dart';
import 'package:camusat_report/utils/SchemaGenerator.dart';
import 'dart:typed_data';
import 'package:printing/printing.dart';

class GenerateSchema extends StatefulWidget {
  @override
  _GenerateSchemaState createState() => _GenerateSchemaState();
}

class _GenerateSchemaState extends State<GenerateSchema> {
  int _nombreEtages = 1;
  List<String> _pboLocations = [];
  List<String> _b2bLocations = [];
  String _selectedPbiLocation = "Facade";
  int _cablesPbo = 1;

  final List<String> _b2b = ['RDC', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  final List<String> _pbiOptions = ['Sous-sol', 'Facade'];
  final List<String> _pboOptions = ['Sous-sol', 'RDC', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  late Schema schema = Schema();
  Uint8List? _pdfBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Générer Schéma",
            style: TextStyle(color: Theme.of(context).indicatorColor),
          ),
          backgroundColor: Colors.orange[800],
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
                            if (_nombreEtages > 1) _nombreEtages--;
                            schema.nbrEtages = _nombreEtages;
                          });
                        },
                      ),
                      Text('$_nombreEtages'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _nombreEtages++;
                            schema.nbrEtages = _nombreEtages;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              const Text('Emplacement des B2B :'),
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
              const SizedBox(height: 16.0),

              const Text('Emplacement PBO :'),
              Wrap(
                children: _pboOptions.map((option) {
                  bool isSelected = _pboLocations.contains(option);
                  return ChoiceChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (isSelected) {
                          _pboLocations.remove(option);
                        } else {
                          _pboLocations.add(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              const Text('Emplacement PBI:'),
              DropdownButton<String>(
                hint: const Text('Sélectionner emplacement PBI '),
                value: _selectedPbiLocation,
                items: _pbiOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedPbiLocation = newValue!;
                    schema.pbiLocation = _pbiOptions.indexOf(_selectedPbiLocation);
                  });
                },
              ),
              const SizedBox(height: 16.0),

              TextField(
                decoration: const InputDecoration(
                  labelText: 'Câbles PBO',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _cablesPbo = int.tryParse(value) ?? 1;
                    schema.cablePbo = int.tryParse(value) ?? 1;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              ElevatedButton(
                onPressed: () async {
                  if (!schema.isValid()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Veuillez remplir tous les champs requis .')),
                    );
                    return;
                  }
                  schema.b2bLocations = {for (int i = 0; i < _b2bLocations.length; i++) i + 1: _b2bLocations[i]};
                  schema.pboLocations = {for (int i = 0; i < _pboLocations.length; i++) i + 1: _pboLocations[i]};

                  BuildingReport.schema = await SchemaGenerator().generateSchema(schema);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Le schéma a été généré .')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Générer schéma'),
              ),
            ],
          ),
        )
    );
  }
}
