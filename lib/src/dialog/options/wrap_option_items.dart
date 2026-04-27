import 'package:flutter/material.dart';

/// 图标+文本选项数据模型
class IconOptionItem {
  final IconData icon;
  final String label;

  const IconOptionItem({required this.icon, required this.label});
}

/// 自定义图标区域构建器
///
/// - [isSelected] 当前是否选中
/// - [fgColor] 当前前景色（跟随选中状态变化）
typedef IconWidgetBuilder = Widget Function(bool isSelected, Color fgColor);

/// 图标+文本选项卡片（默认样式）
///
/// 顶部区域默认展示 [icon]，传入 [iconBuilder] 时优先使用自定义组件。
/// 自定义组件会被限制在 [iconSize] x [iconSize] 的区域内。
/// 选中时背景变为 primaryContainer，无边框，纯色区分。
class IconTextOption extends StatelessWidget {
  /// 默认图标，当 [iconBuilder] 为 null 时使用
  final IconData? icon;

  /// 自定义图标区域构建器，优先于 [icon]
  final IconWidgetBuilder? iconBuilder;

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  /// 卡片宽度
  final double width;

  /// 图标区域大小（同时约束自定义 widget 的宽高）
  final double iconSize;

  const IconTextOption({
    super.key,
    this.icon,
    this.iconBuilder,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.width = 72,
    this.iconSize = 28,
  }) : assert(
          icon != null || iconBuilder != null,
          'icon 和 iconBuilder 至少提供一个',
        );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bgColor = isSelected
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainer;
    final fgColor = isSelected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: iconSize,
              height: iconSize,
              child: iconBuilder != null
                  ? iconBuilder!(isSelected, fgColor)
                  : Icon(icon, size: iconSize, color: fgColor),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(color: fgColor),
            ),
          ],
        ),
      ),
    );
  }
}
