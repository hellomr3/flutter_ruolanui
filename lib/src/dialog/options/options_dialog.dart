import 'package:flutter/material.dart';

class OptionsContent extends StatelessWidget {
  final int? value;

  final List<String> options;

  final String cancelText;

  final ValueChanged<int?> dismiss;

  const OptionsContent(
      {super.key,
      this.value,
      required this.options,
      required this.dismiss,
      required this.cancelText});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: colorScheme.surfaceContainer,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 选项列表
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => dismiss(index),
                  child: Container(
                    width: double.infinity,
                    // 占满宽度
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    // 调整点击区域高度
                    child: Text(
                      options[index],
                      textAlign: TextAlign.center, // 强制居中
                      style: value == index
                          ? textTheme.titleMedium!
                              .copyWith(color: colorScheme.primary)
                          : textTheme.bodyMedium,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(indent: 12, endIndent: 12, height: 0.5);
              },
            ),

            // 分隔区
            const Divider(height: 0.5),

            // 取消按钮
            ListTile(
              title: Text(
                cancelText,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              onTap: () {
                dismiss(null);
              },
            ),
          ],
        ),
      ),
    );
  }
}
