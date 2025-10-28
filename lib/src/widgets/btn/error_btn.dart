import 'package:flutter/material.dart';
import 'base_btn.dart';

class ErrorBtn extends StatelessWidget {
  final String label;
  final double height;
  final double borderRadius;
  final VoidCallback? onPressed;

  const ErrorBtn({
    super.key,
    required this.label,
    this.height = 44,
    this.borderRadius = 22,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return BaseBtn(
      label: label,
      height: height,
      borderRadius: borderRadius,
      onPressed: onPressed,
      edgeInsets: EdgeInsets.zero,
      backgroundColor: colorScheme.error,
      textColor: colorScheme.onError,
      textStyle: textTheme.bodyMedium,
    );
  }
}
