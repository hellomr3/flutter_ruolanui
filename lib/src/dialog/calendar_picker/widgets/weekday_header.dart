import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 星期指示器
class WeekdayHeader extends StatelessWidget {
  const WeekdayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();

    final weekdays = List.generate(7, (index) {
      final date = DateTime(2024, 1, 7 + index);
      return DateFormat.E(locale).format(date);
    });

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 4),
      child: Row(
        children: weekdays.map((weekday) {
          return Expanded(
            child: Center(
              child: Text(
                weekday,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
