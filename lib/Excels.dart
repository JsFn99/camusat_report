import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'DataProviderImpl.dart';
import 'IDataProvider.dart';

class Excels extends StatefulWidget {
  @override
  _ExcelsState createState() => _ExcelsState();
}

class _ExcelsState extends State<Excels> {
  List<String> regions = [
    // Initialize with your existing files
    'Data/01.1.21-Casa - Bourgogne Ouest A5 - Fiabilisation2.xlsx',
  ];

  final IDataProvider _dataProvider = DataProviderImpl();

  Future<void> _showDeleteConfirmationDialog(String filePath, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez vous vraiment supprimer ce fichier?'),
          actions: <Widget>[
            TextButton(
              child: Text('Non'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
            TextButton(
              child: Text('Oui'),
              onPressed: () async {
                await _dataProvider.deleteFile(filePath);
                setState(() {
                  regions.removeAt(index);
                });
                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Regions",
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: regions.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    List<Map<String, String>> data =
                    await _dataProvider.loadExcel(regions[index]);
                    Navigator.pushNamed(
                      context,
                      '/home',
                      arguments: data,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/excel.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Region ${index + 1}',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmationDialog(regions[index], index);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['xlsx'],
          );

          if (result != null) {
            final filePath = result.files.single.path!;
            final fileName = result.files.single.name;

            final tempDir = await getTemporaryDirectory();
            final newFilePath = '${tempDir.path}/$fileName';
            final file = File(filePath);
            await file.copy(newFilePath);

            setState(() {
              regions.add(newFilePath);
            });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
