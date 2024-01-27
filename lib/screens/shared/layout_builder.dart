import 'package:flutter/material.dart';

enum LayoutType {
  mobile,
  tablet,
  desktop,
}

extension LayoutTypeExtension on LayoutType {
  bool get isMobile => this == LayoutType.mobile;
  bool get isTablet => this == LayoutType.tablet;
  bool get isDesktop => this == LayoutType.desktop;

  static LayoutType fromWidth(double width) {
    if (width < 600) {
      return LayoutType.mobile;
    } else if (width < 1200) {
      return LayoutType.tablet;
    } else {
      return LayoutType.desktop;
    }
  }
}

typedef FunctionBuilder = Widget Function(
    BuildContext context, BoxConstraints constraints, LayoutType type);

class BetterLayoutBuilder extends StatelessWidget {
  final FunctionBuilder builder;
  const BetterLayoutBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return builder(
          context,
          constraints,
          LayoutTypeExtension.fromWidth(constraints.maxWidth),
        );
      }),
    );
  }
}
