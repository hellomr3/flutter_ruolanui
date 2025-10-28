import 'package:flutter/material.dart';

class BaseBtn extends StatelessWidget {
  final String label;
  final double height;
  final double? width;
  final double borderRadius;
  final VoidCallback? onPressed;
  final EdgeInsets edgeInsets;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle? textStyle;

  const BaseBtn({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.height = 44,
    this.width,
    this.borderRadius = 22,
    this.onPressed,
    this.edgeInsets = const EdgeInsets.symmetric(horizontal: 12),
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: height,
      width: width,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: edgeInsets,
          child: Text(
            label,
            style: (textStyle ?? textTheme.titleMedium)!
                .copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
