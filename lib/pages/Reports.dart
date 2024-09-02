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
      reportTitles = (prefs.getStringList('reportTitles') ?? []).reversed.toList();
      reportDates = (prefs.getStringList('reportDates') ?? []).reversed.toList();
    });
  }

  Future<void> _deleteReport(int index) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer le rapport'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce rapport ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Supprimer'),
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
        const SnackBar(content: Text('Le rapport a été supprimé.')),
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
        const SnackBar(content: Text('Fichier introuvable!')),
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
        const SnackBar(content: Text('Fichier introuvable!')),
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
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12.0),
        itemCount: reportTitles.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.insert_drive_file, size: 30, color: Colors.blueAccent),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      reportTitles[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.email, color: Colors.blue),
                        onPressed: () {
                          _sendReportViaEmail(reportTitles[index]);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteReport(index);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              subtitle: Text(
                reportDates[index],
                style: TextStyle(color: Colors.grey[600]),
              ),
              onTap: () {
                _openReport(reportTitles[index]);
              },
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}