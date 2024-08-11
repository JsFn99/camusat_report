import 'package:flutter/material.dart';

class LoadImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajouter des Photos',
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Photo de l\'immeuble',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Take photo of the building functionality
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Prendre Photo'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Load building photo from gallery functionality
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text('Charger Image'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Verticalite',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Take verticality photo functionality
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Prendre Photo'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Load verticality photo from gallery functionality
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text('Charger Image'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Test de signal',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Take signal test photo functionality
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Prendre Photo'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Load signal test photo from gallery functionality
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text('Charger Image'),
                ),
              ],
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Validate the selections and proceed
              },
              child: Text('Valider'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
