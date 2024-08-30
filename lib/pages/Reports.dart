import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../widgets/BottomNavBar.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  List<String> reportTitles = [];
  List<String> reportDates = [];
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      reportTitles = prefs.getStringList('reportTitles') ?? [];
      reportDates = prefs.getStringList('reportDates') ?? [];
    });
  }

  Future<void> _deleteReport(int index) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer le rapport'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce rapport ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        reportTitles.removeAt(index);
        reportDates.removeAt(index);
      });
      await prefs.setStringList('reportTitles', reportTitles);
      await prefs.setStringList('reportDates', reportDates);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Le rapport a été supprimé.')),
      );
    }
  }

  Future<void> _sendReportViaEmail(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    if (await file.exists()) {
      await Share.shareFiles([file.path], text: 'Voici votre rapport sous format pdf.');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fichier introuvable!')),
      );
    }
  }

  Future<void> _openReport(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    if (await file.exists()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFView(
            filePath: file.path,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fichier introuvable!')),
      );
    }
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/Excels');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/Reports');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rapports",
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12.0),
        itemCount: reportTitles.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.insert_drive_file, color: Colors.orange[800], size: 30),
            title: Row(
              children: [
                Expanded(
                  child: Text(reportTitles[index]),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.email, color: Colors.blue),
                      onPressed: () {
                        _sendReportViaEmail(reportTitles[index]);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteReport(index);
                      },
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Text(reportDates[index]),
            onTap: () {
              _openReport(reportTitles[index]);
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
