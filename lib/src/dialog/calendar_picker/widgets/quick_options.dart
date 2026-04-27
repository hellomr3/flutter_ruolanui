import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

/// 快捷选项行：左侧切换视图按钮 + 快捷选项标签
class QuickOptions extends StatelessWidget {
  final bool isCalendarMode;
  final VoidCallback onToggleMode;
  final bool showPeriodButtons;
  final List<PeriodOption> periodOptions;
  final ValueChanged<PeriodOption> onOptionTap;

  const QuickOptions({
    super.key,
    required this.isCalendarMode,
    required this.onToggleMode,
    required this.showPeriodButtons,
    required this.periodOptions,
    required this.onOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 12, bottom: 10, top: 4),
      child: Row(
        children: [
          GestureDetector(
              onTap: onToggleMode,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Icon(
                  isCalendarMode
                      ? Icons.view_week_rounded
                      : Icons.calendar_month_rounded,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
              )),
          if (showPeriodButtons && periodOptions.isNotEmpty) ...[
            const SizedBox(width: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: periodOptions.map((option) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TextTag(
                        label: option.label,
                        theme: TextTagTheme(
                          backgroundColor: colorScheme.surface,
                          textStyle: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                        ),
                        onTap: () => onOptionTap(option),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
