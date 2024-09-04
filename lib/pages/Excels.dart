import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/DataProviderImpl.dart';
import '../data/IDataProvider.dart';
import '../widgets/BottomNavBar.dart';
import 'ListingBuildings.dart';
import 'Reports.dart';

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
    await _removeEmptyFiles();
  }

  Future<void> _saveFilePaths() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('filePaths', regions);
  }

  Future<void> _removeEmptyFiles() async {
    List<String> nonEmptyFiles = [];

    for (String filePath in regions) {
      List<Map<String, String>> data = await _dataProvider.loadExcel(filePath);
      if (data.isNotEmpty) {
        nonEmptyFiles.add(filePath);
      } else {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }

    setState(() {
      regions = nonEmptyFiles;
    });

    await _saveFilePaths();
  }

  Future<void> _showDeleteConfirmationDialog(String filePath, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce fichier?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Non'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Oui'),
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
    _navigateWithFadeTransition(
        context, index == 1 ? '/Reports' : '/Excels');
  }

  void _navigateWithFadeTransition(BuildContext context, String routeName) {
    if (ModalRoute.of(context)?.settings.name == routeName) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return routes[routeName]!(context);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Régions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: regions.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        List<Map<String, String>> data =
                        await _dataProvider.loadExcel(regions[index]);
                        if (data.isNotEmpty) {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            '/home',
                            arguments: data,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Le fichier est vide!')
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('images/excel.png'),
                            fit: BoxFit.scaleDown,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const SizedBox.shrink(),
                      ),
                    ),
                    Positioned(
                      top: -12.0,
                      right: 6.0,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          _showDeleteConfirmationDialog(regions[index], index);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  regions[index].split('/').last, // Show the file name only
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                  textAlign: TextAlign.center,
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

            List<Map<String, String>> data =
            await _dataProvider.loadExcel(newFilePath);

            if (data.isNotEmpty) {
              setState(() {
                regions.add(newFilePath);
              });
              await _saveFilePaths();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Le fichier est vide!')),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

final Map<String, WidgetBuilder> routes = {
  '/home': (context) => ListingBuildings(),
  '/Excels': (context) => Excels(),
  '/Reports': (context) => Reports(),
};