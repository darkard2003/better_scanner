import 'package:better_scanner/screens/details_screen/details_screen.dart';
import 'package:better_scanner/screens/qr_generator_screen/qr_generator.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_bloc.dart';
import 'package:better_scanner/screens/scanner_screen/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Better Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.cyan, brightness: Brightness.dark),
      ),
      routes: {
        '/details': (context) => const DetailsScreen(),
        '/generator': (context) => const QrGeneratorScreen(),
        '/scanner': (context) => const ScannerScreen(),
      },
      home: BlocProvider<ScannerBloc>(
        create: (context) => ScannerBloc(),
        child: const ScannerScreen(),
      ),
    );
  }
}
