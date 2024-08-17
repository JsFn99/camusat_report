import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BottomNavBar.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/Excels');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/Reports');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reports",
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: reportTitles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(reportTitles[index]),
            subtitle: Text(reportDates[index]),
            onTap: () {
              // Handle report selection
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
