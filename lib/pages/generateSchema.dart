import 'package:flutter/material.dart';

class GenerateSchema extends StatefulWidget {
  @override
  _GenerateSchemaState createState() => _GenerateSchemaState();
}

class _GenerateSchemaState extends State<GenerateSchema> {
  int nombreEtages = 1;
  List<String> pbiLocations = [];
  String? selectedPboLocation;
  int cablesPbo = 1;

  List<String> pbiOptions = ['RDC', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  List<String> pboOptions = ['Sous-sol', 'RDC', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Générer Schéma'),
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
                          if (nombreEtages > 1) nombreEtages--;
                        });
                      },
                    ),
                    Text('$nombreEtages'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          nombreEtages++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // PBI Location (Multiple selection)
            Text('PBO Location:'),
            Wrap(
              children: pbiOptions.map((option) {
                bool isSelected = pbiLocations.contains(option);
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (isSelected) {
                        pbiLocations.remove(option);
                      } else {
                        pbiLocations.add(option);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),

            // PBO Location (Single selection)
            Text('PBI Location:'),
            DropdownButton<String>(
              hint: Text('Select PBO Location'),
              value: selectedPboLocation,
              items: pboOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedPboLocation = newValue;
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
                  cablesPbo = int.tryParse(value) ?? 1;
                });
              },
            ),
            SizedBox(height: 16.0),

            // Generate Button
            ElevatedButton(
              onPressed: () {
                // Generate schema logic here
              },
              child: Text('Générer'),
            ),
          ],
        ),
      ),
    );
  }
}
