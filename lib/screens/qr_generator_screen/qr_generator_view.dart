import 'dart:ui';

import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/components/copy_text_box.dart';
import 'package:better_scanner/screens/components/custom_icon_button.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:better_scanner/screens/qr_generator_screen/generators/qr_generator.dart';
import 'package:better_scanner/screens/qr_generator_screen/qr_generator_vm.dart';
import 'package:better_scanner/screens/shared/show_confirmation_dialog.dart';
import 'package:better_scanner/services/qr_services/qr_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrGeneratorView extends StatelessWidget {
  const QrGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<QrGeneratorVM>();
    var state = vm.state;
    var qrCode = QrCode.fromData(
      data: vm.state.qrString,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    var key = GlobalKey();
    var qrImage = QrImage(qrCode);
    var theme = Theme.of(context);

    var size = MediaQuery.of(context).size;
    var isSmallScreen = size.width < 700;

    var qrView = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.center,
          child: RepaintBoundary(
            key: key,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              child: PrettyQrView(
                qrImage: qrImage,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconButton(
              icon: Icon(
                Icons.save,
                color: theme.colorScheme.onPrimary,
              ),
              onPressed: vm.save,
            ),
            const SizedBox(width: 16),
            CustomIconButton(
              icon: Icon(
                Icons.share,
                color: theme.colorScheme.onPrimary,
              ),
              onPressed: () async {
                var boundary = key.currentContext!.findRenderObject()
                    as RenderRepaintBoundary;
                var image = await boundary.toImage();
                var pngBytes =
                    await image.toByteData(format: ImageByteFormat.png);
                if (pngBytes == null) {
                  return;
                }
                QrServices.shareImage(
                  pngBytes.buffer,
                  vm.qr.displayName,
                );
              },
            ),
            const SizedBox(width: 16),
            CustomIconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ],
    );

    var editingForm = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (var type in vm.availableTypes)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(type.name),
                  selected: state.type == type,
                  onSelected: (selected) async {
                    if (selected) {
                      if (state.qrString.isNotEmpty &&
                          state.qrString != state.type.defaultQrValue) {
                        var confirmed = await showConfiramtionDialog(
                              context,
                              heading: 'Change QR Type?',
                              msg:
                                  'Changing the QR Type will reset the QR data. Are you sure you want to continue?',
                            ) ??
                            false;
                        if (!confirmed) return;
                      }
                      vm.updateType(type);
                    }
                  },
                ),
              ),
          ]),
        ),
        const SizedBox(height: 16),
        DecoratedTextField(
          controller: vm.nameController,
          hintText: 'Enter Name',
          labelText: 'Name',
          onChanged: vm.updateName,
        ),
        const SizedBox(height: 8),
        QrGeneratorField(
          qrStr: state.qrString,
          type: state.type,
          onGenerate: vm.updateQrRecord,
        ),
        const SizedBox(height: 16),
        CopyTextBox(text: state.qrString),
      ],
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 700,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Generate Qr Code',
                  style: theme.textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 16),
            isSmallScreen
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          qrView,
                          const SizedBox(height: 16),
                          editingForm,
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  )
                : Row(
                    children: [
                      qrView,
                      const SizedBox(width: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: editingForm,
                        ),
                      ),
                    ],
                  ),
            if (!isSmallScreen)
              const SizedBox(
                height: 50,
              ),
          ],
        ),
      ),
    );
  }
}
