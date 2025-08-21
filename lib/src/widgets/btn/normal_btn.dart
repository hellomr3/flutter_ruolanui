import 'package:flutter/material.dart';

class NormalBtn extends StatelessWidget {
  final String label;

  final double height;

  final VoidCallback? onPressed;

  const NormalBtn({
    super.key,
    required this.label,
    this.height = 44,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: height,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainer,
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          onPressed?.call();
        },
        child: Text(
          label,
          style: textTheme.bodyMedium!.copyWith(color: colorScheme.onSurface),
        ),
      ),
    );
  }
}
