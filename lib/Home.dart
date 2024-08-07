import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  final List<String> _elements = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry', 'Fig', 'Grape', 'Honeydew', 'Jackfruit', 'Kiwi', 'Lemon', 'Mango', 'Nectarine', 'Orange', 'Papaya', 'Quince', 'Raspberry', 'Strawberry', 'Tangerine', 'Ugli fruit', 'Vanilla bean', 'Watermelon', 'Xigua', 'Yuzu', 'Zucchini'];
  List<String> _filteredElements = [];

  @override
  void initState() {
    super.initState();
    _filteredElements = _elements;
  }

  void _filterElements(String query) {
    final filtered = _elements.where((element) => element.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {
      _filteredElements = filtered;
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
              onChanged: _filterElements,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredElements.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredElements[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
