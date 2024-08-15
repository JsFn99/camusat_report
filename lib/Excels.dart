import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';
import 'DataProviderImpl.dart';
import 'IDataProvider.dart';

class Excels extends StatelessWidget {
  final List<String> regions = [
    'Data/01.1.21-Casa - Bourgogne Ouest A5 - Fiabilisation2.xlsx',
    'Data/Region2.xlsx',
    'Data/Region3.xlsx',
    'Data/Region4.xlsx'
  ];

  final IDataProvider _dataProvider = DataProviderImpl();

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
            return GestureDetector(
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
            );
          },
        ),
      ),
    );
  }
}
