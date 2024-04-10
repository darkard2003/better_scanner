import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/screens/components/copy_text_field.dart';
import 'package:flutter/material.dart';

class GeoDetailsField extends StatelessWidget {
  final void Function(String)? onCopyLat;
  final void Function(String)? onCopyLong;
  final void Function(String)? onCopyLatLong;
  final GeoLocationQr geo;
  const GeoDetailsField({
    super.key,
    required this.geo,
    this.onCopyLat,
    this.onCopyLong,
    this.onCopyLatLong,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CopyTextField(
          title: "Latitude",
          text: "${geo.latitude}",
          onCopy: () => onCopyLat?.call("${geo.latitude}"),
        ),
        const SizedBox(height: 8),
        CopyTextField(
          title: "Longitude",
          text: "${geo.longitude}",
          onCopy: () => onCopyLong?.call("${geo.longitude}"),
        ),
        const SizedBox(height: 8),
        CopyTextField(
          title: "Latitude, Longitude",
          text: "${geo.latitude}, ${geo.longitude}",
          onCopy: () =>
              onCopyLatLong?.call("${geo.latitude}, ${geo.longitude}"),
        ),
      ],
    );
  }
}
