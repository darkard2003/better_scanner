import 'package:flutter/material.dart';

class DecoratedTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Function(String) onChanged;
  final double borderRadius;
  final bool obscureText;
  final bool enabled;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Widget? suffix;
  const DecoratedTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.onChanged,
    this.borderRadius = 8.0,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffix: suffix,
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onChanged: onChanged,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
    );
  }
}
