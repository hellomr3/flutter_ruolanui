import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:intl/intl.dart';
import 'package:ruolanui/src/widgets/bottom_sheet_header.dart';

import 'date_picker.dart';

/// 时间段类型
enum PeriodType {
  noDate,
  today,
  period,
}

/// 时间段选项配置
class PeriodOption {
  final String label;
  final PeriodType type;
  final int years;
  final int months;
  final int days;

  const PeriodOption({
    required this.label,
    this.type = PeriodType.period,
    this.years = 0,
    this.months = 0,
    this.days = 0,
  });
}

/// 默认的时间段选项配置
class DefaultPeriodOptions {
  static const List<PeriodOption> defaultOptions = [
    PeriodOption(label: '今天', type: PeriodType.today),
    PeriodOption(label: '+1天', days: 1),
    PeriodOption(label: '+7天', days: 7),
    PeriodOption(label: '+1月', months: 1),
    PeriodOption(label: '+1年', years: 1),
  ];
}

/// 日历选择器文案配置
class CalendarPickerLabels {
  final String title;
  final String cancel;
  final String confirm;
  final String noDate;

  const CalendarPickerLabels({
    this.title = '选择日期',
    this.cancel = '取消',
    this.confirm = '确定',
    this.noDate = '无日期',
  });
}

/// 弹出日历选择器
Future<DateTime?> showRLCalendarPicker(
  BuildContext context, {
  DateTime? initDate,
  DateTime? minDate,
  DateTime? maxDate,
  List<PeriodOption>? periodOptions,
  CalendarPickerLabels? labels,
  bool showPeriodButtons = true,
}) async {
  final pickerLabels = labels ?? const CalendarPickerLabels();
  DateTime? selectedDate;

  return showModalBottomSheet<DateTime?>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (context) {
      return CalendarPickerWidget(
        initDate: initDate,
        minDate: minDate,
        maxDate: maxDate,
        periodOptions: periodOptions ?? DefaultPeriodOptions.defaultOptions,
        labels: pickerLabels,
        showPeriodButtons: showPeriodButtons,
        onChanged: (date) => selectedDate = date,
        onConfirm: () => Navigator.pop(context, selectedDate),
        onCancel: () => Navigator.pop(context),
      );
    },
  );
}

class CalendarPickerWidget extends StatefulWidget {
  final DateTime? initDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final List<PeriodOption> periodOptions;
  final CalendarPickerLabels labels;
  final bool showPeriodButtons;
  final ValueChanged<DateTime>? onChanged;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const CalendarPickerWidget({
    super.key,
    this.initDate,
    this.minDate,
    this.maxDate,
    required this.periodOptions,
    required this.labels,
    this.showPeriodButtons = true,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
  });

  @override
  State<CalendarPickerWidget> createState() => _CalendarPickerWidgetState();
}

class _CalendarPickerWidgetState extends State<CalendarPickerWidget> {
  late DateTime _displayMonth;
  late DateTime _selectedDate;
  bool _isCalendarMode = true;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initDate ?? DateTime.now();
    _displayMonth = DateTime(_selectedDate.year, _selectedDate.month);
    widget.onChanged?.call(_selectedDate);
  }

  void _selectDate(DateTime date) {
    setState(() => _selectedDate = date);
    widget.onChanged?.call(date);
  }

  void _selectPeriodOption(PeriodOption option) {
    DateTime date;
    if (option.type == PeriodType.today) {
      date = DateTime.now();
    } else {
      date = addPeriod(_selectedDate, option);
    }
    
    date = _clampDateToRange(date);
    setState(() {
      _selectedDate = date;
      _displayMonth = DateTime(date.year, date.month);
    });
    widget.onChanged?.call(date);
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + delta);
    });
  }

  DateTime _clampDateToRange(DateTime date) {
    if (widget.minDate != null && date.isBefore(widget.minDate!)) {
      return widget.minDate!;
    }
    if (widget.maxDate != null && date.isAfter(widget.maxDate!)) {
      return widget.maxDate!;
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(colorScheme, textTheme),
          if (_isCalendarMode) ...[
            _buildWeekdayHeader(colorScheme, textTheme),
            Flexible(child: _buildCalendarGrid(colorScheme, textTheme)),
          ] else
            Flexible(child: _buildDatePicker(colorScheme, textTheme)),
          if (widget.showPeriodButtons)
            _buildQuickButtons(colorScheme, textTheme),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    final locale = Localizations.localeOf(context).toString();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onCancel,
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                widget.labels.cancel,
                style: textTheme.bodyMedium,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeMonth(-1),
          ),
          InkWell(
            onTap: () async {
              final result = await showRLDatePicker(
                context,
                initDate: _displayMonth,
                min: widget.minDate,
                max: widget.maxDate,
                mode: DatePickerMode.yearMonth,
              );
              if (result != null) {
                setState(() {
                  _displayMonth = DateTime(result.year, result.month);
                  _selectedDate = DateTime(result.year, result.month, _selectedDate.day.clamp(1, DateTime(result.year, result.month + 1, 0).day));
                });
                widget.onChanged?.call(_selectedDate);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat.yMMMM(locale).format(_displayMonth),
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, size: 20, color: colorScheme.onSurface),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeMonth(1),
          ),
          const Spacer(),
          GestureDetector(
            onTap: widget.onConfirm,
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                widget.labels.confirm,
                style: textTheme.bodyMedium?.copyWith(color: textTheme.titleMedium?.color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader(ColorScheme colorScheme, TextTheme textTheme) {
    final locale = Localizations.localeOf(context).toString();
    final weekdays = List.generate(7, (index) {
      final date = DateTime(2024, 1, 7 + index);
      return DateFormat.E(locale).format(date);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: weekdays.map((weekday) {
          return Expanded(
            child: Center(
              child: Text(
                weekday,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(ColorScheme colorScheme, TextTheme textTheme) {
    final firstDayOfMonth = DateTime(_displayMonth.year, _displayMonth.month, 1);
    final lastDayOfMonth = DateTime(_displayMonth.year, _displayMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;

    final days = <Widget>[];

    final prevMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
    final lastDayOfPrevMonth = DateTime(_displayMonth.year, _displayMonth.month, 0);
    for (int i = firstWeekday - 1; i >= 0; i--) {
      final day = lastDayOfPrevMonth.day - i;
      days.add(_buildDayCell(
        DateTime(prevMonth.year, prevMonth.month, day),
        colorScheme,
        textTheme,
        isCurrentMonth: false,
      ));
    }

    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      days.add(_buildDayCell(
        DateTime(_displayMonth.year, _displayMonth.month, day),
        colorScheme,
        textTheme,
        isCurrentMonth: true,
      ));
    }

    final nextMonth = DateTime(_displayMonth.year, _displayMonth.month + 1);
    final remainingCells = 42 - days.length;
    for (int day = 1; day <= remainingCells; day++) {
      days.add(_buildDayCell(
        DateTime(nextMonth.year, nextMonth.month, day),
        colorScheme,
        textTheme,
        isCurrentMonth: false,
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: days,
      ),
    );
  }

  Widget _buildDayCell(
    DateTime date,
    ColorScheme colorScheme,
    TextTheme textTheme, {
    required bool isCurrentMonth,
  }) {
    final isSelected = date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
    final isToday = date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;
    final isDisabled = (widget.minDate != null && date.isBefore(widget.minDate!)) ||
        (widget.maxDate != null && date.isAfter(widget.maxDate!));

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              if (!isCurrentMonth) {
                setState(() {
                  _displayMonth = DateTime(date.year, date.month);
                });
              }
              _selectDate(date);
            },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : isToday
                  ? colorScheme.primary.withOpacity(0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: textTheme.bodyLarge?.copyWith(
              color: isSelected
                  ? colorScheme.onPrimary
                  : isDisabled
                      ? colorScheme.onSurface.withOpacity(0.3)
                      : !isCurrentMonth
                          ? colorScheme.onSurface.withOpacity(0.4)
                          : colorScheme.onSurface,
              fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickButtons(ColorScheme colorScheme, TextTheme textTheme) {
    final allOptions = [
      PeriodOption(label: widget.labels.noDate, type: PeriodType.noDate),
      ...widget.periodOptions,
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allOptions.map((option) {
                return TextButton(
                  onPressed: () {
                    if (option.type == PeriodType.noDate) {
                      Navigator.pop(context, null);
                    } else if (option.type == PeriodType.today) {
                      final today = _clampDateToRange(DateTime.now());
                      setState(() {
                        _selectedDate = today;
                        _displayMonth = DateTime(today.year, today.month);
                      });
                      widget.onChanged?.call(today);
                    } else {
                      _selectPeriodOption(option);
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    option.label,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(_isCalendarMode ? Icons.view_list : Icons.calendar_month),
            onPressed: () {
              setState(() {
                _isCalendarMode = !_isCalendarMode;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(ColorScheme colorScheme, TextTheme textTheme) {
    return DatePickerWidget(
      key: ValueKey('date_picker_${_selectedDate.millisecondsSinceEpoch}'),
      mode: DatePickerMode.yearMonthDay,
      initDate: _selectedDate,
      minDate: widget.minDate,
      maxDate: widget.maxDate,
      onChanged: (date) {
        _selectedDate = date;
        _displayMonth = DateTime(date.year, date.month);
        widget.onChanged?.call(date);
      },
    );
  }
}

/// 根据PeriodOption添加时间
DateTime addPeriod(DateTime date, PeriodOption option) {
  DateTime result = date;

  if (option.days != 0) {
    result = result.add(Duration(days: option.days));
  }

  if (option.months != 0) {
    result = addMonths(result, option.months);
  }

  if (option.years != 0) {
    result = addMonths(result, option.years * 12);
  }

  return result;
}

/// 安全地给日期添加月份
DateTime addMonths(DateTime date, int months) {
  int newYear = date.year;
  int newMonth = date.month + months;

  while (newMonth > 12) {
    newYear++;
    newMonth -= 12;
  }

  while (newMonth < 1) {
    newYear--;
    newMonth += 12;
  }

  int newDay = date.day;
  int daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
  if (newDay > daysInNewMonth) {
    newDay = daysInNewMonth;
  }

  return DateTime(newYear, newMonth, newDay, date.hour, date.minute,
      date.second, date.millisecond, date.microsecond);
}
