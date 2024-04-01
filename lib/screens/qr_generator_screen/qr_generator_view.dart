import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:better_scanner/screens/qr_generator_screen/generators/qr_generator.dart';
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
    // ignore: non_const_call_to_literal_constructor
    var theme = Theme.of(context);
    var qrDecoration = PrettyQrDecoration(
      background: theme.colorScheme.onSurface,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Generator'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            child: PrettyQrView(
              decoration: qrDecoration,
              qrImage: qrImage,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: vm.save,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (var type in QrType.values)
                if (type != QrType.unknown)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(type.toString().split('.').last),
                      selected: state.type == type,
                      onSelected: (selected) {
                        if (selected) {
                          vm.updateType(type);
                        }
                      },
                    ),
                  ),
            ]),
          ),
          const SizedBox(height: 16),
          DecoratedTextField(
            hintText: 'Enter Name',
            labelText: 'Name',
            onChanged: vm.updateName,
          ),
          const SizedBox(height: 8),
          QrGenerator(type: state.type, onGenerate: vm.updateQrRecord),
        ],
      ),
    );
  }
}
