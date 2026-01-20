import 'package:flutter/material.dart';
import 'package:ruolanui/src/widgets/select/selector_item.dart';
import 'package:ruolanui/src/widgets/select/two_pane_selector.dart';
import 'package:ruolanui/src/widgets/select/two_pane_selector_theme.dart';

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
    required Widget Function(
        BuildContext context,
        T item,
        VoidCallback onRemove,
        ) selectedItemBuilder,
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
      builder: (context) =>
          TwoPaneSelector<T, ID>(
            title: title,
            mode: SelectorMode.single,
            items: items,
            theme: theme,
            initialSelectedIds: initialSelectedId != null
                ? [initialSelectedId]
                : null,
            parentItemBuilder: parentItemBuilder,
            childItemBuilder: childItemBuilder,
            selectedItemBuilder: selectedItemBuilder,
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
            childAllItemBuilder: childAllItemBuilder ??
                _defaultChildAllItemBuilder<T, ID>,
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
    required Widget Function(
        BuildContext context,
        T item,
        VoidCallback onRemove,
        ) selectedItemBuilder,
    Widget? emptyState,
    T? parentAllItem,
    T? Function(ID? parentItemId)? childAllItemBuilder,
    void Function(T? selectedItem)? onItemTap,
  }) async {
    final result = await showModalBottomSheet<List<T>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          TwoPaneSelector<T, ID>(
            title: title,
            mode: SelectorMode.multiple,
            items: items,
            initialSelectedIds: initialSelectedIds,
            parentItemBuilder: parentItemBuilder,
            childItemBuilder: childItemBuilder,
            selectedItemBuilder: selectedItemBuilder,
            emptyState: emptyState,
            onBack: () => Navigator.pop(context),
            onConfirm: (items) => Navigator.pop(context, items),
            parentAllItem: parentAllItem,
            childAllItemBuilder: childAllItemBuilder ??
                _defaultChildAllItemBuilder<T, ID>,
            onItemTap: onItemTap,
          ),
    );

    return result ?? [];
  }

  /// 显示通用选择器弹窗（支持单选和多选模式）
  ///
  /// 返回选中的项目列表
  static Future<List<T>> show<T extends SelectorItem<ID>, ID>({
    required BuildContext context,
    required String title,
    required SelectorMode mode,
    required List<T> items,
    List<ID>? initialSelectedIds,
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
    required Widget Function(
        BuildContext context,
        T item,
        VoidCallback onRemove,
        ) selectedItemBuilder,
    Widget? emptyState,
    Widget? actionButton,
    void Function(T? selectedItem)? onItemTap,
    T? parentAllItem,
    T? Function(ID? parentItemId)? childAllItemBuilder,
  }) async {
    final childBuilder =
        childAllItemBuilder ?? _defaultChildAllItemBuilder<T, ID>;

    if (mode == SelectorMode.single) {
      final result = await showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) =>
            TwoPaneSelector<T, ID>(
              title: title,
              mode: SelectorMode.single,
              items: items,
              initialSelectedIds: initialSelectedIds,
              parentItemBuilder: parentItemBuilder,
              childItemBuilder: childItemBuilder,
              selectedItemBuilder: selectedItemBuilder,
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
              childAllItemBuilder: childBuilder,
            ),
      );
      return result != null ? [result] : [];
    }

    final result = await showModalBottomSheet<List<T>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          TwoPaneSelector<T, ID>(
            title: title,
            mode: SelectorMode.multiple,
            items: items,
            initialSelectedIds: initialSelectedIds,
            parentItemBuilder: parentItemBuilder,
            childItemBuilder: childItemBuilder,
            selectedItemBuilder: selectedItemBuilder,
            emptyState: emptyState,
            onBack: () => Navigator.pop(context),
            onConfirm: (items) => Navigator.pop(context, items),
            parentAllItem: parentAllItem,
            childAllItemBuilder: childBuilder,
            onItemTap: onItemTap,
          ),
    );

    return result ?? [];
  }
}
