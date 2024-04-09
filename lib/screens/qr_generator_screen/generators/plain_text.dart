import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:better_scanner/screens/qr_generator_screen/qr_generator_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextQrGenerator extends StatefulWidget {
  final QrType type;
  final Function(String) onQrGenerated;
  const TextQrGenerator({
    super.key,
    required this.onQrGenerated,
    required this.type,
  });

  @override
  State<TextQrGenerator> createState() => _TextQrGeneratorState();
}

class _TextQrGeneratorState extends State<TextQrGenerator> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    var vm = context.read<QrGeneratorVM>();
    _controller = TextEditingController(text: vm.state.qrString);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedTextField(
      controller: _controller,
      hintText: 'Enter ${widget.type.name} here',
      labelText: widget.type.name,
      onChanged: (text) => widget.onQrGenerated(text),
    );
  }
}
