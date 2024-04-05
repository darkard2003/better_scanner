import 'package:flutter/material.dart';

class CopyTextBox extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Function()? onCopy;
  final double minHeight;
  const CopyTextBox({
    super.key,
    required this.text,
    this.style,
    this.onCopy,
    this.minHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          constraints: BoxConstraints(minHeight: minHeight),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: Text(
            text,
            style: style,
          ),
        ),
        Positioned(
        top: 0,
        right: 0,
          child: IconButton(
            icon: const Icon(
              Icons.copy,
            ),
            onPressed: onCopy,
          ),
        ),
      ],
    );
  }
}
