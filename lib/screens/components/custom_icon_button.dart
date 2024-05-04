import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(colorScheme.primary),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevation: MaterialStateProperty.all(2),
        foregroundColor: MaterialStateProperty.all(colorScheme.onPrimary),
      ),
      onPressed: onPressed,
      icon: icon,
      iconSize: 30,
    );
  }
}
