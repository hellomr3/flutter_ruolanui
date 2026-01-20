import 'package:flutter/material.dart';
import 'package:ruolanui/src/dialog/two_pane_selector/selector_item.dart';
import 'package:ruolanui/src/widgets/btn/normal_btn.dart';
import 'package:ruolanui/src/widgets/btn/primary_btn.dart';

import 'default_selected_item.dart';

/// 底部已选择栏组件
class SelectedBottomBar<T extends SelectorItem<ID>, ID>
    extends StatelessWidget {
  /// 已选择的数量
  final int selectedCount;

  /// 最大可选数量
  final int maxSelectedCount;

  /// 已选择的项目构建器（可选，未提供时使用默认样式）
  final Widget Function(BuildContext context, T item, VoidCallback onRemove)?
      selectedItemBuilder;

  /// 已选择的项目列表
  final List<T> selectedItems;

  /// 移除项目的回调
  final void Function(ID itemId) onRemove;

  /// 清除所有选择的回调
  final VoidCallback onClear;

  /// 确认选择的回调
  final VoidCallback onConfirm;

  /// 底部安全区域内边距
  final double bottomPadding;

  /// 顶部内边距
  final double topPadding;

  const SelectedBottomBar({
    super.key,
    required this.selectedCount,
    required this.maxSelectedCount,
    this.selectedItemBuilder,
    required this.selectedItems,
    required this.onRemove,
    required this.onClear,
    required this.onConfirm,
    this.bottomPadding = 0,
    this.topPadding = 12,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding + topPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部栏：左上"已选择"，右上"已选 x/y"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '已选择',
                  style: textTheme.titleLarge,
                ),
                Text(
                  '已选 $selectedCount/$maxSelectedCount',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          // 中间：已选择的 Item 列表
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedItems.map((item) {
                  final builder = selectedItemBuilder ??
                      (context, item, onRemove) => DefaultSelectedItem<T, ID>(
                            item: item,
                            onRemove: onRemove,
                          );
                  return builder(
                    context,
                    item,
                    () => onRemove(item.id),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 底部按钮：左侧清除，右侧确认
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // 左侧清除按钮
                NormalBtn(
                  label: '清除',
                  width: 80,
                  height: 40,
                  onPressed: onClear,
                ),
                const SizedBox(width: 12),
                // 右侧确认按钮，宽度铺满
                Expanded(
                  child: PrimaryBtn(
                    label: '确认选择',
                    height: 40,
                    onPressed: onConfirm,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
