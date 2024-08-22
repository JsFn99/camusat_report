import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/DataProviderImpl.dart';
import '../data/IDataProvider.dart';
import '../widgets/BottomNavBar.dart';

class Excels extends StatefulWidget {
  @override
  _ExcelsState createState() => _ExcelsState();
}

class _ExcelsState extends State<Excels> {
  List<String> regions = [];
  final IDataProvider _dataProvider = DataProviderImpl();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadFilePaths();
  }

  Future<void> _loadFilePaths() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      regions = prefs.getStringList('filePaths') ?? [];
    });
  }

  Future<void> _saveFilePaths() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('filePaths', regions);
  }

  Future<void> _showDeleteConfirmationDialog(String filePath, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Etes vous sur de vouloir supprimer le fichier?'),
          actions: <Widget>[
            TextButton(
              child: Text('Non'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Oui'),
              onPressed: () async {
                final file = File(filePath);
                if (await file.exists()) {
                  await file.delete();
                }
                setState(() {
                  regions.removeAt(index);
                });
                await _saveFilePaths();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/Excels');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/Reports');
    }
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
            await _saveFilePaths(); // Save updated list
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
