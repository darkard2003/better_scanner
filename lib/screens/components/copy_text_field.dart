import 'package:flutter/material.dart';

class CopyTextField extends StatelessWidget {
final String title;
  final String text;
  final Function()? onCopy;
  const CopyTextField({
    super.key,
    required this.title,
    required this.text,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text('$title: '),
          Expanded(
            child: Text(text),
          ),
          IconButton(
            icon: const Icon(
              Icons.copy,
            ),
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }
}
