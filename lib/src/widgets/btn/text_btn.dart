import 'package:flutter/material.dart';

class TextBtn extends StatelessWidget {
  final String label;

  final double height;

  final VoidCallback? onPressed;

  const TextBtn({
    super.key,
    required this.label,
    this.height = 32,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: height,
      child: TextButton(
        style: FilledButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () {
          onPressed?.call();
        },
        child: Text(label, style: textTheme.bodyMedium),
      ),
    );
  }
}
