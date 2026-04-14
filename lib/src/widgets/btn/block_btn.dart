import 'package:flutter/material.dart';

class BlockBtn extends StatelessWidget {
  final String title;
  final String? hint;
  final VoidCallback? onTap;
  final IconData? leading;
  final Widget? trailing;
  final bool showDivider;
  final BorderRadius? borderRadius;
  final bool arrow;
  final bool disabled;
  final Color? backgroundColor;
  final EdgeInsets padding;

  const BlockBtn({
    super.key,
    required this.title,
    this.hint,
    this.onTap,
    this.leading,
    this.trailing,
    this.borderRadius,
    this.showDivider = true,
    this.arrow = true,
    this.disabled = false,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  bool get _isTappable => onTap != null && !disabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final hasTitle = title.isNotEmpty;
    final hasHint = hint != null && hint!.isNotEmpty;

    final bgColor = backgroundColor ?? colorScheme.surfaceContainer;

    final border = showDivider
        ? Divider(
            indent: 16,
            endIndent: 16,
            thickness: 0.8,
            height: 0.8,
          )
        : null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _isTappable ? onTap : null,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: borderRadius,
            ),
            padding: padding,
            child: Row(
              children: [
                if (leading != null) ...[
                  Icon(leading, size: 24, color: colorScheme.onSurface),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasTitle) Text(title, style: textTheme.bodyMedium),
                      if (hasTitle && hasHint) const SizedBox(height: 2),
                      if (hasHint) Text(hint!, style: textTheme.labelMedium),
                    ],
                  ),
                ),
                if (trailing != null || _isTappable) ...[
                  const SizedBox(width: 8),
                  if (trailing != null) trailing!,
                  if (_isTappable && arrow) ...[
                    if (trailing != null) const SizedBox(width: 4),
                    Icon(Icons.chevron_right,
                        size: 20, color: colorScheme.onSurfaceVariant),
                  ],
                ],
              ],
            ),
          ),
          if (border != null) border
        ],
      ),
    );
  }
}
