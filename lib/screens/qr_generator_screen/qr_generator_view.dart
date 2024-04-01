import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/qr_generator_screen/qr_generator_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrGeneratorView extends StatelessWidget {
  const QrGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<QrGeneratorVM>();
    var state = vm.state;
    var qrCode = QrCode.fromData(
      data: state.qrRecord.data,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    var qrImage = QrImage(qrCode);
    var qrDecoration = PrettyQrDecoration(
      backgroundColor: Colors.black,
    );
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Generator'),
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            child: PrettyQrView(qrImage: qrImage),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              var type = QrType.values[i];
              return ChoiceChip(
                label: Text(type.name),
                selected: state.type == type,
                onSelected: (selected) {
                  if (selected) {
                    vm.updateType(type);
                  }
                },
              );
            },
            itemCount: QrType.values.length,
          ),
        ],
      ),
    );
  }
}
