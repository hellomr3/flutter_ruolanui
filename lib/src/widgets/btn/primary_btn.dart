import 'package:flutter/material.dart';
import 'base_btn.dart';

class PrimaryBtn extends StatelessWidget {
  final String label;
  final double height;
  final double? width;
  final double borderRadius;
  final VoidCallback? onPressed;
  final EdgeInsets edgeInsets;

  const PrimaryBtn({
    super.key,
    required this.label,
    this.height = 44,
    this.width,
    this.borderRadius = 22,
    this.onPressed,
    this.edgeInsets = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return BaseBtn(
      label: label,
      height: height,
      width: width,
      borderRadius: borderRadius,
      onPressed: onPressed,
      edgeInsets: edgeInsets,
      backgroundColor: colorScheme.primary,
      textColor: colorScheme.onPrimary,
      textStyle: textTheme.titleMedium,
    );
  }
}
