import 'package:flutter/material.dart';

/// 字数统计组件
///
/// 显示当前字数和最大字数，超限时变红提示
class WordCountIndicator extends StatelessWidget {
  /// 当前字数
  final int currentLength;

  /// 最大字数
  final int maxLength;

  const WordCountIndicator({
    super.key,
    required this.currentLength,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final textTheme = Theme.of(context).textTheme;
    final isOverMaxCount = currentLength > maxLength;
    final hasText = currentLength > 0;

    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        children: [
          TextSpan(
            text: currentLength.toString(),
            style: textTheme.bodyMedium!.copyWith(color: colorScheme.primary),
          ),
          TextSpan(
            text: '/$maxLength',
            style: textTheme.bodyMedium,
          ),
          TextSpan(
            text: ' 字',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
