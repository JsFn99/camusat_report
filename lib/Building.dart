import 'package:flutter/material.dart';

class Building extends StatefulWidget {
  @override
  _BuildingState createState() => _BuildingState();
}

class _BuildingState extends State<Building> {
  late Map<String, String> buildingData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    buildingData = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details de l immeuble'),
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
            Text('Coordonnées: ${buildingData['lat']}, ${buildingData['long']}'),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                // Add photos functionality
              },
              icon: Icon(Icons.add_a_photo), // Icon for adding photos
              label: Text('Ajouter Photos'),
            ),
            SizedBox(height: 10), // Add some space between buttons
            ElevatedButton.icon(
              onPressed: () {
                // Open map functionality
              },
              icon: Icon(Icons.map), // Icon for opening the map
              label: Text('Ouvrir Plan'),
            ),
            SizedBox(height: 10), // Add some space between buttons
            ElevatedButton.icon(
              onPressed: () {
                // Make schema functionality
              },
              icon: Icon(Icons.view_agenda), // Icon for making schema
              label: Text('Generer Schema'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PBO:'),
                Switch(
                  value: false, // Update with the actual state
                  onChanged: (value) {
                    setState(() {
                      // Toggle functionality
                    });
                  },
                ),
              ],
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Take picture functionality
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Prendre Photo'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text('Charger Image'),
                ),
              ],
            ),
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
