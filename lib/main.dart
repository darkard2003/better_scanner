import 'package:better_scanner/screens/details_screen/details_screen.dart';
import 'package:better_scanner/screens/qr_generator_screen/qr_generator.dart';
import 'package:better_scanner/screens/scanner_screen/scanner_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      ColorScheme light, dark;
      if (lightDynamic != null) {
        light = lightDynamic.harmonized();
      } else {
        light = ColorScheme.fromSeed(seedColor: Colors.cyan);
      }

      if (darkDynamic != null) {
        dark = darkDynamic.harmonized();
      } else {
        dark = ColorScheme.fromSeed(
            seedColor: Colors.cyan, brightness: Brightness.dark);
      }

      return MaterialApp(
        title: 'Better Scanner',
        theme: ThemeData(
          colorScheme: light,
        ),
        darkTheme: ThemeData(
          colorScheme: dark,
        ),
        routes: {
          '/details': (context) => const DetailsScreen(),
          '/generator': (context) => const QrGeneratorScreen(),
          '/scanner': (context) => const ScannerScreen(),
        },
        home: const ScannerScreen(),
      );
    });
  }
}
