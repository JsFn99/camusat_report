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
            Image.asset('images/file.gif', width: 250),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              'Votre rapport est en train d\'être généré...',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
