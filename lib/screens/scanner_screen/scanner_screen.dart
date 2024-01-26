import 'package:better_scanner/screens/error_screen/error_screen.dart';
import 'package:better_scanner/screens/loading_screen/loading_screen.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_bloc.dart';
import 'package:better_scanner/screens/scanner_screen/view/scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  Widget _buildScreen(BuildContext context, ScannerState state) {
    if (state is ScannerStateUninitialized) {
      BlocProvider.of<ScannerBloc>(context).add(ScannerEventInit());
      return const LoadingScreen();
    }
    if (state is ScannerScreenState) {
      return ScannerView(state: state);
    }
    return const ErrorScreen(message: 'Unknown state');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScannerBloc, ScannerState>(
      bloc: BlocProvider.of<ScannerBloc>(context),
      builder: (context, state) {
        return _buildScreen(context, state);
      },
    );
  }
}
