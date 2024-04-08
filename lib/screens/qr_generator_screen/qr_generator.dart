import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/qr_generator_screen/qr_generator_view.dart';
import 'package:better_scanner/screens/qr_generator_screen/qr_generator_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QrGeneratorScreen extends StatelessWidget {
  const QrGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var qr = args['qr'] as QrRecordModel?;
    return BlocProvider<QrGeneratorVM>(
      create: (context) => QrGeneratorVM(context: context, qrIn: qr),
      child: const QrGeneratorView(),
    );
  }
}
