import 'package:flutter/material.dart';

class BlockBtn extends StatelessWidget {
  final String title;
  final String? hint;
  final VoidCallback? onTap;
  final IconData? leading;
  final Widget? leadingWidget;
  final Widget? trailing;
  final bool showDivider;
  final BorderRadius? borderRadius;
  final bool arrow;
  final bool disabled;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final double indent; // 新增：左缩进控制
  final double endIndent; // 新增：右缩进控制

  const BlockBtn({
    super.key,
    required this.title,
    this.hint,
    this.onTap,
    this.leading,
    this.leadingWidget,
    this.trailing,
    this.borderRadius,
    this.showDivider = true,
    this.arrow = true,
    this.disabled = false,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.indent = 16.0,
    this.endIndent = 16.0,
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

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _isTappable ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 主要内容区
            Padding(
              padding: padding,
              child: Row(
                children: [
                  // 前置图标/组件
                  if (leading != null || leadingWidget != null) ...[
                    leadingWidget ??
                        Icon(leading, size: 24, color: colorScheme.onSurface),
                    const SizedBox(width: 12),
                  ],
                  // 中间文字区
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasTitle)
                          Text(
                            title,
                            style: textTheme.bodyMedium?.copyWith(
                              color: disabled ? colorScheme.outline : null,
                            ),
                          ),
                        if (hasTitle && hasHint) const SizedBox(height: 2),
                        if (hasHint)
                          Text(
                            hint!,
                            style: textTheme.labelSmall?.copyWith(
                              color:
                                  colorScheme.onSurfaceVariant.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // 后置组件/箭头
                  if (trailing != null || _isTappable) ...[
                    const SizedBox(width: 8),
                    if (trailing != null)
                      Flexible(child: trailing!),
                    if (_isTappable && arrow) ...[
                      if (trailing != null) const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            // 分割线
            if (showDivider)
              Divider(
                height: 0.8,
                // 占用 1 像素高度
                thickness: 0.8,
                // 线条本身粗细
                indent: indent,
                endIndent: endIndent,
              ),
          ],
        ),
      ),
    );
  }
}
