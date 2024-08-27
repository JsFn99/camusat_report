import 'package:camusat_report/data/DataProviderImpl.dart';
import 'package:camusat_report/data/IDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:io';

class ExcelLoaderApp extends StatefulWidget {
  @override
  _ExcelLoaderAppState createState() => _ExcelLoaderAppState();
}

class _ExcelLoaderAppState extends State<ExcelLoaderApp> {
  List<String> excelSheets = [];
  final IDataProvider _dataProvider = DataProviderImpl();

  Future<void> pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      setState(() {
        excelSheets.add(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Excel Loader"),
      ),
      body: excelSheets.isEmpty
          ? Center(child: Text("No Excel sheets loaded"))
          : ListView.builder(
              itemCount: excelSheets.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(excelSheets[index]),
                  onTap: () async {
                    List<Map<String, String>> data =
                        await _dataProvider.loadExcel(excelSheets[index]);
                    Navigator.pushNamed(
                      context,
                      '/home',
                      arguments: data,
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickExcelFile,
        child: Icon(Icons.add),
      ),
    );
  }
}
