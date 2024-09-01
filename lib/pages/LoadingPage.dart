import 'package:flutter/material.dart';

class LoadingPageWait extends StatelessWidget {
  const LoadingPageWait({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/file.gif', width: 150),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              'Votre rapport est en train d\'être généré...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
