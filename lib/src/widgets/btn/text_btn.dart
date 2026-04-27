import 'package:flutter/material.dart';

class TextBtn extends StatelessWidget {
  final String label;

  final double height;

  final double? width;

  final VoidCallback? onPressed;

  final Color? textColor;

  const TextBtn({
    super.key,
    required this.label,
    this.width,
    this.height = 44,
    this.onPressed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        style: FilledButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () {
          onPressed?.call();
        },
        child: Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
