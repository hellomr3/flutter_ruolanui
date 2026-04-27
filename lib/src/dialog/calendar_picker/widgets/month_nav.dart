import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:intl/intl.dart';
import 'package:ruolanui/ruolanui.dart';

/// 月份导航行：左右箭头 + 年月（可点击弹出滚轮） + 选中日期
class MonthNav extends StatelessWidget {
  final DateTime displayMonth;
  final DateTime selectedDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<int> onChangeMonth;
  final ValueChanged<DateTime> onMonthYearPicked;

  const MonthNav({
    super.key,
    required this.displayMonth,
    required this.selectedDate,
    this.minDate,
    this.maxDate,
    required this.onChangeMonth,
    required this.onMonthYearPicked,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final selectedDateStr = DateFormat('yyyy/MM/dd').format(selectedDate);

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 12, top: 8, bottom: 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 22),
            onPressed: () => onChangeMonth(-1),
            visualDensity: VisualDensity.compact,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              final result = await showRLDatePicker(
                context,
                initDate: displayMonth,
                min: minDate,
                max: maxDate,
                mode: DatePickerMode.yearMonth,
              );
              final newDate = result?.data;
              if (newDate != null) {
                onMonthYearPicked(newDate);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat.yMMMM(locale).format(displayMonth),
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.arrow_drop_down,
                      size: 18, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 22),
            onPressed: () => onChangeMonth(1),
            visualDensity: VisualDensity.compact,
          ),
          const Spacer(),
          Text(
            selectedDateStr,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
