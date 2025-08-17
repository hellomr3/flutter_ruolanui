import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextBtn(
          label: cancelText,
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop(false);
          },
        ),
        PrimaryBtn(
          label: confirmText,
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
