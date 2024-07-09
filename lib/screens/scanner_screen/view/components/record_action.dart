import 'package:flutter/material.dart';

enum RecordAction {
  tap,
  edit,
  share,
  delete,
  shortcut,
}

extension IconExtension on RecordAction {
  Color? get foregroundColor {
    if (this == RecordAction.delete) {
      return Colors.red;
    }
    return null;
  }

  IconData get icon {
    switch (this) {
      case RecordAction.edit:
        return Icons.edit_outlined;
      case RecordAction.delete:
        return Icons.delete_outlined;
      case RecordAction.share:
        return Icons.share_outlined;
      default:
        return Icons.edit;
    }
  }
}
