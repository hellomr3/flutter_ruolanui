import 'package:flutter/material.dart';

import 'selector_item.dart';
import 'two_pane_selector.dart';
import 'two_pane_selector_theme.dart';

/// 选择模式
enum SelectorMode { single, multiple }

/// 通用的选择器弹窗工具类
/// 使用 ModalSheet 和 Navigator 实现弹窗
class SelectorDialog {
  /// 默认的 childAllItemBuilder，返回 null（不显示二级"全部"）
  static T? _defaultChildAllItemBuilder<T extends SelectorItem<ID>, ID>(
          ID? parentItemId) =>
      null;

  /// 显示单选选择器弹窗
  ///
  /// 返回选中的项目，如果取消选择则返回 null
  static Future<T?> showSingle<T extends SelectorItem<ID>, ID>({
    required BuildContext context,
    required String title,
    required List<T> items,
    ID? initialSelectedId,
    TwoPaneSelectorTheme? theme,
    required Widget Function(
      BuildContext context,
      T item,
      bool isSelected,
      bool hasSelectedItems,
    ) parentItemBuilder,
    required Widget Function(
      BuildContext context,
      T item,
      bool isSelected,
    ) childItemBuilder,
    Widget? emptyState,
    Widget? actionButton,
    T? parentAllItem,
    T? Function(ID? parentItemId)? childAllItemBuilder,
    void Function(T? selectedItem)? onItemTap,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) => TwoPaneSelector<T, ID>(
        title: title,
        mode: SelectorMode.single,
        items: items,
        theme: theme,
        initialSelectedIds:
            initialSelectedId != null ? [initialSelectedId] : null,
        parentItemBuilder: parentItemBuilder,
        childItemBuilder: childItemBuilder,
        emptyState: emptyState,
        actionButton: actionButton,
        onBack: () => Navigator.pop(context),
        onItemTap: (item) {
          // 调用外部回调（可用于埋点等）
          onItemTap?.call(item);
          // 处理返回逻辑（关闭弹窗并返回数据）
          Navigator.pop(context, item);
        },
        parentAllItem: parentAllItem,
        childAllItemBuilder:
            childAllItemBuilder ?? _defaultChildAllItemBuilder<T, ID>,
      ),
    );
  }

  /// 显示多选选择器弹窗
  ///
  /// 返回选中的项目列表，如果取消选择则返回空列表
  static Future<List<T>> showMultiple<T extends SelectorItem<ID>, ID>({
    required BuildContext context,
    required String title,
    required List<T> items,
    List<ID>? initialSelectedIds,
    TwoPaneSelectorTheme? theme,
    required Widget Function(
      BuildContext context,
      T item,
      bool isSelected,
      bool hasSelectedItems,
    ) parentItemBuilder,
    required Widget Function(
      BuildContext context,
      T item,
      bool isSelected,
    ) childItemBuilder,
    Widget Function(
      BuildContext context,
      T item,
      VoidCallback onRemove,
    )? selectedItemBuilder,
    Widget? emptyState,
    T? parentAllItem,
    T? Function(ID? parentItemId)? childAllItemBuilder,
    void Function(T? selectedItem)? onItemTap,
    int maxSelectedCount = 5,
    VoidCallback? onMaxLimitReached,
  }) async {
    final result = await showModalBottomSheet<List<T>>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) => TwoPaneSelector<T, ID>(
        title: title,
        mode: SelectorMode.multiple,
        items: items,
        theme: theme,
        initialSelectedIds: initialSelectedIds,
        parentItemBuilder: parentItemBuilder,
        childItemBuilder: childItemBuilder,
        selectedItemBuilder: selectedItemBuilder,
        emptyState: emptyState,
        onBack: () => Navigator.pop(context),
        onConfirm: (items) => Navigator.pop(context, items),
        parentAllItem: parentAllItem,
        childAllItemBuilder:
            childAllItemBuilder ?? _defaultChildAllItemBuilder<T, ID>,
        onItemTap: onItemTap,
        maxSelectedCount: maxSelectedCount,
        onMaxLimitReached: onMaxLimitReached,
      ),
    );

    return result ?? [];
  }
}
