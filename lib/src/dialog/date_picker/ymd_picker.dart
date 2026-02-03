import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ruolanui/src/widgets/bottom_sheet_header.dart';

/// 日期选择器文案配置
class DatePickerLabels {
  final String title;
  final String cancel;
  final String confirm;

  const DatePickerLabels({
    this.title = '选择日期',
    this.cancel = '取消',
    this.confirm = '确定',
  });
}

/// 日期格式化函数类型
typedef DateFormatter = String Function(int value);

/// 默认日期格式化
String _defaultYearFormatter(int year) => '$year年';

String _defaultMonthFormatter(int month) => '$month月';

String _defaultDayFormatter(int day) => '$day日';

/// 日期选择器主题配置
class DatePickerTheme {
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final Color? highlightColor;
  final double itemHeight;
  final int visibleItemCount;
  final DateFormatter? yearFormatter;
  final DateFormatter? monthFormatter;
  final DateFormatter? dayFormatter;

  const DatePickerTheme({
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.highlightColor,
    this.itemHeight = 44,
    this.visibleItemCount = 5,
    this.yearFormatter,
    this.monthFormatter,
    this.dayFormatter,
  });
}

/// 弹出年月日选择器
Future<DateTime?> showYearMonthDayPicker(
  BuildContext context, {
  DateTime? initDate,
  DateTime? min,
  DateTime? max,
  DatePickerLabels? labels,
  DatePickerTheme? theme,
}) async {
  final pickerLabels = labels ?? const DatePickerLabels();
  final pickerTheme = theme ?? const DatePickerTheme();
  DateTime? selectedDate = initDate;

  return showModalBottomSheet<DateTime>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题栏
          BottomSheetHeader(
            cancelText: pickerLabels.cancel,
            titleText: pickerLabels.title,
            confirmText: pickerLabels.confirm,
            onRightPressed: () => Navigator.pop(context, selectedDate),
          ),
          // 选择器
          YearMonthDayPicker(
            initDate: initDate,
            minDate: min,
            maxDate: max,
            itemExtend: pickerTheme.itemHeight,
            itemCount: pickerTheme.visibleItemCount,
            selectedTextStyle: pickerTheme.selectedTextStyle,
            unselectedTextStyle: pickerTheme.unselectedTextStyle,
            highlightColor: pickerTheme.highlightColor,
            yearFormatter: pickerTheme.yearFormatter,
            monthFormatter: pickerTheme.monthFormatter,
            dayFormatter: pickerTheme.dayFormatter,
            onChanged: (date) {
              selectedDate = date;
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      );
    },
  );
}

class YearMonthDayPicker extends StatefulWidget {
  final DateTime? initDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final double itemExtend;
  final int itemCount;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final Color? highlightColor;
  final DateFormatter? yearFormatter;
  final DateFormatter? monthFormatter;
  final DateFormatter? dayFormatter;
  final ValueChanged<DateTime>? onChanged;

  const YearMonthDayPicker({
    super.key,
    this.initDate,
    this.minDate,
    this.maxDate,
    this.itemExtend = 44,
    this.itemCount = 5,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.highlightColor,
    this.yearFormatter,
    this.monthFormatter,
    this.dayFormatter,
    this.onChanged,
  });

  @override
  State<YearMonthDayPicker> createState() => _YearMonthDayPickerState();
}

class _YearMonthDayPickerState extends State<YearMonthDayPicker> {
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;

  @override
  void initState() {
    super.initState();
    final init = _getValidInitDate();
    selectedYear = init.year;
    selectedMonth = init.month;
    selectedDay = init.day;
    _notifyChange();
  }

  DateTime _getValidInitDate() {
    final init = widget.initDate ?? DateTime.now();
    final min = widget.minDate;
    final max = widget.maxDate;

    if (min != null && init.isBefore(min)) return min;
    if (max != null && init.isAfter(max)) return max;
    return init;
  }

  // --- 逻辑边界计算 ---

  int get minYear => widget.minDate?.year ?? 1900;

  int get maxYear => widget.maxDate?.year ?? 2100;

  int get minMonth {
    if (selectedYear == widget.minDate?.year) return widget.minDate!.month;
    return 1;
  }

  int get maxMonth {
    if (selectedYear == widget.maxDate?.year) return widget.maxDate!.month;
    return 12;
  }

  int get minDay {
    if (selectedYear == widget.minDate?.year &&
        selectedMonth == widget.minDate?.month) {
      return widget.minDate!.day;
    }
    return 1;
  }

  int get maxDay {
    if (selectedYear == widget.maxDate?.year &&
        selectedMonth == widget.maxDate?.month) {
      return widget.maxDate!.day;
    }
    return _daysInMonth(selectedYear, selectedMonth);
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  void _notifyChange() {
    // 确保日期在合法范围内后回调
    widget.onChanged?.call(DateTime(selectedYear, selectedMonth, selectedDay));
  }

  void _handleDateUpdate() {
    setState(() {
      selectedMonth = selectedMonth.clamp(minMonth, maxMonth);
      final daysInCurrentMonth = _daysInMonth(selectedYear, selectedMonth);
      selectedDay =
          selectedDay.clamp(1, daysInCurrentMonth).clamp(minDay, maxDay);
      _notifyChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final selectedStyle = widget.selectedTextStyle ?? textTheme.titleMedium;
    final unselectedStyle = widget.unselectedTextStyle ?? textTheme.bodyMedium;
    final highlightColor =
        widget.highlightColor ?? colorScheme.onSurface.withValues(alpha: 0.1);
    final yearFormatter = widget.yearFormatter ?? _defaultYearFormatter;
    final monthFormatter = widget.monthFormatter ?? _defaultMonthFormatter;
    final dayFormatter = widget.dayFormatter ?? _defaultDayFormatter;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: SizedBox(
        height: widget.itemExtend * 5,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                // 年
                Expanded(
                  child: NumberPicker(
                    value: selectedYear,
                    minValue: minYear,
                    maxValue: maxYear,
                    itemHeight: widget.itemExtend,
                    itemCount: widget.itemCount,
                    selectedTextStyle: selectedStyle,
                    textStyle: unselectedStyle,
                    haptics: true,
                    onChanged: (v) {
                      selectedYear = v;
                      _handleDateUpdate();
                    },
                    textMapper: (i) => yearFormatter(int.parse(i)),
                  ),
                ),
                // 月
                Expanded(
                  child: NumberPicker(
                    value: selectedMonth,
                    minValue: minMonth,
                    maxValue: maxMonth,
                    itemHeight: widget.itemExtend,
                    itemCount: widget.itemCount,
                    selectedTextStyle: selectedStyle,
                    textStyle: unselectedStyle,
                    haptics: true,
                    onChanged: (v) {
                      selectedMonth = v;
                      _handleDateUpdate();
                    },
                    textMapper: (i) => monthFormatter(int.parse(i)),
                  ),
                ),
                // 日
                Expanded(
                  child: NumberPicker(
                    value: selectedDay,
                    minValue: minDay,
                    maxValue: maxDay,
                    itemHeight: widget.itemExtend,
                    itemCount: widget.itemCount,
                    selectedTextStyle: selectedStyle,
                    textStyle: unselectedStyle,
                    haptics: true,
                    onChanged: (v) {
                      selectedDay = v;
                      _handleDateUpdate();
                    },
                    textMapper: (i) => dayFormatter(int.parse(i)),
                  ),
                ),
              ],
            ),
            // 选中框遮罩
            IgnorePointer(
              child: Container(
                height: widget.itemExtend,
                decoration: BoxDecoration(
                  color: highlightColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
