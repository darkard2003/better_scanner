import 'package:flutter/material.dart';

Future<String?> showRenameDialog(BuildContext context, String name) async {
  return await showDialog<String>(
      context: context,
      builder: (context) {
        var controller = TextEditingController(text: name);
        return AlertDialog(
          title: const Text('Rename'),
          content: TextField(
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(
                controller.text.isEmpty ? null : controller.text.trim(),
              ),
              child: const Text('Rename'),
            ),
          ],
        );
      });
}
