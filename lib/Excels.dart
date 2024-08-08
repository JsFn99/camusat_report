import 'package:flutter/material.dart';

class Excels extends StatelessWidget {
  final List<String> regions = ['Region 1', 'Region 2', 'Region 3', 'Region 4'];

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
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    regions[index],
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
