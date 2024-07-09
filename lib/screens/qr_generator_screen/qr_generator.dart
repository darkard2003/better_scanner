import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/qr_generator_screen/qr_generator_view.dart';
import 'package:better_scanner/screens/qr_generator_screen/qr_generator_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QrGeneratorScreen extends StatelessWidget {
  final QrRecordModel? qr;

  const QrGeneratorScreen({super.key, this.qr});

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    var qr = this.qr ?? args?['qr'] as QrRecordModel?;
    return ChangeNotifierProvider<QrGeneratorVM>(
      create: (context) => QrGeneratorVM(context: context, qrIn: qr),
      child: const QrGeneratorView(),
    );
  }
}
