import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, String>> data = [];
  List<Map<String, String>> filteredData = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move the logic to didChangeDependencies
    data = ModalRoute.of(context)!.settings.arguments as List<Map<String, String>>;
    filteredData = data;
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = data;
      } else {
        filteredData = data.where((item) {
          return item['name']!.toLowerCase().contains(query.toLowerCase()) ||
              item['id']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Search'),
              onChanged: _filterData,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredData[index]['name']!),
                  subtitle: Text('ID: ${filteredData[index]['id']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
