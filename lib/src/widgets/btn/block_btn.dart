import 'package:flutter/material.dart';

/// hint 展示位置
enum BlockBtnHintPosition {
  /// 标题底部（默认）
  below,

  /// 右侧（trailing 区域，箭头左侧）
  trailing,
}

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
  final double indent;
  final double endIndent;
  final BlockBtnHintPosition hintPosition;

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
    this.hintPosition = BlockBtnHintPosition.below,
  });

  bool get _isTappable => onTap != null && !disabled;

  /// 存在 trailing 时，hintPosition 不生效，hint 始终在标题底部
  bool get _showHintAsTrailing =>
      hintPosition == BlockBtnHintPosition.trailing && trailing == null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final hasTitle = title.isNotEmpty;
    final hasHint = hint != null && hint!.isNotEmpty;

    final bgColor = backgroundColor ?? colorScheme.surfaceContainer;

    // 构建 hint Text Widget
    Widget? hintWidget;
    if (hasHint && _showHintAsTrailing) {
      hintWidget = Text(
        hint!,
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

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
                        // hint 在标题底部展示
                        if (hasTitle && hasHint && !_showHintAsTrailing)
                          const SizedBox(height: 2),
                        if (hasHint && !_showHintAsTrailing)
                          Text(
                            hint!,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant
                                  .withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // 后置区域：hint（trailing 模式）+ 自定义 trailing + 箭头
                  if (hintWidget != null || trailing != null || _isTappable) ...[
                    const SizedBox(width: 8),
                    if (hintWidget != null)
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: hintWidget,
                        ),
                      ),
                    if (trailing != null)
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: trailing!,
                        ),
                      ),
                    if (_isTappable && arrow) ...[
                      if (hintWidget != null || trailing != null)
                        const SizedBox(width: 4),
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
                thickness: 0.8,
                indent: indent,
                endIndent: endIndent,
              ),
          ],
        ),
      ),
    );
  }
}
