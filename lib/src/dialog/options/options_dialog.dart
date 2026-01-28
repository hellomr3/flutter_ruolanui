import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

class OptionsContent extends StatelessWidget {
  final int? value;

  final List<OptionItem> options;

  final String cancelText;

  const OptionsContent(
      {super.key, this.value, required this.options, required this.cancelText});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: colorScheme.surface,
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
              padding: const EdgeInsets.only(top: 0),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = value == option.id;
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () =>
                      Navigator.pop(context, Result.success(option.id)),
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          option.label,
                          textAlign: TextAlign.center,
                          style: isSelected
                              ? textTheme.titleMedium!
                                  .copyWith(color: colorScheme.primary)
                              : textTheme.bodyMedium,
                        ),
                        if (option.desc != null) ...[
                          Text(
                            option.desc!,
                            textAlign: TextAlign.center,
                            style: textTheme.labelSmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(height: 0.5);
              },
            ),

            // 分隔区
            Container(
              height: 8,
              color: colorScheme.surfaceContainer,
            ),

            // 取消按钮
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                height: 54,
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  cancelText,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
