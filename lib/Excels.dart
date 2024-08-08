import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';

class Excels extends StatelessWidget {
  final List<String> regions = [
    'Data/01.1.21-Casa - Bourgogne Ouest A5 - Fiabilisation2.xlsx',
    'Data/Region2.xlsx',
    'Data/Region3.xlsx',
    'Data/Region4.xlsx'
  ];

  Future<List<Map<String, String>>> _loadExcel(String filePath) async {
    ByteData data = await rootBundle.load(filePath);
    var bytes = data.buffer.asUint8List();
    var excel = Excel.decodeBytes(bytes);

    List<Map<String, String>> parsedData = [];

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      for (var row in sheet!.rows.skip(1)) {
        parsedData.add({
          'name': row[5]?.value?.toString() ?? 'Unknown',
          'id': row[11]?.value?.toString() ?? 'Unknown',
          'nomPlaque': row[9]?.value?.toString() ?? 'Unknown',
          'adresse': "${row[2]?.value?.toString() ?? ''} ${row[5]?.value?.toString() ?? ''}",
          'lat': row[6]?.value?.toString() ?? 'Unknown',
          'long': row[7]?.value?.toString() ?? 'Unknown',
        });
      }
    }

    return parsedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regions'),
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
            return GestureDetector(
              onTap: () async {
                List<Map<String, String>> data = await _loadExcel(regions[index]);
                Navigator.pushNamed(
                  context,
                  '/home',
                  arguments: data,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    'Region ${index + 1}',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
