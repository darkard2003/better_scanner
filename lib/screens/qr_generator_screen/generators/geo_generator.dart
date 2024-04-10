import 'package:better_scanner/models/qr_models.dart';
import 'package:flutter/material.dart';

class GeoQrGenerator extends StatefulWidget {
  final GeoLocationQr geoQr;
  final Function(String) onQrGenerated;
  const GeoQrGenerator({
    super.key,
    required this.geoQr,
    required this.onQrGenerated,
  });

  @override
  State<GeoQrGenerator> createState() => _GeoQrGeneratorState();
}

class _GeoQrGeneratorState extends State<GeoQrGenerator> {
  late TextEditingController latText;
  late TextEditingController lonText;

  @override
  void initState() {
    super.initState();
    latText = TextEditingController(text: widget.geoQr.latStr);
    lonText = TextEditingController(text: widget.geoQr.lonStr);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
