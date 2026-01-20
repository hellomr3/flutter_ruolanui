import 'package:flutter/material.dart';
import 'package:ruolanui/src/dialog/two_pane_selector/selector_item.dart';

/// 默认的已选择项目组件
class DefaultSelectedItem<T extends SelectorItem<ID>, ID>
    extends StatelessWidget {
  /// 项目数据
  final T item;

  /// 移除回调
  final VoidCallback onRemove;

  const DefaultSelectedItem({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onRemove,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                item.name,
                style: textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.close,
              size: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
