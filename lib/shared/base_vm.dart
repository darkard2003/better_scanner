import 'package:flutter/material.dart';

class BaseVM extends ChangeNotifier {
  BuildContext context;
  BaseVM(this.context);

  void safeNotifyListeners() {
    if (!context.mounted) return;
    notifyListeners();
  }

  void safeShowSnackBar(String message, {bool isError = false}) {
    if (!context.mounted) return;
    
  }
}
