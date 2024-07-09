import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final Color? color;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(color ?? colorScheme.primary),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevation: WidgetStateProperty.all(2),
        foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
      ),
      onPressed: onPressed,
      icon: icon,
      iconSize: 30,
    );
  }
}
