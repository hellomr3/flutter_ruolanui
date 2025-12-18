import 'package:flutter/material.dart';
import 'package:ruolanui/src/core/result.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 优化后的输入弹窗，使用 TDInputDialog 实现
Future<Result<String>> showBottomInputDialog(
  BuildContext context, {
  required String title,
  required String hintText,
  String? confirmText,
  String? initialValue,
  String? cancelText,
  TextInputType? keyboardType,
}) async {
  final result = await showGeneralDialog<String>(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      final controller = TextEditingController(text: initialValue);

      return TDInputDialog(
        textEditingController: controller,
        title: title,
        hintText: hintText,
        rightBtn: TDDialogButtonOptions(
          title: confirmText ?? "确认",
          action: () {
            Navigator.of(context).pop(controller.text);
          },
        ),
      );
    },
  );

  if (result != null && result.isNotEmpty) {
    return Result.success(result);
  }
  return Result.failure("取消");
}
