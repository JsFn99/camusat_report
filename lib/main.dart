import 'package:camusat_report/pages/LoadingPage.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'dart:async';  // Import this for the timer

import 'pages/Building.dart';
import 'pages/Excels.dart';
import 'pages/ListingBuildings.dart';
import 'pages/LoadImages.dart';
import 'pages/Reports.dart';
import 'pages/generateSchema.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlexThemeData.light(scheme: FlexScheme.hippieBlue),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.hippieBlue),
      themeMode: ThemeMode.system,
      routes: {
        "/home": (context) => const ListingBuildings(),
        "/Excels": (context) => const Excels(),
        "/building": (context) => const Building(),
        "/loadImages": (context) => const LoadImages(),
        "/generateSchema": (context) => const GenerateSchema(),
        "/Reports": (context) => const Reports(),
        "/LoadingPageWait": (context) => const LoadingPageWait(),
      },
      home: const LoadingPage(),
    );
  }
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, "/Excels");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage("images/camusat.png"),
              height: 300,
              width: 300,
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
