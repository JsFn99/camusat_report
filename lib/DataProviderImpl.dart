import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'IDataProvider.dart';

class DataProviderImpl implements IDataProvider {
  @override
  Future<List<Map<String, String>>> loadExcel(String filePath) async {
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
          'adresse':
              "${row[2]?.value?.toString() ?? ''} ${row[5]?.value?.toString() ?? ''}",
          'lat': row[6]?.value?.toString() ?? 'Unknown',
          'long': row[7]?.value?.toString() ?? 'Unknown',
        });
      }
    }
    return parsedData;
  }
}
