import 'package:flutter/material.dart';

class PrimaryBtn extends StatelessWidget {
  final String label;

  final double height;

  final double borderRadius;

  final VoidCallback? onPressed;

  final EdgeInsets edgeInsets;

  const PrimaryBtn({
    super.key,
    required this.label,
    this.height = 44,
    this.borderRadius = 22,
    this.onPressed,
    this.edgeInsets = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: height,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius), // 设置圆角半径
          ),
        ),
        onPressed: () {
          onPressed?.call();
        },
        child: Padding(
          padding: edgeInsets,
          child: Text(
            label,
            style:
                textTheme.titleMedium!.copyWith(color: colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }
}
