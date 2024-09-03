import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

import 'IDataProvider.dart';

class DataProviderImpl implements IDataProvider {
  @override
  Future<List<Map<String, String>>> loadExcel(String filePath) async {
    try {
      File file = File(filePath);
      Uint8List bytes = await file.readAsBytes();
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
            'lat': row[7]?.value?.toString() ?? 'Unknown',
            'long': row[6]?.value?.toString() ?? 'Unknown',
          });
        }
      }
      return parsedData;
    } catch (e) {
      print('Error loading Excel file: $e');
      return [];
    }
  }

  Future<void> deleteFile(String filePath) async {
    try {
      File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
}
