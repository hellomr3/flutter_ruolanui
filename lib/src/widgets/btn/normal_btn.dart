import 'package:flutter/material.dart';

class NormalBtn extends StatelessWidget {
  final String label;

  final double height;

  final double borderRadius;

  final VoidCallback? onPressed;

  const NormalBtn({
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
    return SizedBox(
      height: height,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainer,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius), // 设置圆角半径
          ),
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
