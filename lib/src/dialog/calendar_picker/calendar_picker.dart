import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:ruolanui/ruolanui.dart';

import 'widgets/calendar_actions.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/month_nav.dart';
import 'widgets/quick_options.dart';
import 'widgets/weekday_header.dart';

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

  void _handlePeriodOption(PeriodOption option) {
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

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部：标题 + 关闭
          _CalendarHeader(
            title: widget.labels.title,
            onClose: widget.onCancel,
          ),
          // 日历内容区
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isCalendarMode) ...[
                    const WeekdayHeader(),
                    Flexible(
                      child: CalendarGrid(
                        displayMonth: _displayMonth,
                        selectedDate: _selectedDate,
                        minDate: widget.minDate,
                        maxDate: widget.maxDate,
                        onSelectDate: _selectDate,
                        onChangeDisplayMonth: (month) {
                          setState(() => _displayMonth = month);
                        },
                      ),
                    ),
                  ] else
                    Flexible(
                      child: DatePickerWidget(
                        key: ValueKey(
                            'dp_${_selectedDate.millisecondsSinceEpoch}'),
                        mode: DatePickerMode.yearMonthDay,
                        initDate: _selectedDate,
                        minDate: widget.minDate,
                        maxDate: widget.maxDate,
                        onChanged: (date) {
                          _selectedDate = date;
                          _displayMonth =
                              DateTime(date.year, date.month);
                          widget.onChanged?.call(date);
                        },
                      ),
                    ),
                  QuickOptions(
                    isCalendarMode: _isCalendarMode,
                    onToggleMode: () {
                      setState(() => _isCalendarMode = !_isCalendarMode);
                    },
                    showPeriodButtons: widget.showPeriodButtons,
                    periodOptions: widget.periodOptions,
                    onOptionTap: _handlePeriodOption,
                  ),
                ],
              ),
            ),
          ),
          // 底部操作
          CalendarActions(
            confirmText: widget.labels.confirm,
            clearDateText: widget.labels.clearDate,
            showClearDate: widget.showNoDate,
            onConfirm: widget.onConfirm,
            onClearDate: () {
              widget.onChanged?.call(null);
              widget.onConfirm?.call();
            },
          ),
        ],
      ),
    );
  }
}

/// 顶部标题栏
class _CalendarHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;

  const _CalendarHeader({required this.title, this.onClose});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 8, top: 12, bottom: 4),
      child: Row(
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.close,
                size: 22, color: colorScheme.onSurfaceVariant),
            onPressed: onClose,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
