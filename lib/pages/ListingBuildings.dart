import 'package:flutter/material.dart';

class ListingBuildings extends StatefulWidget {
  @override
  _ListingBuildingsState createState() => _ListingBuildingsState();
}

class _ListingBuildingsState extends State<ListingBuildings> {
  List<Map<String, String>> data = [];
  List<Map<String, String>> filteredData = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
        title: Text('Immeubles', style: TextStyle(color: Theme.of(context).indicatorColor)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/Excels");
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onChanged: _filterData,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredData[index]['name']!),
                  subtitle: Text('ID: ${filteredData[index]['id']}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/building',
                      arguments: filteredData[index],
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
