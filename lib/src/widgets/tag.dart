import 'package:flutter/material.dart';

/// 文本 Tag 的主题配置
class TextTagTheme {
  /// 默认背景色（未选中）
  final Color? backgroundColor;

  /// 选中时的背景色
  final Color? selectedBackgroundColor;

  /// 默认文本样式
  final TextStyle? textStyle;

  /// 选中时的文本样式
  final TextStyle? selectedTextStyle;

  /// 圆角半径，为 null 时使用高度的一半（全圆角）
  final double? borderRadius;

  /// 内边距
  final EdgeInsets padding;

  /// 边框（未选中）
  final BorderSide? border;

  /// 选中时的边框
  final BorderSide? selectedBorder;

  const TextTagTheme({
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.textStyle,
    this.selectedTextStyle,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.border,
    this.selectedBorder,
  });
}

/// 单个文本 Tag
///
/// 支持选中/未选中两种状态，背景、文本样式、圆角均可配置。
/// 默认背景使用 `colorScheme.surfaceContainer`，圆角为高度的一半，
/// 选中时背景变为 `colorScheme.primary`。
class TextTag extends StatelessWidget {
  /// 标签文本，当 [child] 为 null 时显示
  final String label;

  /// 是否选中
  final bool selected;

  /// 点击回调
  final VoidCallback? onTap;

  /// 主题配置
  final TextTagTheme? theme;

  /// 自定义子组件，优先于 [label] 显示
  final Widget? child;

  const TextTag({
    super.key,
    this.label = '',
    this.selected = false,
    this.onTap,
    this.theme,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = theme ?? const TextTagTheme();

    final bgColor = selected
        ? (t.selectedBackgroundColor ?? colorScheme.primary)
        : (t.backgroundColor ?? colorScheme.surfaceContainer);

    final style = selected
        ? (t.selectedTextStyle ??
            textTheme.labelMedium?.copyWith(color: colorScheme.onPrimary))
        : (t.textStyle ??
            textTheme.labelMedium?.copyWith(color: colorScheme.onSurface));

    final border = selected ? t.selectedBorder : t.border;

    return GestureDetector(
      onTap: onTap,
      child: _TextTagBody(
        bgColor: bgColor,
        style: style,
        border: border,
        borderRadius: t.borderRadius,
        padding: t.padding,
        label: label,
        child: child,
      ),
    );
  }
}

/// 内部组件，用于计算全圆角
class _TextTagBody extends StatelessWidget {
  final Color bgColor;
  final TextStyle? style;
  final BorderSide? border;
  final double? borderRadius;
  final EdgeInsets padding;
  final String label;
  final Widget? child;

  const _TextTagBody({
    required this.bgColor,
    required this.style,
    required this.border,
    required this.borderRadius,
    required this.padding,
    required this.label,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    // 预估高度：文本行高 + 上下 padding
    final fontSize = style?.fontSize ?? 12;
    final lineHeight = style?.height ?? 1.2;
    final estimatedHeight = fontSize * lineHeight + padding.vertical;
    final radius = borderRadius ?? estimatedHeight / 2;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: border != null ? Border.fromBorderSide(border!) : null,
      ),
      child: child ?? Text(label, style: style),
    );
  }
}

/// 一组可选择的 TextTag
///
/// 支持单选和多选模式。
class TextTagGroup extends StatelessWidget {
  /// 标签文本列表
  final List<String> labels;

  /// 当前选中的索引集合
  final Set<int> selectedIndices;

  /// 选中状态变化回调
  final ValueChanged<Set<int>>? onChanged;

  /// 是否允许多选
  final bool multiSelect;

  /// 主题配置
  final TextTagTheme? theme;

  /// 标签之间的水平间距
  final double spacing;

  /// 标签之间的垂直间距
  final double runSpacing;

  const TextTagGroup({
    super.key,
    required this.labels,
    this.selectedIndices = const {},
    this.onChanged,
    this.multiSelect = false,
    this.theme,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: List.generate(labels.length, (index) {
        final isSelected = selectedIndices.contains(index);
        return TextTag(
          label: labels[index],
          selected: isSelected,
          theme: theme,
          onTap: onChanged == null
              ? null
              : () {
                  final newSet = Set<int>.from(selectedIndices);
                  if (multiSelect) {
                    if (isSelected) {
                      newSet.remove(index);
                    } else {
                      newSet.add(index);
                    }
                  } else {
                    newSet.clear();
                    if (!isSelected) {
                      newSet.add(index);
                    }
                  }
                  onChanged!(newSet);
                },
        );
      }),
    );
  }
}
