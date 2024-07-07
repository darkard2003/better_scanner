import 'package:better_scanner/screens/scanner_screen/scanner_screen_vm.dart';
import 'package:better_scanner/screens/scanner_screen/view/scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScannerScreenVM(context),
      child: const ScannerView(),
    );
  }
}
