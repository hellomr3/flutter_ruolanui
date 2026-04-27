import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:intl/intl.dart';
import 'package:ruolanui/ruolanui.dart';

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
  final String confirm;
  final String clearDate;

  const CalendarPickerLabels({
    this.title = '选择日期',
    this.confirm = '确定',
    this.clearDate = '清除日期',
  });
}

/// 弹出日历选择器
Future<Result<DateTime>?> showRLCalendarPicker(
  BuildContext context, {
  DateTime? initDate,
  DateTime? minDate,
  DateTime? maxDate,
  List<PeriodOption>? periodOptions,
  CalendarPickerLabels? labels,
  bool showPeriodButtons = true,
  bool showNoDate = true,
  bool isDismissible = false,
}) async {
  final pickerLabels = labels ?? const CalendarPickerLabels();
  DateTime? selectedDate = initDate ?? DateTime.now();

  return showModalBottomSheet<Result<DateTime>>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
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
        showNoDate: showNoDate,
        onChanged: (date) => selectedDate = date,
        onConfirm: () => Navigator.pop(context, Result.success(selectedDate)),
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
  final bool showNoDate;
  final ValueChanged<DateTime?>? onChanged;
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
    this.showNoDate = true,
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
          Flexible(child: _buildCalendarArea(colorScheme, textTheme)),
          _buildActions(colorScheme, textTheme),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  /// 顶部：左侧标题，右侧关闭按钮
  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 8, top: 12, bottom: 4),
      child: Row(
        children: [
          Text(
            widget.labels.title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.close,
                size: 22, color: colorScheme.onSurfaceVariant),
            onPressed: widget.onCancel,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  /// 日历内容区
  Widget _buildCalendarArea(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isCalendarMode) ...[
            // _buildMonthNav(colorScheme, textTheme),
            _buildWeekdayHeader(colorScheme, textTheme),
            Flexible(child: _buildCalendarGrid(colorScheme, textTheme)),
          ] else
            Flexible(child: _buildDatePicker()),
          _buildQuickOptions(colorScheme, textTheme),
        ],
      ),
    );
  }

  /// 月份导航行（仅日历模式）：左右箭头 + 年月 + 选中日期
  Widget _buildMonthNav(ColorScheme colorScheme, TextTheme textTheme) {
    final locale = Localizations.localeOf(context).toString();
    final selectedDateStr = DateFormat('yyyy/MM/dd').format(_selectedDate);

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 12, top: 8, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 22),
            onPressed: () => _changeMonth(-1),
            visualDensity: VisualDensity.compact,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              final result = await showRLDatePicker(
                context,
                initDate: _displayMonth,
                min: widget.minDate,
                max: widget.maxDate,
                mode: DatePickerMode.yearMonth,
              );
              final newDate = result?.data;
              if (newDate != null) {
                setState(() {
                  _displayMonth = DateTime(newDate.year, newDate.month);
                  _selectedDate = DateTime(
                    newDate.year,
                    newDate.month,
                    _selectedDate.day.clamp(
                        1, DateTime(newDate.year, newDate.month + 1, 0).day),
                  );
                });
                widget.onChanged?.call(_selectedDate);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat.yMMMM(locale).format(_displayMonth),
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
            onPressed: () => _changeMonth(1),
            visualDensity: VisualDensity.compact,
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

  Widget _buildCalendarGrid(ColorScheme colorScheme, TextTheme textTheme) {
    final firstDayOfMonth =
        DateTime(_displayMonth.year, _displayMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_displayMonth.year, _displayMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;

    final days = <Widget>[];

    final prevMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
    final lastDayOfPrevMonth =
        DateTime(_displayMonth.year, _displayMonth.month, 0);
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
    final isDisabled =
        (widget.minDate != null && date.isBefore(widget.minDate!)) ||
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
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
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

  /// 快捷选项行：左侧切换视图按钮 + 快捷选项
  Widget _buildQuickOptions(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 12, bottom: 10, top: 4),
      child: Row(
        children: [
          // 切换视图按钮
          IconButton(
            onPressed: () => setState(() => _isCalendarMode = !_isCalendarMode),
            icon: Icon(
              _isCalendarMode
                  ? Icons.calendar_view_week
                  : Icons.calendar_month_outlined,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (widget.showPeriodButtons && widget.periodOptions.isNotEmpty) ...[
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.periodOptions.map((option) {
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
                        onTap: () {
                          if (option.type == PeriodType.today) {
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

  Widget _buildDatePicker() {
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

  /// 底部操作：确认按钮（整行） + 清除日期文本
  Widget _buildActions(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.onConfirm,
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(widget.labels.confirm),
            ),
          ),
          if (widget.showNoDate)
            GestureDetector(
              onTap: () {
                widget.onChanged?.call(null);
                widget.onConfirm?.call();
              },
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  widget.labels.clearDate,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
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

  newYear = newYear.clamp(1, 9999);

  int newDay = date.day;
  int daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
  if (newDay > daysInNewMonth) {
    newDay = daysInNewMonth;
  }

  return DateTime(newYear, newMonth, newDay, date.hour, date.minute,
      date.second, date.millisecond, date.microsecond);
}
