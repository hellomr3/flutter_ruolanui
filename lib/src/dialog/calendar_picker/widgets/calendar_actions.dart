import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

/// 底部操作：确认按钮（整行） + 清除日期文本
class CalendarActions extends StatelessWidget {
  final String confirmText;
  final String clearDateText;
  final bool showClearDate;
  final VoidCallback? onConfirm;
  final VoidCallback? onClearDate;

  const CalendarActions({
    super.key,
    required this.confirmText,
    required this.clearDateText,
    this.showClearDate = true,
    this.onConfirm,
    this.onClearDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryBtn(
            width: double.infinity,
            label: confirmText,
            onPressed: onConfirm,
          ),
          if (showClearDate) ...[
            SizedBox(
              height: 4,
            ),
            TextBtn(
              label: clearDateText,
              width: double.infinity,
              onPressed: onClearDate,
            ),
          ]
        ],
      ),
    );
  }
}
