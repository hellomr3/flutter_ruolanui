import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

import 'options/options_dialog.dart';

/// 显示选项弹窗
Future<Result<int>> showOptionsDialog({
  required BuildContext context,
  required List<OptionItem> options,
  int? value,
  String? title,
  String cancelText = "取消",
}) async {
  final result = await showModalBottomSheet<Result<int>>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder:
        (c) => OptionsContent(
          options: options,
          value: value,
          title: title,
          cancelText: cancelText,
        ),
  );

  return result ?? Result.failure("Cancel");
}

Future<Result<int>> showSampleOptionsDialog({
  required BuildContext context,
  required List<String> options,
  int? value,
  String? title,
  String cancelText = "取消",
}) async {
  final newOptions = List.generate(
    options.length,
    (i) => OptionItem(id: i, label: options[i]),
  );
  final result = await showModalBottomSheet<Result<int>>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder:
        (c) => OptionsContent(
          options: newOptions,
          value: value,
          title: title,
          cancelText: cancelText,
        ),
  );

  return result ?? Result.failure("Cancel");
}

Future<Result<bool>> showConfirmDialog({
  required BuildContext context,
  String title = "提示",
  required String content,
  String confirmText = "确定",
  String cancelText = "取消",
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder:
        (c) => ConfirmDialog(
          title: title,
          content: content,
          confirmText: confirmText,
          cancelText: cancelText,
        ),
  );

  return result != null ? Result.success(result) : Result.failure("Cancel");
}

/// 显示大量选项弹窗（Wrap 自动换行布局，完全自定义 Item）
///
/// 返回用户确认时选中的索引集合，取消时返回 failure。
/// [itemBuilder] 用于自定义每个选项的渲染。
Future<Result<Set<int>>> showWrapOptionsDialog<T>({
  required BuildContext context,
  required String title,
  Widget? trailing,
  required List<T> options,
  Set<int> initialSelected = const {},
  required Widget Function(
          T item, int index, bool isSelected, VoidCallback onTap)
      itemBuilder,
  double spacing = 10,
  double runSpacing = 10,
  bool multiSelect = true,
  String confirmText = "确定",
  String cancelText = "取消",
}) async {
  final result = await showModalBottomSheet<Result<Set<int>>>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (c) => WrapOptionsDialog<T>(
      title: title,
      trailing: trailing,
      options: options,
      initialSelected: initialSelected,
      itemBuilder: itemBuilder,
      spacing: spacing,
      runSpacing: runSpacing,
      multiSelect: multiSelect,
      confirmText: confirmText,
      cancelText: cancelText,
    ),
  );

  return result ?? Result.failure("Cancel");
}

/// 显示纯文本标签选项弹窗
///
/// 使用 [TextTag] 作为默认 Item 样式。
Future<Result<Set<int>>> showTextWrapOptionsDialog({
  required BuildContext context,
  required String title,
  Widget? trailing,
  required List<String> options,
  Set<int> initialSelected = const {},
  bool multiSelect = true,
  String confirmText = "确定",
  String cancelText = "取消",
}) {
  return showWrapOptionsDialog<String>(
    context: context,
    title: title,
    trailing: trailing,
    options: options,
    initialSelected: initialSelected,
    multiSelect: multiSelect,
    confirmText: confirmText,
    cancelText: cancelText,
    itemBuilder: (item, index, isSelected, onTap) {
      return TextTag(
        label: item,
        selected: isSelected,
        onTap: onTap,
      );
    },
  );
}

/// 显示图标+文本选项弹窗
///
/// 使用 [IconTextOption] 作为默认 Item 样式。
Future<Result<Set<int>>> showIconTextWrapOptionsDialog({
  required BuildContext context,
  required String title,
  Widget? trailing,
  required List<IconOptionItem> options,
  Set<int> initialSelected = const {},
  bool multiSelect = true,
  double spacing = 16,
  double runSpacing = 16,
  String confirmText = "确定",
  String cancelText = "取消",
}) {
  return showWrapOptionsDialog<IconOptionItem>(
    context: context,
    title: title,
    trailing: trailing,
    options: options,
    initialSelected: initialSelected,
    spacing: spacing,
    runSpacing: runSpacing,
    multiSelect: multiSelect,
    confirmText: confirmText,
    cancelText: cancelText,
    itemBuilder: (item, index, isSelected, onTap) {
      return IconTextOption(
        icon: item.icon,
        label: item.label,
        isSelected: isSelected,
        onTap: onTap,
      );
    },
  );
}
