import 'package:flutter/material.dart';

class BottomSheetHeader extends StatelessWidget {
  final String cancelText;
  final String? titleText;
  final String confirmText;
  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;
  final bool confirmEnabled;

  const BottomSheetHeader({
    super.key,
    this.cancelText = '取消',
    this.titleText,
    this.confirmText = '确定',
    this.onLeftPressed,
    this.onRightPressed,
    this.confirmEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onLeftPressed ?? () => Navigator.pop(context),
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              cancelText,
              style: textTheme.bodyMedium,
            ),
          ),
        ),
        if (titleText != null)
          Text(
            titleText!,
            style: textTheme.titleMedium,
          ),
        GestureDetector(
          onTap: confirmEnabled ? onRightPressed : null,
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              confirmText,
              style: textTheme.bodyMedium!
                  .copyWith(color: textTheme.titleMedium!.color),
            ),
          ),
        ),
      ],
    );
  }
}
