import 'package:flutter/material.dart';

/// 日历网格
class CalendarGrid extends StatelessWidget {
  final DateTime displayMonth;
  final DateTime selectedDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime> onSelectDate;
  final ValueChanged<DateTime> onChangeDisplayMonth;

  const CalendarGrid({
    super.key,
    required this.displayMonth,
    required this.selectedDate,
    this.minDate,
    this.maxDate,
    required this.onSelectDate,
    required this.onChangeDisplayMonth,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(displayMonth.year, displayMonth.month, 1);
    final lastDayOfMonth =
        DateTime(displayMonth.year, displayMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;

    final days = <Widget>[];

    // 上月补位
    final prevMonth = DateTime(displayMonth.year, displayMonth.month - 1);
    final lastDayOfPrevMonth =
        DateTime(displayMonth.year, displayMonth.month, 0);
    for (int i = firstWeekday - 1; i >= 0; i--) {
      final day = lastDayOfPrevMonth.day - i;
      days.add(_DayCell(
        date: DateTime(prevMonth.year, prevMonth.month, day),
        selectedDate: selectedDate,
        minDate: minDate,
        maxDate: maxDate,
        isCurrentMonth: false,
        onTap: (date) {
          onChangeDisplayMonth(DateTime(date.year, date.month));
          onSelectDate(date);
        },
      ));
    }

    // 当月
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      days.add(_DayCell(
        date: DateTime(displayMonth.year, displayMonth.month, day),
        selectedDate: selectedDate,
        minDate: minDate,
        maxDate: maxDate,
        isCurrentMonth: true,
        onTap: onSelectDate,
      ));
    }

    // 下月补位
    final nextMonth = DateTime(displayMonth.year, displayMonth.month + 1);
    final remainingCells = 42 - days.length;
    for (int day = 1; day <= remainingCells; day++) {
      days.add(_DayCell(
        date: DateTime(nextMonth.year, nextMonth.month, day),
        selectedDate: selectedDate,
        minDate: minDate,
        maxDate: maxDate,
        isCurrentMonth: false,
        onTap: (date) {
          onChangeDisplayMonth(DateTime(date.year, date.month));
          onSelectDate(date);
        },
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        childAspectRatio: 1.2,
        physics: const NeverScrollableScrollPhysics(),
        children: days,
      ),
    );
  }
}

/// 单个日期格子
class _DayCell extends StatelessWidget {
  final DateTime date;
  final DateTime selectedDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool isCurrentMonth;
  final ValueChanged<DateTime> onTap;

  const _DayCell({
    required this.date,
    required this.selectedDate,
    this.minDate,
    this.maxDate,
    required this.isCurrentMonth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isSelected = date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final isDisabled = (minDate != null && date.isBefore(minDate!)) ||
        (maxDate != null && date.isAfter(maxDate!));

    return GestureDetector(
      onTap: isDisabled ? null : () => onTap(date),
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : isToday
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isToday && !isSelected
              ? Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.4), width: 1)
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? colorScheme.onPrimary
                  : isDisabled
                      ? colorScheme.onSurface.withValues(alpha: 0.25)
                      : !isCurrentMonth
                          ? colorScheme.onSurface.withValues(alpha: 0.35)
                          : colorScheme.onSurface,
              fontWeight:
                  isSelected || isToday ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
