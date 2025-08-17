import 'package:flutter/material.dart';
import 'package:ruolanui/src/core/result.dart';
import 'package:ruolanui/src/widgets/textfield/clear_input_textfield.dart';

/// 优化后的输入弹窗，从底部弹出的同时拉起键盘，支持传入数据校验。
/// 如果已有数据，则会显示在输入框中，并且选中
Future<Result<String>> showBottomInputDialog(
  BuildContext context, {
  required String title,
  required String hintText,
  String? confirmText,
  String? initialValue,
  String? cancelText,
  TextInputType? keyboardType,
}) async {
  final textTheme = Theme.of(context).textTheme;
  final c = Theme.of(context).colorScheme;
  final result = await showModalBottomSheet<Result<String>>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      var inputText = initialValue ?? "";
      return SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Text(title, style: textTheme.titleMedium),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClearInputTextField(
                  hintText: hintText,
                  value: initialValue ?? "",
                  onChange: (v) {
                    inputText = v;
                  },
                  fillColor: c.surfaceContainer,
                  autoFocus: true,
                  keyboardType: keyboardType,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          cancelText ?? "取消",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context, Result.success(inputText));
                        },
                        child: Text(
                          confirmText ?? "确认",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  if (result == null) {
    return Result.failure("取消");
  }
  return result;
}
