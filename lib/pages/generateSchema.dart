import 'package:flutter/material.dart';
import 'package:camusat_report/models/schema.dart';

class GenerateSchema extends StatefulWidget {
  @override
  _GenerateSchemaState createState() => _GenerateSchemaState();
}

class _GenerateSchemaState extends State<GenerateSchema> {
  int _nombreEtages = 1;
  List<String> _pboLocations = [];
  List<String> _b2bLocations = [];
  String? _selectedPboLocation;
  int _cablesPbo = 1;

  List<String> _b2b = ['RDC', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  List<String> _pbiOptions = ['RDC', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  List<String> _pboOptions = ['Sous-sol', 'RDC', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  late Schema schema = Schema();

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
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Nombre d'étages
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nombre d\'étages:'),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (_nombreEtages > 1) _nombreEtages--;
                        });
                      },
                    ),
                    Text('$_nombreEtages'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _nombreEtages++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // B2B Location (Multiple selection)
            Text('Emplacement des B2B :'),
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
            SizedBox(height: 16.0),

            // PBI Location (Multiple selection)
            Text('Emplacement PBO :'),
            Wrap(
              children: _pbiOptions.map((option) {
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
            SizedBox(height: 16.0),

            // PBO Location (Single selection)
            Text('Emplacement PBI:'),
            DropdownButton<String>(
              hint: Text('Sélectionner emplacement PBI '),
              value: _selectedPboLocation,
              items: _pboOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedPboLocation = newValue;
                });
              },
            ),
            SizedBox(height: 16.0),

            // Cables PBO
            TextField(
              decoration: InputDecoration(
                labelText: 'Câbles PBO',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _cablesPbo = int.tryParse(value) ?? 1;
                });
              },
            ),
            SizedBox(height: 16.0),

            // Generate Button
            ElevatedButton(
              onPressed: () {
                // Assign the user inputs to the Schema object
                schema.nbrEtages = _nombreEtages;
                schema.b2bLocations = {for (int i = 0; i < _b2bLocations.length; i++) i: _b2bLocations[i]};
                schema.pboLocations = {for (int i = 0; i < _pboLocations.length; i++) i: _pboLocations[i]};
                schema.pbiLocation = _pboOptions.indexOf(_selectedPboLocation!);
                schema.cablePbo = _cablesPbo;

                // Implement your schema generation logic here

                print('Schema generated with the following data:');
                print('Nombre d\'étages: ${schema.nbrEtages}');
                print('Emplacement B2B: ${schema.b2bLocations}');
                print('Emplacement PBO: ${schema.pboLocations}');
                print('Emplacement PBI: ${schema.pbiLocation}');
                print('Câbles PBO: ${schema.cablePbo}');
              },
              child: Text('Générer schéma'),
            ),
          ],
        ),
      ),
    );
  }
}