import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

import 'options/options_dialog.dart';

/// 显示选项弹窗
Future<Result<int>> showOptionsDialog(
    {required BuildContext context,
    required List<OptionItem> options,
    int? value,
    String cancelText = "取消"}) async {
  final result = await showModalBottomSheet<Result<int>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (c) => OptionsContent(
            options: options,
            value: value,
            cancelText: cancelText,
          ));

  return result ?? Result.failure("Cancel");
}

Future<Result<int>> showSampleOptionsDialog(
    {required BuildContext context,
    required List<String> options,
    int? value,
    String cancelText = "取消"}) async {
  final newOptions = List.generate(
      options.length, (i) => OptionItem(id: i, label: options[i]));
  final result = await showModalBottomSheet<Result<int>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (c) => OptionsContent(
            options: newOptions,
            value: value,
            cancelText: cancelText,
          ));

  return result ?? Result.failure("Cancel");
}
