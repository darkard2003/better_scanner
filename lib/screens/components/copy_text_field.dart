import 'package:flutter/material.dart';

class CopyTextField extends StatelessWidget {
  final String title;
  final String text;
  final Widget? trailing;
  final bool obscureText;
  final Function()? onCopy;
  const CopyTextField({
    super.key,
    required this.title,
    required this.text,
    this.onCopy,
    this.trailing,
    this.obscureText = false,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$title: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                obscureText ? "*" * text.length : text,
              ),
            ),
            if (trailing != null) trailing!,
            IconButton(
              icon: const Icon(
                Icons.copy,
              ),
              onPressed: onCopy,
            ),
          ],
        ),
      ),
    );
  }
}
