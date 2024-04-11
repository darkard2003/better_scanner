import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:better_scanner/screens/shared/show_snackbar.dart';
import 'package:flutter/material.dart';

class GeoQrGenerator extends StatefulWidget {
  final String qrData;
  final Function(String) onQrGenerated;
  const GeoQrGenerator({
    super.key,
    required this.qrData,
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
    var lat = 0.0;
    var lon = 0.0;
    try {
      var parts = GeoLocationQr.parseGeoQrString(widget.qrData);
      lat = parts.$1;
      lon = parts.$2;
    } catch (e) {
      showSnackbar(context, "Faild to parse qr", type: SnackbarType.error);
    }
    latText = TextEditingController(text: lat.toString());
    lonText = TextEditingController(text: lon.toString());
  }

  void onChanged() {
    var lat = double.tryParse(latText.text) ?? 0.0;
    var lon = double.tryParse(lonText.text) ?? 0.0;
    widget.onQrGenerated(GeoLocationQr.getGeoQrString(lat, lon));
  }

  @override
  void dispose() {
    latText.dispose();
    lonText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedTextField(
          labelText: 'Latitude',
          hintText: 'Latitude',
          controller: latText,
          keyboardType: TextInputType.number,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 8),
        DecoratedTextField(
          labelText: 'Longitude',
          hintText: 'Longitude',
          controller: lonText,
          keyboardType: TextInputType.number,
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}
