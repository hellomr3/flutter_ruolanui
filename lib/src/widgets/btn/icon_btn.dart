import 'package:flutter/material.dart';

class IconBtn extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const IconBtn({
    super.key,
    this.icon,
    this.iconWidget,
    this.size = 24,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.padding = const EdgeInsets.all(8),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (icon == null && iconWidget == null) return const SizedBox.shrink();

    final iconColor = color ?? Theme.of(context).colorScheme.onSurfaceVariant;

    final child = iconWidget ??
        Icon(icon, size: size, color: iconColor);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        constraints: BoxConstraints(
          minWidth: size + padding.horizontal,
          minHeight: size + padding.vertical,
        ),
        child: child,
      ),
    );
  }
}
