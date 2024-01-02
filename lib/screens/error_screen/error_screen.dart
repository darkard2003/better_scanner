import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('Better Scanner'),
      ),
      body: Center(
      child: Text(
        'Error: $message',
        style: const TextStyle(fontSize: 24),
      ),
      ),
    );
  }
}
