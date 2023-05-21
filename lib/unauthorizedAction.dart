import 'package:flutter/material.dart';

class UnauthorizedActionScreen extends StatelessWidget {
  const UnauthorizedActionScreen({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'Not Allowed Action',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(message, textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
    );
  }
}