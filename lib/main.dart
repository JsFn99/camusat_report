import 'package:flutter/material.dart';
import 'dart:async';  // Import this for the timer

import 'pages/Building.dart';
import 'pages/Excels.dart';
import 'pages/Home.dart';
import 'pages/LoadImages.dart';
import 'pages/Reports.dart';
import 'pages/generateSchema.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black),
      routes: {
        "/home": (context) => Home(),
        "/Excels": (context) => Excels(),
        "/building": (context) => Building(),
        "/loadImages": (context) => LoadImages(),
        "/generateSchema": (context) => GenerateSchema(),
        "/Reports": (context) => Reports(),
      },
      home: LoadingPage(),  // Start with the LoadingPage
    );
  }
}

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, "/Excels");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage("images/camusat.png"),
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[800]!),
            ),
          ],
        ),
      ),
    );
  }
}
