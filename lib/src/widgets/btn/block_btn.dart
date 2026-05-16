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

  /// 标题最大显示字数，超出截断显示省略号。默认 5。
  final int maxTitleLength;

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
    this.maxTitleLength = 5,
  });

  bool get _isTappable => onTap != null && !disabled;

  /// 存在 trailing 时，hintPosition 不生效，hint 始终在标题底部
  bool get _showHintAsTrailing =>
      hintPosition == BlockBtnHintPosition.trailing && trailing == null;

  /// 右侧是否有展开内容（hint trailing / 自定义 trailing）
  bool get _hasExpandedTrailing =>
      _showHintAsTrailing || trailing != null;

  String get _displayTitle {
    if (maxTitleLength <= 0 || title.length <= maxTitleLength) return title;
    return '${title.substring(0, maxTitleLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final hasTitle = title.isNotEmpty;
    final hasHint = hint != null && hint!.isNotEmpty;

    final bgColor = backgroundColor ?? colorScheme.surfaceContainer;

    // 标题文字区
    final titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasTitle)
          Text(
            _displayTitle,
            style: textTheme.bodyMedium?.copyWith(
              color: disabled ? colorScheme.outline : null,
            ),
          ),
        if (hasTitle && hasHint && !_showHintAsTrailing)
          const SizedBox(height: 2),
        if (hasHint && !_showHintAsTrailing)
          Text(
            hint!,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
      ],
    );

    // 右侧展开区域内容
    List<Widget> trailingChildren() {
      return [
        if (_showHintAsTrailing && hasHint)
          Flexible(
            child: Text(
              hint!,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        if (trailing != null)
          Flexible(child: trailing!),
        if (_isTappable && arrow) ...[
          if (_hasExpandedTrailing) const SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            size: 20,
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
        ],
      ];
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
                  // 标题：有右侧展开内容时用自然宽度，否则 Expanded
                  if (_hasExpandedTrailing)
                    titleColumn
                  else
                    Expanded(child: titleColumn),
                  // 右侧展开区域
                  if (_hasExpandedTrailing) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: trailingChildren(),
                      ),
                    ),
                  ] else if (_isTappable && arrow) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                  ],
                ],
              ),
            ),
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
