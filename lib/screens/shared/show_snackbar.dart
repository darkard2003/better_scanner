import 'package:flutter/material.dart';

enum SnackbarType { success, error, warning }

void showSnackbar(
  BuildContext context,
  String message, {
  SnackbarType type = SnackbarType.success,
}) {
  final snackbar = SnackBar(
    content: Text(message),
    backgroundColor: _getBackgroundColor(type),
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

Color _getBackgroundColor(SnackbarType type) {
  switch (type) {
    case SnackbarType.success:
      return Colors.green;
    case SnackbarType.error:
      return Colors.red;
    case SnackbarType.warning:
      return Colors.yellow;
  }
}
