import 'package:better_scanner/screens/scanner_screen/bloc/state_message.dart';
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

extension SnackbarExtention on StateMessage {
  void show(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 2),
          action: action != null
              ? SnackBarAction(
                  label: action!.name,
                  onPressed: action!.action,
                )
              : null),
    );
  }

  Color get backgroundColor {
    switch (type) {
      case StateMessageType.error:
        return Colors.red;
      case StateMessageType.success:
        return Colors.green;
      case StateMessageType.info:
        return Colors.blue;
    }
  }
}
